#!/usr/bin/env python3
"""Validate provenance, native model references, skinning and animations without Apple SDKs."""
import hashlib, json, xml.etree.ElementTree as E
from pathlib import Path
root=Path(__file__).resolve().parents[1]
assets=root/'BusinessClicker/Resources/Kenney'
for entry in json.loads((root/'AssetsSource/Kenney/provenance.json').read_text()):
    path=root/'AssetsSource/Kenney'/entry['archive']
    assert hashlib.sha256(path.read_bytes()).hexdigest()==entry['sha256'], path
    assert entry['license']=='CC0-1.0'
city=assets/'City'
models=list(city.glob('*.obj'));assert len(models)==41
for path in models:
    lines=path.read_text().splitlines();assert any(line.startswith('v ') for line in lines) and any(line.startswith('f ') for line in lines)
    for line in lines:
        if line.startswith('mtllib '):
            material=city/line[7:].strip();assert material.is_file(), material
            for reference in material.read_text().splitlines():
                if reference.startswith('map_Kd '):assert (city/reference[7:].strip()).is_file(), reference
ns={'c':'http://www.collada.org/2005/11/COLLADASchema'}
characters=assets/'Pedestrians'
for skin in ['male','female']:
    for action in ['idle','run']:
        path=characters/f'{skin}-{action}.dae';tree=E.parse(path)
        assert tree.getroot().tag=='{http://www.collada.org/2005/11/COLLADASchema}COLLADA'
        assert not path.read_text().splitlines()[1].startswith('<ns0:')
        assert tree.find('.//c:up_axis',ns).text=='Y_UP'
        assert len(tree.findall('.//c:node[@type="JOINT"]',ns))==58
        assert tree.findall('.//c:controller/c:skin/c:vertex_weights',ns)
        assert tree.findall('.//c:channel',ns)
        for sampler in tree.findall('.//c:sampler/c:input',ns):
            if sampler.get('semantic')=='INPUT':
                array=tree.find('.//c:source[@id="'+sampler.get('source')[1:]+'"]/c:float_array',ns)
                duration=max(map(float,array.text.split()))
                assert abs(duration-(16/24 if action=='run' else 32/24))<0.001, path
        for image in tree.findall('.//c:image/c:init_from',ns):
            assert image.text in ['humanMaleA.png','humanFemaleA.png']
            assert (characters/image.text).is_file()
        assert '/tmp/' not in path.read_text()
assert not any('zombie' in str(p).lower() for p in assets.rglob('*'))
assert (city/'License.txt').is_file() and (characters/'License.txt').is_file()
print('Kenney: 41 OBJ models + materials, CC0 provenance, 4 animated human rigs (58 joints), textures and zombie exclusion: OK')
