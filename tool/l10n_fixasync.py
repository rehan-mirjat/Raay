#!/usr/bin/env python3
"""Fix use_build_context_synchronously infos on AppLocalizations.of(context) lines
by reading the localizations once, right after the method's ScaffoldMessenger line.
usage: l10n_fixasync.py FILE
"""
import re,subprocess,sys
f=sys.argv[1]
for _ in range(30):
    out=subprocess.run(["flutter","analyze","--no-pub",f],capture_output=True,text=True).stdout
    hits=sorted({int(m.group(1)) for m in re.finditer(r":(\d+):\d+ • use_build_context_synchronously",out)})
    if not hits: break
    lines=open(f).read().split("\n")
    done=False
    for ln in reversed(hits):
        i=ln-1
        if "AppLocalizations.of(context)" not in lines[i]:
            # statement may start earlier; search a few lines up
            j=i
            while j>i-4 and "AppLocalizations.of(context)" not in lines[j]: j-=1
            if "AppLocalizations.of(context)" not in lines[j]: continue
            i=j
        m=None
        for k in range(i,max(i-80,0),-1):
            if "ScaffoldMessenger.of(context)" in lines[k]: m=k;break
        if m is None: continue
        if "final l10nAsync_ =" not in "\n".join(lines[m:m+3]):
            indent=re.match(r"\s*",lines[m]).group(0)
            lines.insert(m+1,f"{indent}final l10nAsync_ = AppLocalizations.of(context);")
            i+=1
        lines[i]=lines[i].replace("AppLocalizations.of(context)","l10nAsync_")
        done=True
        break
    if not done:
        print("manual fix needed at lines",hits); break
    open(f,"w").write("\n".join(lines))
subprocess.run(["dart","format",f],capture_output=True)
