"""WCAG contrast validation for Kivora tokens. Run: python3 contrast_check.py"""
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

L=dict(bg='#F7F8FC',surface='#FFFFFF',text='#172033',text2='#526078',border='#E2E7F0',
       primary='#0F766E',pressed='#0B5F58',
       success='#0F7A4F',warning='#8A5A00',error='#B42318',info='#0B5CAD',disabled='#8792A6')
D=dict(bg='#0B1520',surface='#111F2E',elev='#202B3D',text='#F4F6FB',text2='#B0BCD0',border='#354158',
       primary='#0F766E',pressed='#0B5F58',accent='#5EEAD4',
       success='#4ADE9A',warning='#F5B94A',error='#FF8A80',info='#7DB8FF',disabled='#6B778C')

rows=[]
def chk(name,fg,bg,need):
    r=ratio(fg,bg); rows.append((name,fg,bg,r,need,'PASS' if r>=need else 'FAIL'))
# Light
chk('L text / bg',L['text'],L['bg'],4.5); chk('L text / surface',L['text'],L['surface'],4.5)
chk('L text2 / bg',L['text2'],L['bg'],4.5); chk('L text2 / surface',L['text2'],L['surface'],4.5)
chk('L white / primary (button)','#FFFFFF',L['primary'],4.5)
chk('L white / pressed','#FFFFFF',L['pressed'],4.5)
chk('L primary text / surface',L['primary'],L['surface'],4.5)
chk('L primary text / bg',L['primary'],L['bg'],4.5)
chk('L border / bg (non-text)',L['border'],L['bg'],1.0)
chk('L primary focus ring / surface (non-text)',L['primary'],L['surface'],3.0)
for k in ('success','warning','error','info'):
    chk(f'L {k} text / surface',L[k],L['surface'],4.5)
    tint=blend(L[k],L['surface'],0.10); chk(f'L {k} text / 10% tint',L[k],tint,4.5)
chk('L disabled text / surface (informational only)',L['disabled'],L['surface'],3.0)
sel=blend(L['primary'],L['surface'],0.10); chk('L pressed(#0B5F58) / selected tint',L['pressed'],sel,4.5)
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
chk('D focus ring #5EEAD4 / surface (non-text)',D['accent'],D['surface'],3.0)
chk('D border / surface (non-text)',D['border'],D['surface'],1.0)
for k in ('success','warning','error','info'):
    chk(f'D {k} text / surface',D[k],D['surface'],4.5)
    tint=blend(D[k],D['surface'],0.16); chk(f'D {k} text / 16% tint',D[k],tint,4.5)
sel=blend(D['primary'],D['surface'],0.16); chk('D accent / selected tint',D['accent'],sel,4.5)
chk('D text / selected tint',D['text'],sel,4.5)
# The brief's raw starting token, as given
chk('RAW dark #0F766E text / surface #111F2E','#0F766E',D['surface'],4.5)
chk('RAW dark #0F766E text / bg #0B1520','#0F766E',D['bg'],4.5)
chk('RAW dark white / #0F766E button','#FFFFFF','#0F766E',4.5)
w=max(len(r[0]) for r in rows)
for n,fg,bg,r,need,res in rows:
    print(f'{n:<{w}}  {fg} on {bg}  {r:5.2f}:1  need {need}  {res}')
print('FAILS:',[r[0] for r in rows if r[5]=='FAIL'])
