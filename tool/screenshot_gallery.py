"""Build documentation images and the exhaustive screenshot index."""
from pathlib import Path
import json
import re
from PIL import Image, ImageDraw, ImageFont

folder = Path('docs/screenshots')
font_path = Path('/System/Library/Fonts/Supplemental/Arial.ttf')
font = ImageFont.truetype(str(font_path), 16) if font_path.exists() else ImageFont.load_default(size=16)

def montage(paths, target, columns=6, thumb_width=180, thumb_height=410):
    rows = (len(paths) + columns - 1) // columns
    cell_width, cell_height = thumb_width + 20, thumb_height + 50
    sheet = Image.new('RGB', (cell_width * columns, cell_height * rows), '#edf0f5')
    draw = ImageDraw.Draw(sheet)
    for i, path in enumerate(paths):
        image = Image.open(path).convert('RGB')
        image.thumbnail((thumb_width, thumb_height))
        x, y = (i % columns) * cell_width, (i // columns) * cell_height
        sheet.paste(image, (x + (cell_width - image.width) // 2, y + 10))
        label = path.stem
        if label.startswith('ui_'):
            label = label[7:]
        draw.text((x + 8, y + thumb_height + 22), label[:28], font=font, fill='#252830')
    sheet.save(target, quality=92)

journey = sorted(folder.glob('[0-9]*.png'))
if journey:
    montage(journey, folder / 'contact_sheet.jpg')
for output, names in {
    'main_screens': ['01_discover', '10_product', '18_bag'],
    'checkout_screens': ['19_shipping', '21_payment', '23_order_success'],
    'module_screens': ['00_gallery', 'ui_063_Dashboard_1', 'ui_078_Feed_1', 'ui_084_Chat_2', 'ui_068_Profile_1', 'ui_093_Articles_1'],
}.items():
    paths = [folder / (name + '.png') for name in names]
    if all(path.exists() for path in paths):
        montage(paths, Path('docs') / (output + '.jpg'), columns=3, thumb_width=340, thumb_height=760)

pages = json.loads(Path('docs/design/frames.json').read_text())
index = ['# 界面截图索引', '', '截图来自 iPhone 17 Pro / iOS 26.0 模拟器中的实际 Flutter 页面。画板预览顶部的目录及前后切换条属于展示 App 的导航。', '', '97 个画板预览 + 12 个模块列表 + 1 个模块目录 + 31 个购物流程页面 / 状态，共 141 张 PNG。', '', '## 模块目录', '', '![模块目录](screenshots/00_gallery.png)', '', '## 全部 97 个画板', '']
counter = 0
for category, page in enumerate(pages):
    files = []
    rows = []
    for frame in page['frames']:
        counter += 1
        name = re.sub(r'[^a-zA-Z0-9]+', '_', frame['frameName'].strip())
        filename = f'ui_{counter:03d}_{name}.png'
        path = folder / filename
        if path.exists():
            files.append(path)
        rows.append(f"| {counter:03d} | {frame['frameName'].strip()} | `{frame['frameId']}` | [截图](screenshots/{filename}) |")
    overview = f'module_{category + 1:02d}_overview.jpg'
    if files:
        montage(files, folder / overview, columns=min(5, len(files)), thumb_width=180, thumb_height=410)
    index += [f"### {page['pageName'].strip()}", '', f'[模块列表截图](screenshots/module_{category + 1:02d}.png)', '', f'![模块页面总览](screenshots/{overview})', '', '| 序号 | Pixso 画板 | 节点 ID | 实际界面 |', '| --- | --- | --- | --- |', *rows, '']
index += ['## 独立购物流程及补充状态', '', '![购物流程截图总览](screenshots/contact_sheet.jpg)', '', '| 文件 | 界面 / 状态 |', '| --- | --- |']
labels = ['运动鞋首页','启动页','引导页','登录','注册','重置密码','商品集合','搜索','筛选','商品详情','尺码选择','商品说明','测脚说明','演示扫描','示例尺码结果','媒体预览','加入购物袋确认','购物袋','配送方式','地址','演示卡片','订单确认','下单成功','历史订单','收藏','个人中心','通知列表','空通知','设置','应用说明','空购物袋']
for i, label in enumerate(labels, 1):
    matches = sorted(folder.glob(f'{i:02d}_*.png'))
    if matches:
        index.append(f'| [{matches[0].name}](screenshots/{matches[0].name}) | {label} |')
Path('docs/SCREENSHOTS.md').write_text('\n'.join(index) + '\n')
print(f'Indexed {counter} design frames; {len(list(folder.glob("*.png")))} PNG screenshots present.')
