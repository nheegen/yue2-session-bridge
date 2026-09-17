'use strict';
const assert=require('node:assert/strict'),http=require('http'),fs=require('fs'),vm=require('vm');
const core=require('../device/core');
const bridge=require('../device/bridge');
const progress=require('../device/progress');
const clip=(notes,role='chords',extra={})=>({name:'Test',role,looping:true,loopStart:0,loopEnd:16,startMarker:0,endMarker:16,notes,...extra});
const notes=(p,start,duration)=>p.map(pitch=>({pitch,start_time:start,duration,mute:false,probability:1}));
const snap=clips=>({tempo:120,numerator:4,denominator:4,root:11,scale:'Minor',clips});
async function main(){
 const progression=[...notes([59,62,66],0,4),...notes([54,57,61],4,4),...notes([55,59,62],8,4),...notes([57,61,64],12,4)];
 const built=core.build(snap([clip(progression)]),{bars:8});
 assert.equal(built.seconds,16);assert.match(built.abc,/K:Bm/);
 assert.deepEqual(built.segments.map(s=>s.chord),['Bm','F#m','G','A','Bm','F#m','G','A']);
 assert.equal(core.chord([64,67,72]).name,'C/E');
 const half=core.build(snap([clip([...notes([60,64,67],0,2),...notes([62,65,69],2,2)],'chords',{loopEnd:4})]),{bars:1});
 assert.match(half.abc,/"C"z16 "Dm"z16\|/);
 const carry=core.expand(clip(notes([60],2,4),'bass',{loopStart:4,loopEnd:8}),8,.125);
 assert.deepEqual(carry,[{pitch:60,start:0,end:2},{pitch:60,start:4,end:6}]);
 const one=core.expand(clip(notes([60],0,4),'bass',{looping:false,endMarker:4}),16,.125);assert.equal(one.length,1);
 const bass=core.build(snap([clip(notes([48],0,8),'bass')]),{bars:2});assert.match(bass.abc,/=C,32-\|\n=C,32\|/);
 const poly=core.build(snap([clip(notes([60,61,66],0,4))]),{bars:1});assert.match(poly.abc,/\[=C\^C\^F\]32/);assert.ok(poly.warnings.length);
 const silent=clip(notes([60],0,4).map(n=>({...n,mute:true})));assert.throws(()=>core.build(snap([silent]),{}),/no active notes/);
 const odd=core.build({...snap([clip(progression)]),numerator:3,denominator:4},{bars:2});assert.equal(odd.seconds,3);assert.match(odd.abc,/M:3\/4/);
 assert.throws(()=>core.build(snap([])),/at least one/);
 const p=core.prompt({style:'breathy',lyrics:'line 1\nline 2',seed:42},built.abc,built.seconds);
 assert.equal(p['9'].inputs.abc,built.abc);assert.equal(p['9'].inputs.lyrics,'line 1\nline 2');assert.equal(p['9'].inputs.seed,42);
 assert.ok(!Object.values(p).some(n=>n.class_type==='YuE2GenerateABC'));
 // Run the actual Max controller in a mock Live host, including multiline text and dictionary notes.
 const fields={chords:'1:1',bass:'',bars:'8',key:'auto',style:'breathy',lyrics:'first line\nsecond line',url:'http://127.0.0.1:8188',abc:''};
 let request,status;
 const song={tempo:[120],signature_numerator:[4],signature_denominator:[4],root_note:[11],scale_name:['Minor']};
 const c={is_midi_clip:[1],looping:[1],loop_start:[0],loop_end:[16],start_marker:[0],end_marker:[16],name:['Chords']};
 const context={JSON,Number,String,Error,Array,Math,Dict:function(){this.stringify=()=>JSON.stringify({notes:progression});},LiveAPI:function(_,path){this.id=1;this.get=k=>(path==='live_set'?song:c)[k];this.call=()=>['dictionary','notes'];},arrayfromargs:a=>Array.from(a),Task:function(fn){this.schedule=()=>fn();this.cancel=()=>{};},outlet:(_,selector,s)=>{assert.equal(selector,'request');request=JSON.parse(s);}};
 context.patcher={getnamed:name=>({message:(selector,value)=>{if(name==='status')status=value;else if(selector==='bang')context.textfield(name,'text',fields[name]);}})};
 vm.createContext(context);vm.runInContext(fs.readFileSync('device/live.js','utf8'),context);
 context.collect('build');assert.equal(request.action,'build');assert.equal(request.snapshot.clips[0].notes.length,12);assert.equal(request.settings.lyrics,fields.lyrics);
 // The source menu must enumerate Live without referring to the selected clip.
 const menuItems=[];
 context.LiveAPI=function(_,path){
  assert.ok(!path.includes('detail_clip'),'Source picker must not rely on selected clips');
  this.id=1;
  this.getcount=k=>path==='live_set'?2:2;
  this.get=k=>k==='has_clip'?[path.includes('tracks 1 clip_slots 1')?0:1]:k==='is_midi_clip'?[path.includes('tracks 1')?0:1]:['Named source'];
 };
 context.patcher={getnamed:name=>({message:(selector,v)=>{if(name==='clipmenu'&&selector==='append')menuItems.push(v);else if(name==='status')status=v;else if(selector==='bang')context.textfield(name,'text',fields[name]);else if(selector==='set')fields[name]=v;}})};
 context.refresh();assert.equal(menuItems.length,2);assert.ok(menuItems[1].startsWith('1:2 |'));
 context.pick(1);context.add('bass');assert.equal(fields.bass,'1:2');context.add('bass');assert.equal(fields.bass,'1:2');
 let started=0;
 vm.runInNewContext(fs.readFileSync('device/max-entry.js','utf8'),{require:name=>name==='./bridge'?{start:max=>{assert.equal(max.marker,true);started++;}}:{marker:true}});
 assert.equal(started,1,'Max module loader must start the bridge without require.main');
 // Import must resolve the captured Live object id and skip occupied slots.
 let imported=null,occupied=[1,0],frozen=false,deleted=false;
 context.LiveAPI=function(_,path){
  this.id=deleted?0:44;this.unquotedpath='live_set tracks 3';
  this.getcount=()=>occupied.length;
  this.get=k=>k==='has_audio_input'?[1]:k==='is_foldable'?[0]:k==='is_frozen'?[Number(frozen)]:k==='name'?['Vocals']:[occupied[Number(path.match(/clip_slots (\d+)/)[1])]];
  this.call=(method,file)=>{assert.equal(method,'create_audio_clip');imported={path,file};};
 };
 context.importAudio('C:\\renders\\take.flac',{id:44});assert.equal(imported.path,'live_set tracks 3 clip_slots 1');assert.equal(imported.file,'C:/renders/take.flac');
 imported=null;occupied=[1,1];context.importAudio('C:/take.flac',{id:44});assert.equal(imported,null);assert.match(status,/no empty/);
 occupied=[0];frozen=true;context.importAudio('C:/take.flac',{id:44});assert.equal(imported,null);assert.match(status,/frozen/);
 frozen=false;deleted=true;context.importAudio('C:/take.flac',{id:44});assert.equal(imported,null);assert.match(status,/no longer exists/);
 assert.equal(progress.eventUpdate({type:'progress',data:{prompt_id:'other',node:'6',value:16,max:32}},'ours','6'),null);
 assert.equal(progress.eventUpdate({type:'progress',data:{prompt_id:'ours',node:'6',value:16,max:32}},'ours','6').progress,50);
 assert.equal(progress.eventUpdate({type:'progress',data:{prompt_id:'ours',node:'9',value:16,max:32}},'ours','6'),null);
 assert.equal(progress.eventUpdate({type:'executing',data:{prompt_id:'ours',node:'10'}},'ours','6').progress,0);
 assert.equal(progress.eventUpdate({type:'progress_state',data:{prompt_id:'ours',nodes:{'6':{node_id:'6',value:8,max:32}}}},'ours','6').progress,25);
 let ws,updates=[];
 class MockSocket {constructor(){ws=this;this.listeners={};setImmediate(()=>this.listeners.open());}addEventListener(k,fn){this.listeners[k]=fn;}close(){}message(e){this.listeners.message({data:JSON.stringify(e)});}}
 const connection=await progress.connect('http://localhost:8188','client',x=>updates.push(x),MockSocket);
 ws.message({type:'executing',data:{prompt_id:'ours',node:'6'}});connection.setPrompt('ours');
 ws.message({type:'progress',data:{prompt_id:'ours',node:'6',value:24,max:32}});assert.equal(updates.at(-1).progress,75);connection.close();
 ws.message({type:'progress',data:{prompt_id:'ours',node:'6',value:32,max:32}});assert.equal(updates.at(-1).progress,75);
 // Model two actual toggle clicks through the packaged patch's selector/reset/trigger wiring.
 const patch=JSON.parse(fs.readFileSync('device/YuE2 Session Bridge.maxpat','utf8')).patcher;
 const boxes=Object.fromEntries(patch.boxes.map(x=>[x.box.id,x.box]));
 for(const button of patch.boxes.map(x=>x.box).filter(b=>b.maxclass==='textbutton')) {
  assert.equal(button.mode,1);
  const states={};let commands=0;
  function emit(id,out,value){for(const l of patch.lines.map(x=>x.patchline).filter(l=>l.source[0]===id&&l.source[1]===out))receive(l.destination[0],value);}
  function receive(id,value){const b=boxes[id];if(id==='defer'){commands++;return;}if(b.maxclass==='textbutton'){if(value==='set 0')states[id]=0;return;}if(b.text==='sel 1'){if(value===1)emit(id,0,'bang');}else if(b.text==='t b b'){emit(id,1,'bang');emit(id,0,'bang');}else if(b.maxclass==='message')emit(id,0,b.text);}
  for(let i=0;i<2;i++){states[button.id]=states[button.id]?0:1;emit(button.id,0,states[button.id]);assert.equal(states[button.id],0);}
  assert.equal(commands,2,button.id+' must execute exactly once for each click');
 }
 // Real HTTP transport round trip, node availability checks and rejection reporting.
 const server=http.createServer((req,res)=>{res.setHeader('Content-Type','application/json');if(req.url==='/object_info')res.end(JSON.stringify(Object.fromEntries(Object.values(p).map(n=>[n.class_type,{}]))));else if(req.url==='/prompt'){let s='';req.on('data',d=>s+=d);req.on('end',()=>{assert.deepEqual(JSON.parse(s).prompt,p);res.end(JSON.stringify({prompt_id:'test'}));});}else{res.statusCode=400;res.end(JSON.stringify({error:'invalid'}));}});
 await new Promise(r=>server.listen(0,'127.0.0.1',r));const base='http://127.0.0.1:'+server.address().port;
 try{await bridge.check(base);assert.equal((await bridge.request(base,'prompt',{prompt:p})).prompt_id,'test');await assert.rejects(bridge.request(base,'bad'),/invalid/);}finally{await new Promise(r=>server.close(r));}
 // Exercise the full device bridge against a fake server, including queue/history/download.
 let handler,actualABC,messages=[];
 const fake=http.createServer((req,res)=>{
  if(req.url.startsWith('/view?')){res.end(Buffer.from('test-audio-bytes'));return;}
  res.setHeader('Content-Type','application/json');
  if(req.url==='/object_info'){res.end(JSON.stringify(Object.fromEntries(Object.values(p).map(n=>[n.class_type,{}]))));return;}
  if(req.url==='/prompt'){let body='';req.on('data',d=>body+=d);req.on('end',()=>{actualABC=JSON.parse(body).prompt['9'].inputs.abc;res.end('{"prompt_id":"mock-job"}');});return;}
  res.end(JSON.stringify({'mock-job':{status:{completed:true,status_str:'success'},outputs:{'11':{audio:[{filename:'audio.flac',subfolder:'audio',type:'output'}]}}}}));
 });
 await new Promise(r=>fake.listen(0,'127.0.0.1',r));
 const dir='.test-output/mock-renders-'+Date.now();
 bridge.start({addHandler:(name,fn)=>{handler=fn;},outlet:(name,json)=>{messages.push(JSON.parse(json));}},{renderDir:dir});
 try {
  const settings={bars:8,key:'auto',style:'breathy',lyrics:'hello',url:'http://127.0.0.1:'+fake.address().port};
  await handler(JSON.stringify({action:'build',settings,snapshot:snap([clip(progression)])}));
  settings.abc=messages.find(m=>m.abc).abc+'\n% Manual edit preserved';
  await handler(JSON.stringify({action:'generate',settings}));
  assert.equal(actualABC,settings.abc);
  assert.equal(messages.at(-1).progress,100);assert.ok(messages.at(-1).audioPath.endsWith('.flac'));
  assert.ok(messages.at(-1).status.startsWith('Saved:'),messages.at(-1).status);
  const files=fs.readdirSync(dir);assert.ok(files.some(f=>f.endsWith('.json')));
  assert.equal(fs.readFileSync(dir+'/'+files.find(f=>f.endsWith('.flac')),'utf8'),'test-audio-bytes');
 } finally {await new Promise(r=>fake.close(r));}
 console.log('PASS: full progression, repeats, inversions, half bars, loop offsets, non-looping clips, bass ties, unknown voicings, muted notes, meter, workflow mapping, Max controller and HTTP transport.');
 console.log('PASS: complete mocked Build -> edited ABC -> Queue -> History -> saved audio and request record. No real generation queued.');
 console.log('PASS: Max module startup, named clip picker independent of selection, duplicate prevention, and two clicks through every button/reset path.');
 console.log('PASS: target audio import, occupied/frozen/deleted track safeguards, per-job progress filtering, stage reset, WebSocket buffering and completion payload.');
}
main().catch(e=>{console.error(e);process.exitCode=1;});
