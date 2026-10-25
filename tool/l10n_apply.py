#!/usr/bin/env python3
"""Move hardcoded English literals of one Dart file into the ARB files.

usage: l10n_apply.py BATCH.json
BATCH.json = {"file": "lib/..dart", "entries": [{"src": "<literal text exactly as in the source>",
              "key": "camelKey", "ur": "...", "ar": "..."}]}
Interpolations ($x / ${expr}) in src become placeholders {a},{b},... in all three
languages (write {a},{b} in ur/ar in the same order). Then run `flutter gen-l10n`.
After applying, run tool/l10n_fixconst.py FILE to drop `const` the analyzer rejects.
"""
import json,re,sys,collections
batch=json.load(open(sys.argv[1]))
path=batch["file"]
src=open(path).read()
interp=re.compile(r"\$\{([^}]+)\}|\$([A-Za-z_][A-Za-z0-9_]*)")
LETTERS="abcdefgh"

def unescape(t):
    return t.replace("\\'","'").replace("\\n","\n").replace("\\$","$").replace('\\"','"')

arb={l:json.load(open(f"lib/l10n/app_{l}.arb"),object_pairs_hook=collections.OrderedDict) for l in ("en","ur","ar")}
missing=[]
for e in batch["entries"]:
    lit="'"+e["src"]+"'"
    if lit not in src:
        missing.append(e["src"]); continue
    args=[]
    def sub(m):
        expr=m.group(1) or m.group(2)
        args.append(expr)
        return "{"+LETTERS[len(args)-1]+"}"
    en=unescape(interp.sub(sub,e["src"]))
    key=e["key"]
    # existing key (git HEAD or earlier batch) with different text would overwrite a translation
    if key in arb["en"] and arb["en"][key]!=en:
        raise SystemExit(f"key clash with different text: {key}")
    arb["en"][key]=en; arb["ur"][key]=e["ur"]; arb["ar"][key]=e["ar"]
    if args:
        arb["en"]["@"+key]={"placeholders":{LETTERS[i]:{"type":"String"} for i in range(len(args))}}
        def call(a):
            return a+".toString()" if re.fullmatch(r"[\w.!?]+",a) else "("+a+").toString()"
        rep="AppLocalizations.of(context)."+key+"("+", ".join(call(a) for a in args)+")"
    else:
        rep="AppLocalizations.of(context)."+key
    src=src.replace(lit,rep)
if "l10n/app_localizations.dart" not in src:
    depth=path.count("/")-1  # lib/a/b/c.dart -> ../ * (parts after lib - 1)
    rel="../"*(path.count("/")-1)+"l10n/app_localizations.dart"
    first=src.index("import ")
    src=src[:first]+f"import '{rel}';\n"+src[first:]
open(path,"w").write(src)
for l,d in arb.items():
    json.dump(d,open(f"lib/l10n/app_{l}.arb","w"),ensure_ascii=False,indent=2); open(f"lib/l10n/app_{l}.arb","a").write("\n")
print("applied",len(batch["entries"])-len(missing),"missing",missing)
