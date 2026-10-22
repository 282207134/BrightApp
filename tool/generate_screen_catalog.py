"""Generate the immutable 97-frame catalog from the read-only Pixso manifest."""
import json
from pathlib import Path
pages=json.loads(Path('docs/design/frames.json').read_text())
lines=["class ScreenSpec {", "  const ScreenSpec(this.category, this.id, this.name, this.variant, this.kind);", "  final int category, variant;", "  final String id, name, kind;", "}", "", "const moduleNames = ['Splash Screens', 'Onboarding', 'Login', 'Register', 'E-commerce', 'Dashboard', 'Profile', 'Menu', 'Feed', 'Chat', 'Activity', 'Articles'];", "const screens = <ScreenSpec>["]
kinds=['splash','onboarding','login','register','fashion','dashboard','profile','menu','feed','chat','activity','articles']
for i,page in enumerate(pages):
 for j,frame in enumerate(page['frames']):
  kind='sneakers' if i==4 and j<18 else kinds[i]
  variant=j if kind!='fashion' else j-18
  lines.append(f"  ScreenSpec({i}, '{frame['frameId']}', '{frame['frameName'].strip()}', {variant}, '{kind}'),")
lines.append('];\n')
Path('lib/data/screen_catalog.dart').write_text('\n'.join(lines))
print(sum(len(p['frames']) for p in pages),'registered frames')
