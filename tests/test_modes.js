const assert=require('node:assert/strict');
const core=require('../device/core');
const abc='X:1\nV: Vocal clef=treble name="Vocal"\nV: Ins clef=bass name="Bass / harmony"\nK:Dm\nV: Vocal\n"Dm"z32|\n[V: Vocal]z32|\nV: Ins\n=D,32|';
const settings={style:'80s synth',lyrics:'Keep these words',renderMode:'instrumental'};
const inst=core.prompt(settings,abc,8)['9'].inputs;
assert.equal(inst.lyrics,'');assert.match(inst.style,/Instrumental only/);assert.ok(!inst.abc.includes('Vocal'));assert.match(inst.abc,/V: Harmony clef=treble name="Harmony"/);assert.match(inst.abc,/\[V: Harmony\]/);
assert.equal(settings.lyrics,'Keep these words');
for(const mode of ['vocals','combined']) {
 const result=core.prompt({...settings,renderMode:mode},inst.abc,8)['9'].inputs;
 assert.equal(result.abc,abc);assert.equal(result.lyrics,settings.lyrics);
 assert.match(result.style,mode==='vocals'?/a cappella, no instrumental accompaniment/:/Vocals with instrumental accompaniment/);
}
const custom='V: Lead name="My solo"\n=C8|';assert.equal(core.modeABC(custom,'instrumental'),custom);
const snapshot={tempo:120,numerator:4,denominator:4,root:2,scale:'Minor',clips:[{name:'Chords',role:'chords',looping:true,loopStart:0,loopEnd:4,notes:[62,65,69].map(pitch=>({pitch,start_time:0,duration:4}))}]};
assert.ok(!core.build(snapshot,{bars:1,renderMode:'instrumental'}).abc.includes('Vocal'));
assert.match(core.build(snapshot,{bars:1,renderMode:'combined'}).abc,/V: Vocal/);
console.log('PASS: three modes, ABC definitions and references, mode switches, preserved lyrics and custom voices, mode-aware Build ABC.');
