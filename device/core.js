'use strict';
const PC = ['C','C#','D','Eb','E','F','F#','G','Ab','A','Bb','B'];
const SHARP = ['C','^C','D','^D','E','F','^F','G','^G','A','^A','B'];
const TYPES = [['',[0,4,7]],['m',[0,3,7]],['7',[0,4,7,10]],['maj7',[0,4,7,11]],['m7',[0,3,7,10]],['dim',[0,3,6]],['dim7',[0,3,6,9]],['m7b5',[0,3,6,10]],['aug',[0,4,8]],['sus2',[0,2,7]],['sus4',[0,5,7]],['6',[0,4,7,9]],['m6',[0,3,7,9]],['9',[0,2,4,7,10]],['m9',[0,2,3,7,10]],['add9',[0,2,4,7]]];
function assert(ok,msg) { if(!ok) throw new Error(msg); }
function note(p) { const oct=Math.floor(p/12)-5; return SHARP[p%12]+(oct>0?"'".repeat(oct):','.repeat(-oct)); }
function chord(pitches) {
 const ps=[...new Set(pitches.map(p=>p%12))].sort((a,b)=>a-b), bass=Math.min(...pitches)%12;
 const candidates=[];
 for(const root of ps) for(const [suffix,intervals] of TYPES) {
  const expected=intervals.map(x=>(x+root)%12).sort((a,b)=>a-b);
  if(JSON.stringify(ps)===JSON.stringify(expected)) candidates.push({root,suffix});
 }
 candidates.sort((a,b)=>(a.root===bass?-1:0)-(b.root===bass?-1:0));
 if(!candidates.length) return {name:ps.length===1?PC[ps[0]]:null,ambiguous:ps.length!==1};
 const c=candidates[0];
 return {name:PC[c.root]+c.suffix+(bass!==c.root?'/'+PC[bass]:''),ambiguous:candidates.length>1};
}
function expand(clip,total,grid) {
 const start=clip.looping?clip.loopStart:clip.startMarker, end=clip.looping?clip.loopEnd:clip.endMarker, span=end-start;
 assert(Number.isFinite(span)&&span>0,'A source clip has an invalid loop or marker range.');
 const result=[];
 for(let offset=0;offset<total-1e-8;offset+=span) {
  for(const n of clip.notes) {
   if(n.mute||n.probability===0||n.duration<=0) continue;
   let a=Math.max(start,n.start_time), b=Math.min(end,n.start_time+n.duration);
   if(b<=a) continue;
   a=Math.max(0,Math.round((a-start+offset)/grid)*grid); b=Math.min(total,Math.round((b-start+offset)/grid)*grid);
   if(b>a) result.push({pitch:n.pitch,start:a,end:b});
  }
  if(!clip.looping) break;
 }
 return result;
}
function length(n) { return n===1?'':String(n); }
// Retain the native two-voice layout. Apply part suppression only to request copies.
function modeABC(abc,mode='vocals') {
 assert(['vocals','instrumental','combined'].includes(mode),'Unknown generation mode.');
 const source=String(abc).replace(/(V:\s*)Harmony\b/g,'$1Vocal')
  .replace(/name="Harmony"/g,'name="Vocal"');
 let voice=null;
 function select(id) {
  assert(id==='Vocal'||id==='Ins','Use native ABC voices Vocal and Ins; unsupported voice: '+id);
  voice=id;
 }
 return source.split(/\r?\n/).map(line=>{
  const declaration=line.match(/^V:\s*(\w+)\b/);
  if(declaration){select(declaration[1]);return line;}
  if(/^\s*(?:%|$)/.test(line))return line;
  if(/^[A-Za-z]:/.test(line)) {
   assert(!/^[wW]:/.test(line),'Put lyrics in the Lyrics field, not ABC w: fields.');
   return line;
  }
  let result='',pos=0;
  // Tokenise before replacing: never edit chord names, voice IDs, or comments as notes.
  const token=/\[V:\s*(Vocal|Ins)\s*\]|"[^"\r\n]*"|%.*$|\[[KMLQ]:[^\]]+\]|\[(?:[=^_]*[A-Ga-g][,']*)+\](?:\d+(?:\/\d*)?|\/+\d*)?-?|[=^_]*[A-Ga-g][,']*(?:\d+(?:\/\d*)?|\/+\d*)?-?|[zZxX](?:\d+(?:\/\d*)?|\/+\d*)?|[\s|]+/gy;
  while(pos<line.length) {
   token.lastIndex=pos;const m=token.exec(line);
   assert(m,'Unsupported ABC near "'+line.slice(pos,pos+24)+'". Use plain notes, rests and native Vocal/Ins voices.');
   let value=m[0];pos=token.lastIndex;
   if(m[1])select(m[1]);
   else if(!/^(?:\s|\||"|%|\[[KMLQ]:)/.test(value)) {
    assert(voice,'ABC music needs a V: Vocal or V: Ins declaration.');
    const mute=(mode==='instrumental'&&voice==='Vocal')||(mode==='vocals'&&voice==='Ins');
    if(mute&&!/^[zZxX]/.test(value)) {
     const duration=value.match(/(?:\d+(?:\/\d*)?|\/+\d*)(?=-?$)/);
     value='z'+(duration?duration[0]:'');
    }
   }
   result+=value;
  }
  return result;
 }).join('\n');
}
function build(snapshot,options={}) {
 const bars=Number(options.bars||8), tempo=Number(snapshot.tempo), num=Number(snapshot.numerator),den=Number(snapshot.denominator);
 assert(Number.isInteger(bars)&&bars>=1&&bars<=128,'Bars must be a whole number from 1 to 128.');
 assert(tempo>0&&num>0&&den>0,'Live tempo or meter is missing.');
 const bar=num*4/den,total=bar*bars,grid=0.125,warnings=[];
 assert(snapshot.clips&&snapshot.clips.length,'Add at least one Session MIDI clip.');
 const chordNotes=[],bassNotes=[];
 for(const c of snapshot.clips) {
  const notes=expand(c,total,grid); (c.role==='bass'?bassNotes:chordNotes).push(...notes);
  if(c.notes.some(n=>n.probability>0&&n.probability<1)) warnings.push(c.name+': probability is exported as a fixed score.');
 }
 assert(chordNotes.length+bassNotes.length>0,'The source range contains no active notes.');
 const key=String(options.key||'auto').trim();
 const musicalKey=key.toLowerCase()==='auto'?PC[snapshot.root||0]+' '+(snapshot.scale||'Major'):key;
 const boundaries=[0,total];
 for(let t=bar;t<total;t+=bar) boundaries.push(t);
 for(const n of chordNotes.concat(bassNotes)) boundaries.push(n.start,n.end);
 const times=[...new Set(boundaries)].sort((a,b)=>a-b), segments=[];
 for(let i=0;i<times.length-1;i++) {
  const a=times[i], b=times[i+1];
  const cp=chordNotes.filter(n=>n.start<=a+1e-8&&n.end>a+1e-8).map(n=>n.pitch);
  const bp=bassNotes.filter(n=>n.start<=a+1e-8&&n.end>a+1e-8).map(n=>n.pitch);
  const c=cp.length?chord(cp):{name:null,ambiguous:false};
  if(cp.length&&!c.name) warnings.push('Unrecognized chord at beat '+(a+1)+': '+[...new Set(cp.map(p=>PC[p%12]))].join(', ')+'. Preserved as simultaneous notes.');
  if(c.ambiguous&&c.name) warnings.push('Ambiguous chord at beat '+(a+1)+': review '+c.name+'.');
  segments.push({start:a,end:b,chord:c.name,unknown:cp.length&&!c.name?[...new Set(cp)].sort((x,y)=>x-y):[],bass:bp.length?Math.min(...bp):null});
 }
 assert(!/[\r\n]/.test(musicalKey),'Key must fit on one line.');
 const km=musicalKey.match(/^([A-Ga-g])([#b]?)(.*)$/);
 assert(km,'Key must start with a note, for example D minor.');
 const modes={'':'','major':'','ionian':'','minor':'m','natural minor':'m','aeolian':'m','m':'m','dorian':'dor','phrygian':'phr','lydian':'lyd','mixolydian':'mix','locrian':'loc'};
 const mode=km[3].trim().toLowerCase();
 const abcKey=Object.hasOwn(modes,mode)?km[1].toUpperCase()+km[2]+modes[mode]:'C';
 if(!Object.hasOwn(modes,mode))warnings.push('Scale '+musicalKey+' is carried in the prompt; ABC uses explicit pitches with K:C.');
 const header=['X:1','T:Session loop','M:'+num+'/'+den,'L:1/32','Q:1/4='+tempo,'V: Vocal clef=treble name="Vocal"','V: Ins clef=bass name="Bass / harmony"','K:'+abcKey,'% Tonal context: '+musicalKey,'% verse'];
 function voice(which) {
  const lines=[];
  for(let b=0;b<bars;b++) {
   const segs=segments.filter(s=>s.start>=b*bar-1e-8&&s.start<(b+1)*bar-1e-8);
   let last=null,parts=[];
   for(const s of segs) {
    const units=Math.round((s.end-s.start)*8);
    const explicit=p=>note(p).replace(/^([A-G])/, '=$1');
    let token='z';
    if(which==='ins'&&s.bass!==null) token=explicit(s.bass);
    else if(which==='ins'&&s.unknown.length) token='['+s.unknown.map(explicit).join('')+']';
    const label=which==='vocal'&&s.chord&&s.chord!==last?'"'+s.chord+'"':'';
    const next=segments[segments.indexOf(s)+1];
    const tied=which==='ins'&&s.bass!==null&&next&&next.bass===s.bass&&bassNotes.some(n=>n.pitch===s.bass&&n.start<s.end-1e-8&&n.end>s.end+1e-8);
    parts.push(label+token+length(units)+(tied?'-':'')); last=s.chord;
   }
   lines.push(parts.join(' ')+'|');
  }
  return lines.join('\n');
 }
 const abc=header.concat(['V: Vocal',voice('vocal'),'V: Ins',voice('ins')]).join('\n');
 return {abc,seconds:total*60/tempo,key:musicalKey,tempo,bars,segments,warnings:[...new Set(warnings)],sources:snapshot.clips.map(c=>c.name+' ('+c.role+')')};
}
function prompt(settings,abc,seconds) {
 assert(String(abc).trim(),'Build or enter an ABC score first.');
 assert(seconds>0&&seconds<=900,'Requested duration must be between 0 and 900 seconds.');
 const seed=Number(settings.seed||Math.floor(Math.random()*2147483647));
 const instrumental=settings.renderMode==='instrumental';
 const instruction=instrumental?'Instrumental only, no vocals, no singing.':settings.renderMode==='combined'?'Vocals with instrumental accompaniment.':'Vocals only, a cappella, no instrumental accompaniment.';
 const style=instruction+'\n'+(settings.style||'');
 const lyrics=instrumental?'':(settings.lyrics||'');
 abc=modeABC(abc,settings.renderMode);
 return {
  '12':{class_type:'CheckpointLoaderSimple',inputs:{ckpt_name:'yue2_3b_bf16.safetensors'}},
  '9':{class_type:'YuE2GenerateMusic',inputs:{clip:['12',1],style,lyrics,abc,seed,mode:'full',max_duration:seconds,temperature:1,top_p:0.95,top_k:100,repetition_penalty:1.2}},
  '15':{class_type:'EmptyYuE2LatentAudio',inputs:{seconds:['9',1],batch_size:1}},
  '6':{class_type:'KSampler',inputs:{model:['12',0],positive:['9',0],negative:['9',0],latent_image:['15',0],seed:7,steps:32,cfg:1,sampler_name:'dpm_2',scheduler:'sgm_uniform',denoise:1}},
  '10':{class_type:'VAEDecodeAudio',inputs:{samples:['6',0],vae:['12',2]}},
  '11':{class_type:'SaveAudioAdvanced',inputs:{audio:['10',0],filename_prefix:'audio/YuE2_Session',format:'flac'}}
 };
}
module.exports={build,prompt,chord,expand,note,modeABC};
