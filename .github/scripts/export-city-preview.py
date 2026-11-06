#!/usr/bin/env python3
"""Publish a small screenshot from our fresh UI-test game as a CI annotation."""
import json
from pathlib import Path
import subprocess
import sys

root = Path(sys.argv[1]).resolve()
output = Path(sys.argv[2])
images = []
for manifest in root.rglob('*.json'):
    def visit(value):
        if isinstance(value, dict):
            filename = value.get('exportedFileName')
            if isinstance(filename, str):
                candidate = (manifest.parent / filename).resolve()
                description = ' '.join(str(v) for v in value.values()).lower()
                if candidate.is_relative_to(root) and candidate.is_file() and candidate.suffix.lower() in ['.png', '.jpg', '.jpeg']:
                    images.append((100 if 'ville principale' in description else 0, candidate))
            for child in value.values():
                visit(child)
        elif isinstance(value, list):
            for child in value:
                visit(child)
    try:
        visit(json.loads(manifest.read_text()))
    except (ValueError, UnicodeError):
        continue
if not images:
    images = [(0, p) for p in root.rglob('*') if p.suffix.lower() in ['.png', '.jpg', '.jpeg']]
if not images:
    raise SystemExit('Aucune capture exportée dans les résultats de ce parcours.')
source = sorted(images, key=lambda item: (-item[0], str(item[1])))[0][1]
output.parent.mkdir(parents=True, exist_ok=True)
for dimension in [720, 540, 400, 320, 240]:
    subprocess.run(['sips', '-Z', str(dimension), '-s', 'format', 'jpeg', '-s', 'formatOptions', '30', str(source), '--out', str(output)], check=True, stdout=subprocess.DEVNULL)
    if output.stat().st_size <= 22000:
        break
data = output.read_bytes()
if len(data) > 22000:
    raise SystemExit('Aperçu trop volumineux pour une annotation ; fichier conservé dans les artefacts.')
print('::notice title=Native city capture::Native preview saved to CityPreview.jpg; see the city-preview job and artifact.')
