autowatch = 1;
inlets = 1;
outlets = 1;
var fields = {}, task = null, clipsMenu = [], picked = 0, watchdog = null;
var destinations=[null], destinationIndex=0, latestAudio=null;
function rendermode(index) {
 var mode=Number(index)===1?'instrumental':Number(index)===2?'combined':'vocals';
 var changed=fields.renderMode!==mode;fields.renderMode=mode;
 if(changed) {
  this.patcher.getnamed('abc').message('bang');
  if(fields.abc)outlet(0,'request',JSON.stringify({action:'mode',settings:{renderMode:mode,abc:fields.abc}}));
 }
}
function destination(index) { destinationIndex=Number(index); }
function selectedDestination() { return destinations[destinationIndex]||null; }
function audioTrack(id) {
 var track=new LiveAPI(null,'id '+id);
 if(!track.id||!Number(value(track,'has_audio_input'))||Number(value(track,'is_foldable')))throw new Error('Destination audio track no longer exists. Refresh and choose a track.');
 if(Number(value(track,'is_frozen')))throw new Error('Destination track is frozen.');
 return track;
}
function emptySlot(track) {
 for(var i=0;i<track.getcount('clip_slots');i++) {
  var slot=new LiveAPI(null,track.unquotedpath+' clip_slots '+i);
  if(!Number(value(slot,'has_clip')))return {slot:slot,index:i};
 }
 throw new Error('Destination track has no empty Session slots. Add a scene, then use Import latest.');
}
function importAudio(path,dest) {
 if(!dest)return;
 try {
  var track=audioTrack(dest.id),target=emptySlot(track);
  target.slot.call('create_audio_clip',path.replace(/\\/g,'/'));
  status('Imported into '+String(track.get('name').join(' '))+', scene '+(target.index+1)+'. Audio also saved in renders.');
 }catch(e){status('Audio saved, but import failed: '+e.message);}
}
function importlatest() {
 if(!latestAudio){status('No completed take in this device session yet.');return;}
 var dest=selectedDestination();if(!dest){status('Choose a destination audio track first.');return;}
 importAudio(latestAudio,dest);
}
function status(s) { this.patcher.getnamed('status').message('set',s); }
function value(api,name) { var x=api.get(name); return x instanceof Array ? x[0] : x; }
function textfield(name) { var a=arrayfromargs(arguments); a.shift(); if(a[0]==='text') a.shift(); fields[name]=a.join(' '); }
function init() { refresh(); }
function pick(index) { picked=Number(index); }
function refresh() {
 try {
  var song=new LiveAPI(null,'live_set'),menu=this.patcher.getnamed('clipmenu');
  var old=selectedDestination(),destmenu=this.patcher.getnamed('destmenu');
  destinations=[null];destinationIndex=0;destmenu.message('clear');destmenu.message('append','Save only (no import)');
  clipsMenu=[];picked=0;menu.message('clear');
  for(var t=0;t<song.getcount('tracks');t++) {
   var track=new LiveAPI(null,'live_set tracks '+t);
   if(Number(value(track,'has_audio_input'))&&!Number(value(track,'is_foldable'))) {
    destinations.push({id:Number(track.id)});destmenu.message('append',(t+1)+' | '+String(track.get('name').join(' ')).replace(/,/g,' '));
    if(old&&Number(track.id)===old.id)destinationIndex=destinations.length-1;
   }
   for(var s=0;s<track.getcount('clip_slots');s++) {
    var slot=new LiveAPI(null,'live_set tracks '+t+' clip_slots '+s);
    if(!Number(value(slot,'has_clip')))continue;
    var clip=new LiveAPI(null,'live_set tracks '+t+' clip_slots '+s+' clip');
    if(!Number(value(clip,'is_midi_clip')))continue;
    var token=(t+1)+':'+(s+1);
    clipsMenu.push(token);
    menu.message('append',token+' | '+String(track.get('name').join(' ')).replace(/,/g,' ')+ ' | '+String(clip.get('name').join(' ')).replace(/,/g,' '));
   }
  }
  if(clipsMenu.length)menu.message('set',0);
  else menu.message('append','No Session MIDI clips');
  destmenu.message('set',destinationIndex);
  status('Found '+clipsMenu.length+' MIDI clips. Choose one above, then Add chord or Add bass.');
 } catch(e) {status('Clip list: '+e.message);}
}
function collect(action) {
 this.patcher.getnamed('rendermode').message('bang');
 var names=['chords','bass','bars','key','style','lyrics','url','abc'];
 for(var i=0;i<names.length;i++) this.patcher.getnamed(names[i]).message('bang');
 if(task) task.cancel();
 task=new Task(function(){run(action);},this);task.schedule(30);
}
function add(role) {
 try {
  if(!clipsMenu.length||!clipsMenu[picked])throw new Error('Press Refresh, then choose a MIDI clip from the device dropdown.');
  var name=role==='bass'?'bass':'chords',obj=this.patcher.getnamed(name);
  obj.message('bang');
  var item=clipsMenu[picked],old=fields[name]||'';
  if((' '+old.replace(/,/g,' ')+' ').indexOf(' '+item+' ')<0) { fields[name]=(old?old+', ':'')+item;obj.message('set',fields[name]); }
  status('Added '+item+' as '+name+'.');
 } catch(e) { status(e.message); }
}
function snapshot() {
 var song=new LiveAPI(null,'live_set'),clips=[],seen={};
 var roles=['chords','bass'];
 for(var r=0;r<roles.length;r++) {
  var entries=String(fields[roles[r]]||'').split(/[\s,;]+/);
  for(var i=0;i<entries.length;i++) {
   if(!entries[i])continue;
   var m=entries[i].match(/^(\d+):(\d+)$/);
   if(!m||Number(m[1])<1||Number(m[2])<1) throw new Error('Use track:scene, for example 1:1, 3:1.');
   if(seen[entries[i]])throw new Error('A clip is listed more than once: '+entries[i]);seen[entries[i]]=true;
   var path='live_set tracks '+(Number(m[1])-1)+' clip_slots '+(Number(m[2])-1)+' clip';
   var c=new LiveAPI(null,path);
   if(!c.id||!Number(value(c,'is_midi_clip')))throw new Error(entries[i]+' is not a MIDI clip.');
   var raw=c.call('get_all_notes_extended'),notes;
   if(raw instanceof Array&&raw[0]==='dictionary') {var d=new Dict(raw[1]);notes=JSON.parse(d.stringify()).notes;}
   else {notes=JSON.parse(raw instanceof Array?raw.join(' '):String(raw)).notes;}
   clips.push({role:roles[r]==='bass'?'bass':'chords',name:entries[i]+' '+value(c,'name'),looping:Number(value(c,'looping')),loopStart:Number(value(c,'loop_start')),loopEnd:Number(value(c,'loop_end')),startMarker:Number(value(c,'start_marker')),endMarker:Number(value(c,'end_marker')),notes:notes});
  }
 }
 return {tempo:Number(value(song,'tempo')),numerator:Number(value(song,'signature_numerator')),denominator:Number(value(song,'signature_denominator')),root:Number(value(song,'root_note')),scale:String(song.get('scale_name').join(' ')),clips:clips};
}
function run(action) {
 try {
  var s=(action==='build')?snapshot():null;
  if(action==='generate') {
   fields.destination=selectedDestination();
   if(fields.destination)emptySlot(audioTrack(fields.destination.id));
  }
  status(action==='build'?'Reading clips and building ABC...':action==='generate'?'Sending to ComfyUI...':'Checking connection...');
  if(watchdog)watchdog.cancel();
  watchdog=new Task(function(){status('Device bridge did not respond. Keep all bundle files together and reload the device. See Max Console for startup errors.');},this);watchdog.schedule(8000);
  outlet(0,'request',JSON.stringify({action:action,settings:fields,snapshot:s}));
 } catch(e) {status(e.message);}
}
function response(json) {
 try {
  var r=JSON.parse(json);
  if(watchdog)watchdog.cancel();
  if(r.abc!==undefined) this.patcher.getnamed('abc').message('set',r.abc);
  if(r.progress!==undefined)this.patcher.getnamed('progress').message('set',r.progress);
  if(r.stage)this.patcher.getnamed('stage').message('set',r.stage);
  if(r.status)status(r.status);
  if(r.audioPath){latestAudio=r.audioPath;importAudio(r.audioPath,r.destination);}
 } catch(e) {status('Bridge response error: '+e.message);}
}
