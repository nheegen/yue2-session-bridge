'use strict';
const fs=require('fs'),path=require('path'),http=require('http'),https=require('https');
const core=require('./core');
const progress=require('./progress');
function request(base,route,body) {
 return new Promise((resolve,reject)=>{
  let u;try {u=new URL(route,base.endsWith('/')?base:base+'/');}catch(e){return reject(new Error('Enter a valid ComfyUI URL.'));}
  if(!['http:','https:'].includes(u.protocol))return reject(new Error('Use an http or https URL.'));
  const data=body===undefined?null:JSON.stringify(body);
  const req=(u.protocol==='https:'?https:http).request(u,{method:data?'POST':'GET',headers:data?{'Content-Type':'application/json','Content-Length':Buffer.byteLength(data)}:{}},res=>{
   let content='';res.setEncoding('utf8');res.on('data',s=>content+=s);res.on('end',()=>{
    let parsed;try{parsed=JSON.parse(content);}catch(e){return reject(new Error('ComfyUI returned a non-JSON response ('+res.statusCode+').'));}
    if(res.statusCode<200||res.statusCode>=300)return reject(new Error(JSON.stringify(parsed).slice(0,800)));
    resolve(parsed);
   });
  });req.setTimeout(15000,()=>req.destroy(new Error('ComfyUI request timed out.')));req.on('error',reject);if(data)req.write(data);req.end();
 });
}
async function check(base) {
 const info=await request(base,'object_info');
 for(const type of ['CheckpointLoaderSimple','YuE2GenerateMusic','EmptyYuE2LatentAudio','KSampler','VAEDecodeAudio','SaveAudioAdvanced']) if(!info[type])throw new Error('ComfyUI is missing '+type+'.');
 return info;
}
function start(max,options={}) {
 let built=null,busy=false;
 const renderDir=options.renderDir||path.join(__dirname,'renders');
 const send=obj=>max.outlet('response',JSON.stringify(obj));
 max.addHandler('request',async raw=>{
  try {
   const {action,settings,snapshot}=JSON.parse(raw),base=String(settings.url||'http://127.0.0.1:8188').trim();
   send({ack:true});
   if(action==='mode'){send({status:'Mode updated. Source ABC is preserved; the unwanted part is rested only in the submitted score.'});return;}
   if(action==='build') {
    built=core.build(snapshot,settings);
    const dir=renderDir;fs.mkdirSync(dir,{recursive:true});
    fs.writeFileSync(path.join(dir,'latest-score.abc'),built.abc);
    send({abc:built.abc,status:built.key+' | '+built.tempo+' BPM | '+built.bars+' bars | '+built.seconds.toFixed(1)+' s. '+(built.warnings.join(' ')||'Review ABC, then Generate.')});return;
   }
   if(action==='test') {await check(base);send({status:'Connected. Your YuE2 workflow nodes are available.'});return;}
   if(action!=='generate')return;
   if(busy)throw new Error('A generation is already pending from this device.');
   if(!built)throw new Error('Build ABC first to capture the loop duration.');
   const capture=built;
   busy=true;
   let watcher;
   try {
    await check(base);
    const settingsCopy={...settings,style:String(settings.style||'')+'\nMusical context: '+capture.key+', '+capture.tempo+' BPM.'};
    const graph=core.prompt(settingsCopy,settings.abc,capture.seconds);
    // Keep the editable source intact when submitting a mode-specific score.
    const clientId='yue2-session-'+require('crypto').randomUUID();
    send({progress:0,stage:'Connecting / queued'});
    watcher=await progress.connect(base,clientId,send);
    const answer=await request(base,'prompt',{prompt:graph,client_id:clientId});
    if(!answer.prompt_id)throw new Error('ComfyUI did not return a job ID: '+JSON.stringify(answer));
    watcher.setPrompt(answer.prompt_id);
    const dir=renderDir;fs.mkdirSync(dir,{recursive:true});
    const basename='take-'+Date.now();
    fs.writeFileSync(path.join(dir,basename+'.json'),JSON.stringify({prompt_id:answer.prompt_id,prompt:graph,capture},null,2));
    send({status:'Queued '+answer.prompt_id+'. Waiting for YuE2...'});
    let failures=0;
    for(let count=0;count<1800;count++) {
     await new Promise(r=>setTimeout(r,2000));
     let history;try{history=await request(base,'history/'+encodeURIComponent(answer.prompt_id));failures=0;}catch(e){if(++failures>=5)throw new Error('Lost connection. Job may still be running; check ComfyUI before retrying.');continue;}
     const entry=history[answer.prompt_id];if(!entry)continue;
     if(entry.status&&entry.status.status_str==='error')throw new Error('YuE2 failed: '+JSON.stringify(entry.status.messages).slice(0,700));
     const output=entry.outputs&&entry.outputs['11'];
     const audio=output&&(output.audio||[]);
     if(audio.length) {
      const a=audio[0];
      const route='view?'+new URLSearchParams({filename:a.filename,subfolder:a.subfolder||'',type:a.type||'output'});
      const u=new URL(route,base.endsWith('/')?base:base+'/');
      const target=path.join(dir,basename+path.extname(a.filename));
      send({stage:'Downloading audio',progress:0});
      await download(u,target);
      send({status:'Saved: '+target,stage:'Complete',progress:100,audioPath:path.resolve(target),destination:settings.destination||null});return;
     }
     if(entry.status&&entry.status.completed)throw new Error('Job completed without an audio file. Check the Save Audio node in ComfyUI.');
    }
    throw new Error('Stopped waiting after 60 minutes. The ComfyUI job was not cancelled.');
   }finally{if(watcher)watcher.close();busy=false;}
  }catch(e){send({status:'Error: '+e.message,stage:'Error â€” see status'});}
 });
 send({status:'Bridge started. Add clips and Build ABC.'});
}
function download(url,target) {
 return new Promise((resolve,reject)=>{
  const req=(url.protocol==='https:'?https:http).get(url,res=>{
   if(res.statusCode!==200){res.resume();return reject(new Error('Audio download failed: '+res.statusCode));}
   const file=fs.createWriteStream(target+'.part');
   const fail=e=>{file.destroy();fs.rm(target+'.part',{force:true},()=>{});reject(e);};
   res.on('error',fail);file.on('error',fail);res.pipe(file);file.on('finish',()=>file.close(()=>{fs.renameSync(target+'.part',target);resolve();}));
  });req.setTimeout(60000,()=>req.destroy(new Error('Audio download timed out.')));req.on('error',reject);
 });
}
module.exports={request,check,start,download};
if(require.main===module)start(require('max-api'));
