#!/usr/bin/env python3
"""Publish compiler/test errors as Actions annotations, visible on the public run page."""
import re,sys
from pathlib import Path
text=Path(sys.argv[1]).read_text(errors='replace')
seen=set()
def escape(s):return s.replace('%','%25').replace('\r','%0D').replace('\n','%0A')
for line in text.splitlines():
    if ' error: ' not in line and 'failed (' not in line and 'Testing failed:' not in line:continue
    value=line.strip()[:1500]
    if value in seen:continue
    seen.add(value)
    print('::error title=Xcode validation::'+escape(value))
    if len(seen)>=20:break
