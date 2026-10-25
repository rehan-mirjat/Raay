"""Helper for hand-written migrations: add (key, en, ur, ar) rows to the ARB files.
Placeholders are written {a},{b},... in all three texts; they are declared as String.
Refuses to overwrite an existing key whose English text differs.
"""
import json,collections,re
def add(rows):
    arb={l:json.load(open(f"lib/l10n/app_{l}.arb"),object_pairs_hook=collections.OrderedDict) for l in ("en","ur","ar")}
    for key,en,ur,ar in rows:
        if key in arb["en"] and arb["en"][key]!=en:
            raise SystemExit(f"key clash: {key}")
        arb["en"][key]=en; arb["ur"][key]=ur; arb["ar"][key]=ar
        ph=sorted(set(re.findall(r"\{(\w+)\}",en)))
        if ph: arb["en"]["@"+key]={"placeholders":{x:{"type":"String"} for x in ph}}
    for l,d in arb.items():
        json.dump(d,open(f"lib/l10n/app_{l}.arb","w"),ensure_ascii=False,indent=2); open(f"lib/l10n/app_{l}.arb","a").write("\n")
