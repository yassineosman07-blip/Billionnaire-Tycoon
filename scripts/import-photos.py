#!/usr/bin/env python3
"""Import explicitly reviewed photographs and preserve provenance for offline distribution.
Populate Resources/media-manifest.json with reviewed source URLs, licenses and product matches.
No automatic search-result selection: the pictured product must match its catalogue entry.
"""
import io, json, sys, urllib.request, urllib.parse
from pathlib import Path
from PIL import Image
root = Path(__file__).resolve().parents[1]
resources = root / 'BusinessClicker/Resources'
manifest_path = resources / 'media-manifest.json'
manifest = json.loads(manifest_path.read_text())
errors = []
allowed_licenses = {'CC0', 'Public domain', 'CC BY 4.0', 'CC BY-SA 4.0', 'CC BY 3.0', 'CC BY-SA 3.0'}
for article in manifest['articles']:
    if not article.get('verified_product_match') or article.get('license') not in allowed_licenses or not all(article.get(k) for k in ['author','source_page','download_url','license_url']):
        errors.append(f"{article['id']}: {article['name']} — photographie et droits à renseigner")
        continue
    url = urllib.parse.urlsplit(article['download_url'])
    if url.scheme != 'https' or url.hostname != 'upload.wikimedia.org':
        errors.append(f"{article['id']}: URL HTTPS upload.wikimedia.org requise"); continue
    filename = f"item-{int(article['id'])}.jpg"
    if article['filename'] != filename:
        errors.append(f"{article['id']}: nom de fichier incorrect"); continue
    try:
        request = urllib.request.Request(article['download_url'], headers={'User-Agent':'BusinessClickerAssetImporter/1.0'})
        with urllib.request.urlopen(request, timeout=40) as response:
            if urllib.parse.urlsplit(response.url).hostname != 'upload.wikimedia.org': raise ValueError('Redirection hors source autorisée')
            raw = response.read(20 * 1024 * 1024 + 1)
        if len(raw) > 20 * 1024 * 1024: raise ValueError('Photographie supérieure à 20 Mo')
        image = Image.open(io.BytesIO(raw)); image.load(); image = image.convert('RGB')
        image.thumbnail((1600,1600))
        target = resources / filename; temporary = target.with_suffix('.tmp')
        image.save(temporary,format='JPEG',quality=88,optimize=True); temporary.replace(target)
        image.thumbnail((500,500)); image.save(resources / f'item-{int(article["id"])}-thumb.jpg',format='JPEG',quality=85,optimize=True)
        article['status'] = 'ready'
        print(f"Imported {filename}: {article['name']}")
    except Exception as error:
        errors.append(f"{article['id']}: {error}")
manifest_path.write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
if errors:
    print('\n'.join(errors),file=sys.stderr);sys.exit(1)
print('Photographs imported. Run scripts/generate_project.py to update the Xcode resources.')
