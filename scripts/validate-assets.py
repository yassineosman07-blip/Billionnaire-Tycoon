#!/usr/bin/env python3
"""Validate packaged assets and shared Xcode scheme without Apple tooling."""
import json, plistlib, struct, wave, xml.etree.ElementTree as ET
from pathlib import Path
root = Path(__file__).resolve().parents[1]
resources = root / 'BusinessClicker/Resources'
for path in resources.rglob('Contents.json'):
    data = json.loads(path.read_text())
    for image in data.get('images', []):
        assert (path.parent / image['filename']).is_file(), image
icon = (resources / 'Assets.xcassets/AppIcon.appiconset/AppIcon.png').read_bytes()
assert icon[:8] == b'\x89PNG\r\n\x1a\n'
assert struct.unpack('>IIBB', icon[16:26]) == (1024, 1024, 8, 2), 'App icon must be opaque RGB 1024×1024'
for path in resources.glob('*.wav'):
    with wave.open(str(path)) as f:
        assert f.getnframes() > 0 and f.getsampwidth() == 2 and f.getnchannels() == 1
with (resources / 'PrivacyInfo.xcprivacy').open('rb') as f:
    privacy = plistlib.load(f)
assert privacy['NSPrivacyTracking'] is False
project = (root / 'BusinessClicker.xcodeproj/project.pbxproj').read_text()
scheme = ET.parse(root / 'BusinessClicker.xcodeproj/xcshareddata/xcschemes/BusinessClicker.xcscheme')
for reference in scheme.findall('.//BuildableReference'):
    assert reference.attrib['BlueprintIdentifier'] + ' = {' in project
for path in (root / 'BusinessClicker').rglob('*.swift'):
    assert str(path.relative_to(root)) in project, f'Missing Xcode reference: {path}'
print('Assets, audio, privacy manifest, shared scheme and source membership: OK')
