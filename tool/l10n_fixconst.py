#!/usr/bin/env python3
"""Iteratively remove `const` keywords that make localized (non-const) values illegal.
usage: l10n_fixconst.py FILE
"""
import re,subprocess,sys
f=sys.argv[1]
for _ in range(60):
    out=subprocess.run(["flutter","analyze","--no-pub",f],capture_output=True,text=True).stdout
    errs=[m for m in re.finditer(r"error • .*?(?:const_eval_method_invocation|invalid_constant|non_constant_[a-z_]+|const_with_non_const|non_constant_default_value|const_initialized_with_non_constant_value)\b.*?:(\d+):(\d+)",out)]
    if not errs:
        errs=[m for m in re.finditer(r"error • (?:Invalid constant value|Methods can't be invoked in constant expressions|The constructor being called isn't a const constructor|Not a constant expression).*?:(\d+):(\d+)",out)]
    if not errs:
        print(out.strip().splitlines()[-1] if out.strip() else "ok"); break
    text=open(f).read(); lines=text.split("\n")
    changed=False
    # fix the last error first so earlier offsets stay valid
    for m in reversed(errs):
        line,col=int(m.group(1)),int(m.group(2))
        off=sum(len(l)+1 for l in lines[:line-1])+col-1
        i=off
        found=None
        while i>0 and off-i<3000:
            i=text.rfind("const ",0,i)
            if i<0: break
            seg=text[i:off]
            depth=seg.count("(")+seg.count("[")+seg.count("{")-seg.count(")")-seg.count("]")-seg.count("}")
            if depth>0 or i+6>=off-0 and False:
                found=i;break
        if found is None:
            # error may sit on a `const` declaration (e.g. `const x = ...`) on the same line
            j=text.rfind("const ",0,off+1)
            if j>=0 and text.count("\n",j,off)==0: found=j
        if found is None: continue
        text=text[:found]+text[found+6:]; changed=True
        lines=text.split("\n")
        break
    if not changed:
        print("could not auto-fix:\n"+"\n".join(m.group(0) for m in errs)); break
    open(f,"w").write(text)
subprocess.run(["dart","fix","--apply",f],capture_output=True)
subprocess.run(["dart","format",f],capture_output=True)
