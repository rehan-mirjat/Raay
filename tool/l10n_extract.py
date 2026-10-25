#!/usr/bin/env python3
"""List user-visible English string literals in a Dart file (for ARB migration).
usage: l10n_extract.py FILE
"""
import re,sys
f=sys.argv[1]
lines=open(f).read().split("\n")
lit=re.compile(r"'((?:[^'\\]|\\.)*)'")
skip_ctx=re.compile(r"^\s*(import|export|part)\b|Key\(|\bpath:|context\.(go|push)|\.go\(|\.push\(|httpsCallable|collection\(|\.doc\(|debugPrint|print\(|RegExp|DateFormat|fontFamily|assets/|\.png|\.svg|semanticsLabel")
for i,l in enumerate(lines,1):
    if skip_ctx.search(l): continue
    for m in lit.finditer(l):
        t=m.group(1)
        before=l[:m.start()].rstrip()
        if before.endswith(("[","case","==","!=")) or re.search(r"\bcase$",before): continue
        if not re.search(r"[A-Za-z]{3,}",t): continue
        if re.fullmatch(r"[a-z][A-Za-z0-9_.]*",t): continue   # identifiers/keys
        if t.startswith(("http","/","assets/","package:")): continue
        print(f"{i}: {t}")
