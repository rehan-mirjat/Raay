"""WCAG token-pair check, reading live constants from app_theme.dart."""
from pathlib import Path
import re

THEME_SOURCE = Path(__file__).resolve().parents[2] / 'lib/core/theme/app_theme.dart'
THEME_TEXT = THEME_SOURCE.read_text()

def token(name):
    match = re.search(
        rf'static const Color\s+{re.escape(name)}\s*=\s*(?:Color\(0xFF([0-9A-Fa-f]{{6}})\)|(Colors\.white))',
        THEME_TEXT,
    )
    if not match:
        raise ValueError(f'Could not find AppTheme color token: {name}')
    return '#FFFFFF' if match.group(2) else '#' + match.group(1).upper()

def lin(c):
    c/=255
    return c/12.92 if c<=0.03928 else ((c+0.055)/1.055)**2.4
def lum(h):
    h=h.lstrip('#'); r,g,b=[int(h[i:i+2],16) for i in (0,2,4)]
    return 0.2126*lin(r)+0.7152*lin(g)+0.0722*lin(b)
def ratio(a,b):
    la,lb=lum(a),lum(b); hi,lo=max(la,lb),min(la,lb)
    return (hi+0.05)/(lo+0.05)
def blend(fg,bg,a):
    f=[int(fg.lstrip('#')[i:i+2],16) for i in (0,2,4)]
    b=[int(bg.lstrip('#')[i:i+2],16) for i in (0,2,4)]
    return '#%02X%02X%02X'%tuple(round(f[i]*a+b[i]*(1-a)) for i in range(3))

L=dict(bg=token('backgroundLight'),surface=token('surfaceWhite'),text=token('textPrimary'),
       text2=token('textSecondary'),border=token('borderLight'),primary=token('primaryBlue'),
       pressed=token('primaryBlueDark'),accent=token('accentTextLight'),
       success=token('successTextLight'),warning=token('warningTextLight'),
       error=token('errorTextLight'),info=token('infoTextLight'))
D=dict(bg=token('darkBackground'),surface=token('darkSurface'),elev=token('darkElevated'),
       text=token('darkTextPrimary'),text2=token('darkTextSecondary'),border=token('darkBorder'),
       primary=token('primaryBlue'),pressed=token('primaryBlueDark'),accent=token('accentTextDark'),
       success=token('successTextDark'),warning=token('warningTextDark'),
       error=token('errorTextDark'),info=token('infoTextDark'))

rows=[]
def chk(name,fg,bg,need):
    r=ratio(fg,bg); rows.append((name,fg,bg,r,need,'PASS' if r>=need else 'FAIL'))
# Light
chk('L text / bg',L['text'],L['bg'],4.5); chk('L text / surface',L['text'],L['surface'],4.5)
chk('L text2 / bg',L['text2'],L['bg'],4.5); chk('L text2 / surface',L['text2'],L['surface'],4.5)
chk('L white / primary (button)','#FFFFFF',L['primary'],4.5)
chk('L white / pressed','#FFFFFF',L['pressed'],4.5)
chk('L accent text / surface',L['accent'],L['surface'],4.5)
chk('L accent text / bg',L['accent'],L['bg'],4.5)
chk('L border / bg (non-text)',L['border'],L['bg'],1.0)
chk('L primary focus ring / surface (non-text)',L['primary'],L['surface'],3.0)
for k in ('success','warning','error','info'):
    chk(f'L {k} text / surface',L[k],L['surface'],4.5)
    tint=blend(L[k],L['surface'],0.10); chk(f'L {k} text / 10% tint',L[k],tint,4.5)
sel=blend(L['primary'],L['surface'],0.10); chk('L accent text / selected tint',L['accent'],sel,4.5)
chk('L text / selected tint',L['text'],sel,4.5)
# Dark
chk('D text / bg',D['text'],D['bg'],4.5); chk('D text / surface',D['text'],D['surface'],4.5)
chk('D text / elev',D['text'],D['elev'],4.5)
chk('D text2 / bg',D['text2'],D['bg'],4.5); chk('D text2 / surface',D['text2'],D['surface'],4.5)
chk('D text2 / elev',D['text2'],D['elev'],4.5)
chk('D white / primary (button label)','#FFFFFF',D['primary'],4.5)
chk('D white / pressed','#FFFFFF',D['pressed'],4.5)
chk('D accent text / bg',D['accent'],D['bg'],4.5)
chk('D accent text / surface',D['accent'],D['surface'],4.5)
chk('D accent text / elev',D['accent'],D['elev'],4.5)
chk('D focus ring / surface (non-text)',D['accent'],D['surface'],3.0)
chk('D border / surface (non-text)',D['border'],D['surface'],1.0)
for k in ('success','warning','error','info'):
    chk(f'D {k} text / surface',D[k],D['surface'],4.5)
    tint=blend(D[k],D['surface'],0.16); chk(f'D {k} text / 16% tint',D[k],tint,4.5)
sel=blend(D['primary'],D['surface'],0.16); chk('D accent / selected tint',D['accent'],sel,4.5)
chk('D text / selected tint',D['text'],sel,4.5)
w=max(len(r[0]) for r in rows)
for n,fg,bg,r,need,res in rows:
    print(f'{n:<{w}}  {fg} on {bg}  {r:5.2f}:1  need {need}  {res}')
print('FAILS:',[r[0] for r in rows if r[5]=='FAIL'])
