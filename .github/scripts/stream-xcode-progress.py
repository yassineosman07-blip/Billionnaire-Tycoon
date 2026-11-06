#!/usr/bin/env python3
"""Expose focused native-test progress without requiring access to private raw logs."""
import sys

def escape(s):return s.replace('%','%25').replace('\r','%0D').replace('\n','%0A')
for line in sys.stdin:
    # Keep the raw log in tee's file. Only important progress reaches the annotation list.
    if 'UI_DIAGNOSTIC' in line:
        print('::notice title=UI failure snapshot::'+escape(line.strip()[:1600]),flush=True)
    elif 'error:' in line or 'Fatal error' in line:
        print('::error title=Native test output::'+escape(line.strip()[:1200]),flush=True)
    elif ('started' in line or 'passed' in line or 'failed' in line) and any(name in line for name in ['KenneyAssetTests','PersistenceTests','Test Suite']):
        print('::notice title=Native test progress::'+escape(line.strip()[:1000]),flush=True)
    elif 'Executed ' in line and ' tests' in line:
        print('::notice title=Native test totals::'+escape(line.strip()[:1000]),flush=True)
