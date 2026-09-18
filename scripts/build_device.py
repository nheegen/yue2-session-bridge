from pathlib import Path
import json,struct
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'device'
VERSION=(ROOT/'VERSION').read_text(encoding='utf-8').strip()
OUT.mkdir(exist_ok=True)
boxes=[]; lines=[]
def box(id,cls,x,y,w,h,**kw):
    b=dict(id=id,maxclass=cls,patching_rect=[x,y,w,h],**kw)
    boxes.append({'box':b});return id
def ui(id,cls,x,y,w,h,**kw):
    return box(id,cls,x,y,w,h,presentation=1,presentation_rect=[x,y,w,h],**kw)
def wire(src,dst,out=0,inp=0):lines.append({'patchline':{'source':[src,out],'destination':[dst,inp]}})
def label(id,text,x,y,w):ui(id,'comment',x,y,w,18,text=text,fontsize=11,textcolor=[.78,.81,.84,1])
def field(id,x,y,w,h,text):
    ui(id,'textedit',x,y,w,h,varname=id,text=text,outputmode=1,keymode=0,tabmode=0,bangmode=0,fontsize=11,bgcolor=[.12,.14,.17,1],textcolor=[.95,.96,.98,1],border=1,rounded=4,parameter_enable=1,saved_attribute_attributes={'valueof':{'parameter_longname':id,'parameter_shortname':id,'parameter_type':3,'parameter_invisible':1}})
    box('pre_'+id,'newobj',x,250+y,w,22,text='prepend textfield '+id)
    wire(id,'pre_'+id);wire('pre_'+id,'controller')
def button(id,text,command,x,y,w):
    ui(id,'textbutton',x,y,w,22,text=text,texton=text,mode=1,fontsize=11,bgcolor=[.24,.31,.36,1],textcolor=[1,1,1,1])
    box('sel_'+id,'newobj',x,520+y,55,22,text='sel 1')
    box('cmd_'+id,'message',x,550+y,w,22,text=command)
    box('trigger_'+id,'newobj',x,590+y,50,22,text='t b b')
    box('reset_'+id,'message',x,620+y,50,22,text='set 0')
    wire(id,'sel_'+id);wire('sel_'+id,'trigger_'+id);wire('trigger_'+id,'reset_'+id,1);wire('reset_'+id,id)
    wire('trigger_'+id,'cmd_'+id);wire('cmd_'+id,'defer')
label('title','YuE2 SESSION / '+VERSION,10,3,175)
button('refresh','Refresh','refresh',192,0,73)
ui('clipmenu','umenu',10,25,255,22,varname='clipmenu',items=['Press Refresh'],parameter_enable=0)
box('pickmessage','newobj',10,700,95,22,text='prepend pick');wire('clipmenu','pickmessage');wire('pickmessage','defer')
button('addchord','Add chord','add chords',10,50,124)
button('addbass','Add bass','add bass',140,50,125)
label('chordlabel','Chord sources (track:scene)',10,73,255)
field('chords',10,90,255,20,'')
label('basslabel','Bass sources (track:scene)',10,108,255)
field('bass',10,125,255,18,'')
label('barslabel','Bars',278,4,45);field('bars',278,24,45,24,'8')
label('keylabel','Key: auto or D minor',330,4,175);field('key',330,24,155,24,'auto')
label('urllabel','ComfyUI address',278,53,207);field('url',278,73,207,24,'http://127.0.0.1:8188')
button('test','Test connection','collect test',278,105,207)
label('stylelabel','Sound / style description',498,4,210)
ui('rendermode','umenu',498,24,205,22,varname='rendermode',items=['Vocals only',',','Instrumental only',',','Vocals + instruments'],parameter_enable=1,saved_attribute_attributes={'valueof':{'parameter_longname':'Generation mode','parameter_shortname':'Mode','parameter_type':2,'parameter_enum':['Vocals only','Instrumental only','Vocals + instruments'],'parameter_initial_enable':1,'parameter_initial':[0]}})
box('mode_message','newobj',820,710,145,22,text='prepend rendermode');wire('rendermode','mode_message');wire('mode_message','controller')
field('style',498,50,205,86,'')
label('lyricslabel','Lyrics',716,4,205);field('lyrics',716,24,205,112,'')
label('abclabel','ABC preview — editable',934,4,260);field('abc',934,24,310,78,'')
button('build','1  Build ABC','collect build',934,110,147)
button('generate','2  Generate','collect generate',1090,110,154)
label('destlabel','Send audio to track',1258,4,245)
ui('destmenu','umenu',1258,24,245,22,varname='destmenu',items=['Save only (no import)'],parameter_enable=0)
box('destmessage','newobj',900,710,145,22,text='prepend destination');wire('destmenu','destmessage');wire('destmessage','defer')
button('importlatest','Import latest take','importlatest',1258,52,245)
ui('stage','comment',1258,83,245,30,varname='stage',text='Ready',fontsize=11,textcolor=[.78,.81,.84,1])
ui('progress','slider',1258,117,245,15,varname='progress',size=100.0,floatoutput=1,orientation=1,ignoreclick=1,bgcolor=[.16,.19,.22,1],knobcolor=[.35,.8,.65,1])
ui('status','comment',10,146,1495,21,varname='status',text='Starting bridge...',fontsize=11,textcolor=[.63,.86,.75,1])
box('controller','newobj',30,750,180,22,text='js live.js',varname='controller')
box('defer','newobj',30,710,80,22,text='deferlow');wire('defer','controller')
box('node','newobj',300,750,280,22,text='node.script max-entry.js @autostart 1 @watch 0');wire('controller','node')
box('noderesponse','newobj',300,790,80,22,text='deferlow');wire('node','noderesponse');wire('noderesponse','controller')
box('print','newobj',590,790,160,22,text='print YuE2-Bridge');wire('node','print',1)
box('device','newobj',30,650,95,22,text='live.thisdevice');box('init','message',150,650,40,22,text='init');wire('device','init');wire('init','defer')
box('midiin','newobj',650,650,55,22,text='midiin');box('midiout','newobj',650,700,55,22,text='midiout');wire('midiin','midiout')
help_text = {
 'title': ('YuE2 Session Bridge', 'Use Session MIDI harmony and bass to guide YuE2 in ComfyUI. Choose source clips, build and review ABC, then generate a take.'),
 'refresh': ('Refresh sources and destinations', 'Update the lists of Session MIDI clips and audio tracks after adding, moving, deleting or renaming them. Review existing source numbers after reordering tracks or scenes.'),
 'clipmenu': ('Source MIDI clip', 'Choose a Session MIDI clip by track and clip name, then press Add chord or Add bass. You can combine several clips without selecting them elsewhere in Live.'),
 'addchord': ('Add chord source', 'Add the clip chosen in the source dropdown to the chord sources. Notes from all chord sources are combined into harmony over the requested passage.'),
 'addbass': ('Add bass source', 'Add the clip chosen in the source dropdown to the bass sources. The converter preserves bass pitches and timing; the lowest active note is used when bass notes overlap.'),
 'chords': ('Chord sources', 'Sources are written as track:scene, using numbers starting at 1. Example: 1:1, 3:1 combines two clips. Edit this field to add or remove sources. Build ABC again after changes.'),
 'bass': ('Bass sources', 'Sources are written as track:scene, using numbers starting at 1. Example: 2:1. Edit to add or remove clips. Do not list the same clip as both chord and bass.'),
 'bars': ('Passage length', 'Number of bars to capture, from 1 to 128. Looping clips repeat from their loop start to fill this length; non-looping clips play once. Uses Live tempo and meter when Build ABC is pressed.'),
 'key': ('Musical key', 'Use auto to read Live\'s current root and scale, or enter a key such as D minor. Source pitches are preserved, including notes outside the scale. Build ABC again after changing this field.'),
 'url': ('ComfyUI address', 'Address of your running ComfyUI server. The default is http://127.0.0.1:8188 for a server on this computer. Use Test connection to check the required YuE2 nodes.'),
 'test': ('Test connection', 'Check that the device can reach ComfyUI and that the required workflow nodes are available. This does not generate audio or load the model.'),
 'style': ('Sound / style description', 'Describe the sound, instruments, genre and performance you want, such as an arpeggiated 1980s synth or breathy vocals. Musical context from the last ABC build is added to the request.'),
 'rendermode': ('Generation mode', 'Vocals only requests a cappella and sends lyrics. Instrumental only omits lyrics and requests no singing. Vocals + instruments sends lyrics and requests accompaniment. Switching modes updates the generated ABC part labels without changing the notes or chords. Use the description for instruments, vocal character and genre. These are model instructions, not guaranteed stem isolation.'),
 'lyrics': ('Lyrics', 'Lyrics sent to YuE2 in Vocals only and Vocals + instruments modes. They are retained here but omitted from Instrumental requests. You can use section tags such as [verse] and [chorus].'),
 'abc': ('Editable ABC score', 'Score built from the configured source clips. Review chord names and edit if needed. Generate uses this text; Build ABC replaces it and any manual edits.'),
 'build': ('Build ABC', 'Read the source MIDI clips and Live tempo, meter and scale, then create an ABC score for the requested bars. Rebuild after changing sources, MIDI, key, tempo or length. This replaces manual ABC edits and does not generate audio.'),
 'generate': ('Generate a new take', 'Send the current style, mode, lyrics and ABC to ComfyUI. Uses duration and musical context from the last ABC build. Saves the finished audio in renders and, if selected, imports it into the destination audio track.'),
 'destmenu': ('Destination audio track', 'Choose an audio track for automatic import into its first empty Session slot, or Save only. The destination is captured when Generate is pressed. Existing clips are never replaced and playback is not started.'),
 'importlatest': ('Import latest take', 'Import the most recent render completed by this device instance into the currently selected audio track\'s first empty Session slot. No new generation or playback is started. Useful for copying a take to another track or retrying an import. Each click creates another clip; the saved file remains in renders. Not available after reloading the device until another take completes.'),
 'stage': ('Current generation stage', 'Current ComfyUI stage, such as music generation, audio sampling, decoding or saving. Some stages do not publish numerical progress.'),
 'progress': ('Current stage progress', 'Live progress for this device\'s ComfyUI request. Percentage applies to the current stage and can reset between stages or internal passes. It is not an overall completion percentage or time estimate.'),
 'status': ('Device status', 'Connection results, capture details, chord warnings, import results and errors appear here. If audio import fails, the rendered file is still kept in renders.')
}
label_targets={'chordlabel':'chords','basslabel':'bass','barslabel':'bars','keylabel':'key','urllabel':'url','stylelabel':'style','lyricslabel':'lyrics','abclabel':'abc','destlabel':'destmenu'}
for entry in boxes:
    b=entry['box']
    if b.get('presentation'):
        title,description=help_text[label_targets.get(b['id'],b['id'])]
        b['annotation_name']=title
        b['annotation']=description
patch={'patcher':{'fileversion':1,'appversion':{'major':9,'minor':0,'revision':0,'architecture':'x64','modernui':1},'classnamespace':'box','rect':[0,0,1520,850],'openrect':[0,0,1520,169],'openinpresentation':1,'devicewidth':1520,'default_fontname':'Arial','default_fontsize':11,'bgcolor':[.075,.09,.11,1],'boxes':boxes,'lines':lines,'autosave':0,'dependency_cache':[{'name':f,'patcherrelativepath':'.','type':'TEXT','implicit':1} for f in ['live.js','max-entry.js','bridge.js','progress.js','core.js']]}}
payload=json.dumps(patch,indent=2).encode()+b'\x00'
header=b'ampf'+struct.pack('<I',4)+b'mmmmmeta'+struct.pack('<II',4,0)+b'ptch'
(OUT/'YuE2 Session Bridge.amxd').write_bytes(header+struct.pack('<I',len(payload))+payload)
(OUT/'YuE2 Session Bridge.maxpat').write_text(json.dumps(patch,indent=2),encoding='utf-8')
print('Built device version '+VERSION)
