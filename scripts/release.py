"""Build explicit, privacy-checked release archives. Never package a whole working tree."""
from pathlib import Path
import getpass
import hashlib
import json
import re
import struct
import zipfile

ROOT=Path(__file__).resolve().parents[1]
VERSION=(ROOT/'VERSION').read_text(encoding='utf-8').strip()
if not re.fullmatch(r'\d+\.\d+\.\d+(?:-[a-z0-9.-]+)?', VERSION):
    raise SystemExit('Invalid VERSION')
DEVICE_FILES=['YuE2 Session Bridge.amxd','YuE2 Session Bridge.maxpat','live.js','max-entry.js','bridge.js','core.js','progress.js','START HERE.md']
SOURCE_FILES=['LICENSE','README.md','VERSION','CHANGELOG.md','RELEASING.md','LICENSING.md','.gitignore','.gitattributes','scripts/build_device.py','scripts/release.py','tests/test_bridge.js','tests/test_modes.js']+['device/'+f for f in DEVICE_FILES]

def validate_patch():
    raw=(ROOT/'device'/DEVICE_FILES[0]).read_bytes()
    if raw[:4]!=b'ampf' or struct.unpack('<I',raw[28:32])[0]!=len(raw)-32:
        raise ValueError('Invalid AMXD container')
    patch=json.loads(raw[32:].rstrip(b'\0'))
    plain=json.loads((ROOT/'device'/DEVICE_FILES[1]).read_text(encoding='utf-8'))
    if patch!=plain:
        raise ValueError('AMXD and Max patch differ; rebuild the device')
    p=patch['patcher']
    for entry in p.get('dependency_cache',[]):
        if entry.get('bootpath') or entry.get('patcherrelativepath')!='.':
            raise ValueError('Nonportable dependency metadata')
    boxes={x['box']['id']:x['box'] for x in p['boxes']}
    if boxes['title']['text']!='YuE2 SESSION / '+VERSION:
        raise ValueError('Stale device version; rebuild first')
    for field in ['style','lyrics','abc','chords','bass']:
        if boxes[field].get('text'):
            raise ValueError('Private input field must be empty: '+field)

def audit(files):
    username=getpass.getuser()
    patterns=[re.compile(rb'[A-Za-z]:[/\\]+Users[/\\]+[^/\\\s]+',re.I),re.compile(rb'/(?:Users|home)/[^/\s]+'),re.compile(rb'bootpath\s*"\s*:\s*"[^"\r\n]+')]
    for name in files:
        path=ROOT/name
        data=path.read_bytes()
        # A standalone account-name match is checked at release time, never embedded.
        if len(username)>2 and re.search(rb'\b'+re.escape(username.encode())+rb'\b',data,re.I):
            raise ValueError('Local account name found in '+name)
        if any(p.search(data) for p in patterns):
            raise ValueError('Private or absolute dependency path found in '+name)
    validate_patch()

def archive(filename, files, prefix):
    target=ROOT/'dist'/filename
    with zipfile.ZipFile(target,'w',compression=zipfile.ZIP_DEFLATED) as z:
        for source,relative in files:
            info=zipfile.ZipInfo(prefix+'/'+relative,date_time=(2026,1,1,0,0,0))
            info.compress_type=zipfile.ZIP_DEFLATED
            info.external_attr=0o100644<<16
            z.writestr(info,(ROOT/source).read_bytes())
    # Inspect the bytes in the finished archive, not just the source list.
    with zipfile.ZipFile(target) as z:
        expected={prefix+'/'+relative for _,relative in files}
        if set(z.namelist())!=expected or z.testzip():
            raise ValueError('Archive validation failed')
        for source,relative in files:
            if z.read(prefix+'/'+relative)!=(ROOT/source).read_bytes():
                raise ValueError('Archive bytes differ from audited input')
    return target

if __name__=='__main__':
    audit(SOURCE_FILES)
    (ROOT/'dist').mkdir(exist_ok=True)
    device=archive('YuE2-Session-Bridge-v'+VERSION+'-device.zip', [('device/'+f,f) for f in DEVICE_FILES]+[('LICENSING.md','LICENSING.md'),('LICENSE','LICENSE')], 'YuE2-Session-Bridge')
    source=archive('YuE2-Session-Bridge-v'+VERSION+'-source.zip', [(f,f) for f in SOURCE_FILES], 'yue2-session-bridge')
    sums=''.join(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+p.name+'\n' for p in [device,source])
    (ROOT/'dist'/'SHA256SUMS.txt').write_text(sums,encoding='utf-8')
    print('PASS: public file allowlist, private-path/account scan, blank input fields, matching patch/container, and ZIP contents.')
    print('Packaged version '+VERSION+' (device and source).')
