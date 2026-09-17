'use strict';
const stages={'12':'Loading model','9':'YuE2 music generation','15':'Preparing audio','6':'Audio sampling','10':'Decoding audio','11':'Saving audio'};
function eventUpdate(event,promptId,currentNode) {
 const d=event.data||{};
 if(d.prompt_id!==promptId)return null;
 if(event.type==='execution_start')return {progress:0,stage:'Starting generation'};
 if(event.type==='executing')return {progress:0,stage:stages[d.node]||'Finishing generation',node:d.node};
 let p=d;
 if(event.type==='progress_state') {
  p=d.nodes&&d.nodes[currentNode];
  if(!p)return null;
 }else if(event.type!=='progress')return null;
 const n=p.node||p.node_id||currentNode;
 if(currentNode&&n!==currentNode)return null;
 if(!(Number(p.max)>0)||!Number.isFinite(Number(p.value)))return null;
 const percent=Math.max(0,Math.min(100,100*Number(p.value)/Number(p.max)));
 return {progress:percent,stage:(stages[n]||'Rendering')+' — '+Math.round(percent)+'%',node:n};
}
async function connect(base,clientId,send,WebSocketClass=globalThis.WebSocket) {
 if(!WebSocketClass)return {setPrompt(){},close(){}};
 const u=new URL('ws',base.endsWith('/')?base:base+'/');u.protocol=u.protocol==='https:'?'wss:':'ws:';u.searchParams.set('clientId',clientId);
 let socket,promptId=null,currentNode=null,buffer=[],closed=false;
 const handle=e=>{const update=eventUpdate(e,promptId,currentNode);if(update){if(Object.hasOwn(update,'node'))currentNode=update.node;send(update);}};
 const api={connected:false,setPrompt(id){promptId=id;for(const e of buffer)handle(e);buffer=[];},close(){closed=true;if(socket)socket.close();}};
 await new Promise(resolve=>{
  let done=false;
  const finish=()=>{if(!done){done=true;clearTimeout(timer);resolve();}};
  const timer=setTimeout(()=>{api.close();send({stage:'Progress unavailable; checking completion normally'});finish();},4000);
  try {
   socket=new WebSocketClass(u);
   socket.addEventListener('open',()=>{api.connected=true;finish();});
   socket.addEventListener('error',()=>{if(!closed)send({stage:'Progress unavailable; checking completion normally'});finish();});
   socket.addEventListener('close',()=>{if(!closed)send({stage:'Progress connection closed; still checking completion'});finish();});
   socket.addEventListener('message',m=>{
    if(closed)return;
    if(typeof m.data!=='string')return;
    try {const e=JSON.parse(m.data);if(!promptId){if(buffer.length<200)buffer.push(e);}else handle(e);}catch(_){}
   });
  }catch(_){finish();}
 });
 return api;
}
module.exports={eventUpdate,connect};
