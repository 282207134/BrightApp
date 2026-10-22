import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../data/models.dart';
import '../../shared/widgets.dart';
import 'demo_widgets.dart';

class FashionDemo extends StatefulWidget {
  const FashionDemo(this.variant, {super.key, this.product});
  final int variant;
  final Product? product;
  @override
  State<FashionDemo> createState() => _FashionDemoState();
}

class _FashionDemoState extends State<FashionDemo> {
  final favoriteIds = <String>{'dress0', 'dress2', 'dress4'};
  final dismissedWishlist = <String>{};
  final search = TextEditingController();
  String size = 'M';
  int color = 0, selectedStore = 0;
  bool flash = false;
  bool recent = true;
  @override
  void initState() {
    super.initState();
    if (widget.variant == 6) search.text = 'Long';
    if (widget.variant == 9) search.text = 'San';
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Product get selected => widget.product ?? productById('dress4');
  @override
  Widget build(BuildContext context) {
    final v = widget.variant;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: [1, 4, 14, 15].contains(v) ? _bottom() : null,
      body: SafeArea(
        child: switch (v) {
          0 || 1 => _shop(v),
          2 || 3 => _categories(v),
          4 || 15 => _grid(v),
          5 || 6 => _search(v),
          7 => _scanner(),
          8 || 9 || 10 || 11 => _locator(v),
          12 || 13 => _detail(v),
          14 => _wishlist(),
          _ => _magazine(v),
        },
      ),
    );
  }

  Widget _header(String title, {bool searchBar = false}) => Column(
    children: [
      DemoTopBar(title, onSearch: () => openPreview(context, 'fashion', 5)),
      if (searchBar)
        Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () => openPreview(context, 'fashion', 5),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BrightColors.canvas,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.search,
                    size: 16,
                    color: BrightColors.muted,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Search',
                      style: TextStyle(color: BrightColors.muted, fontSize: 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => openPreview(context, 'fashion', 7),
                    child: const Icon(CupertinoIcons.barcode, size: 23),
                  ),
                ],
              ),
            ),
          ),
        ),
    ],
  );
  Widget _bottom() => SafeArea(
    top: false,
    child: SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          5,
          (i) => IconButton(
            tooltip: ['Shop', 'Wishlist', 'Store locator', 'Bag', 'Profile'][i],
            onPressed: () {
              switch (i) {
                case 0:
                  openPreview(context, 'fashion', 1);
                case 1:
                  openPreview(context, 'fashion', 14);
                case 2:
                  openPreview(context, 'fashion', 8);
                case 3:
                  go(context, '/bag');
                case 4:
                  openPreview(context, 'profile', 0);
              }
            },
            icon: Icon(
              [
                CupertinoIcons.house,
                CupertinoIcons.heart,
                CupertinoIcons.location,
                CupertinoIcons.cart,
                CupertinoIcons.person,
              ][i],
              color: (widget.variant == 14 ? i == 1 : i == 0)
                  ? BrightColors.pink
                  : BrightColors.muted,
              size: 23,
            ),
          ),
        ),
      ),
    ),
  );
  Widget _shop(int v) => ListView(
    children: [
      _header('Shop', searchBar: true),
      ...List.generate(
        v == 0 ? 4 : 2,
        (i) => GestureDetector(
          onTap: () => openPreview(context, 'fashion', i == 0 ? 15 : 2),
          child: SizedBox(
            height: 345,
            child: Stack(
              fit: StackFit.expand,
              children: [
                DemoPhoto(
                  ['shop_women', 'shop_men', 'shop_kids', 'shop_couple'][i],
                  radius: 0,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black45],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (i == 0)
                      const Text(
                        'FEATURED',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    const SizedBox(height: 14),
                    Text(
                      ['FAST RELEASE HOODIE', 'Women’s', 'Men’s', 'Kids'][i],
                      style: heading(i == 0 ? 25 : 32, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    if (i > 0)
                      Text(
                        ['', '465 items', '424 items', '245 items'][i],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    const SizedBox(height: 34),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
  Widget _categories(int v) => Column(
    children: [
      _header('Women’s'),
      Expanded(
        child: ListView(
          children: List.generate(
            11,
            (i) => ExpansionTile(
              key: ValueKey('fashion-category-$i'),
              initiallyExpanded: v == 3 && i == 0,
              title: Text(
                [
                  'Dresses',
                  'Tops',
                  'Coats & Jackets',
                  'Jeans',
                  'Trousers',
                  'Skirts',
                  'Knitwear',
                  'Activewear',
                  'Shoes',
                  'Bags',
                  'Accessories',
                ][i],
              ),
              children: List.generate(
                3,
                (j) => ListTile(
                  contentPadding: const EdgeInsets.only(left: 40),
                  title: Text(
                    ['Shop all', 'New arrivals', 'Most popular'][j],
                    style: const TextStyle(
                      fontSize: 13,
                      color: BrightColors.muted,
                    ),
                  ),
                  onTap: () => openPreview(context, 'fashion', 4),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
  Widget _grid(int v) => Column(
    children: [
      _header(v == 4 ? 'Shop All Dresses' : 'Discover', searchBar: true),
      if (v == 15)
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 18),
          child: SectionHeading('Just For You'),
        ),
      Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 22,
            childAspectRatio: .58,
          ),
          itemCount: fashionProducts.length,
          itemBuilder: (_, i) {
            final p =
                fashionProducts[(i + (v == 4 ? 4 : 0)) %
                    fashionProducts.length];
            return GestureDetector(
              onTap: () => go(context, '/product', p),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: DemoPhoto(p.image, radius: v == 15 ? 8 : 0),
                        ),
                        Positioned(right: 0, top: 0, child: _heart(p.id)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(p.name, style: const TextStyle(fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(money(p.price), style: const TextStyle(fontSize: 13)),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
  Widget _heart(String id) => IconButton(
    tooltip: 'Favorite dress',
    onPressed: () => setState(
      () => favoriteIds.contains(id)
          ? favoriteIds.remove(id)
          : favoriteIds.add(id),
    ),
    icon: Icon(
      favoriteIds.contains(id)
          ? CupertinoIcons.heart_fill
          : CupertinoIcons.heart,
      size: 21,
      color: favoriteIds.contains(id) ? BrightColors.pink : BrightColors.ink,
    ),
  );
  Widget _search(int v) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(CupertinoIcons.arrow_left),
            ),
            Expanded(
              child: TextField(
                key: const ValueKey('fashion-search'),
                controller: search,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  filled: true,
                  fillColor: BrightColors.canvas,
                  prefixIcon: Icon(CupertinoIcons.search, size: 17),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Scan barcode',
              onPressed: () => openPreview(context, 'fashion', 7),
              icon: const Icon(CupertinoIcons.barcode),
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (search.text.isNotEmpty)
              ...[
                    'Long Sleeve Dress',
                    'Long winter Dress',
                    'Long Tops',
                    'Long Coats',
                  ]
                  .where(
                    (s) => s.toLowerCase().contains(search.text.toLowerCase()),
                  )
                  .map(
                    (text) => ListTile(
                      title: Text(text, style: const TextStyle(fontSize: 13)),
                      onTap: () => openPreview(context, 'fashion', 4),
                    ),
                  ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: Text('Recent Search')),
                TextButton(
                  onPressed: () => setState(() => recent = false),
                  child: const Text(
                    'Clear all',
                    style: TextStyle(color: BrightColors.muted, fontSize: 11),
                  ),
                ),
              ],
            ),
            if (recent)
              Wrap(
                spacing: 12,
                children: ['Gym clothes', 'Long Coat', 'Dress', 'Tops']
                    .map(
                      (s) => ActionChip(
                        label: Text(s, style: const TextStyle(fontSize: 11)),
                        onPressed: () => setState(() => search.text = s),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 30),
            if (search.text.isNotEmpty)
              PrimaryButton(
                'VIEW MATCHING COLLECTION',
                onPressed: () => openPreview(context, 'fashion', 4),
              ),
          ],
        ),
      ),
    ],
  );
  Widget _scanner() => Container(
    color: const Color(0xff343737),
    child: Column(
      children: [
        const DemoTopBar(
          'Scan a Barcode',
          color: Colors.black,
          ink: Colors.white,
        ),
        const Spacer(),
        Container(
          height: 190,
          margin: const EdgeInsets.all(24),
          color: Colors.white,
          child: Center(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 35),
              color: BrightColors.pink,
            ),
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'DEMO SCANNER · Camera is not connected',
          style: TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () => setState(() => flash = !flash),
          icon: const Icon(CupertinoIcons.bolt_slash, color: Colors.white),
          label: Text(
            flash ? 'ON · Demo' : 'OFF',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: PrimaryButton(
            'SCAN SAMPLE BARCODE',
            onPressed: () => openPreview(context, 'fashion', 13),
          ),
        ),
      ],
    ),
  );
  Widget _locator(int v) => Column(
    children: [
      const DemoTopBar('Store Locator', color: Colors.black, ink: Colors.white),
      if (v == 8 || v == 10)
        Expanded(
          flex: v == 8 ? 6 : 4,
          child: GestureDetector(
            onTap: () =>
                setState(() => selectedStore = (selectedStore + 1) % 5),
            child: CustomPaint(
              painter: _MapPainter(dark: v == 8, selected: selectedStore),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      Expanded(
        flex: v == 8 ? 2 : 5,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => openPreview(
                  context,
                  'fashion',
                  v == 8
                      ? 9
                      : v == 10
                      ? 11
                      : 10,
                ),
                child: const Icon(
                  CupertinoIcons.chevron_up,
                  color: BrightColors.pink,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: search,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: v == 8 ? 'Search location' : 'San Francisco',
                  filled: true,
                  fillColor: BrightColors.canvas,
                  prefixIcon: const Icon(CupertinoIcons.search, size: 17),
                ),
              ),
              if (v != 8)
                Expanded(
                  child: ListView(
                    children: [
                      if (v == 9)
                        ...[
                              'San Francisco',
                              'San Diego',
                              'San Antonio',
                              'San Bernardino',
                            ]
                            .where(
                              (s) => s.toLowerCase().contains(
                                search.text.toLowerCase(),
                              ),
                            )
                            .map(
                              (s) => ListTile(
                                title: Text(s),
                                onTap: () =>
                                    openPreview(context, 'fashion', 10),
                              ),
                            )
                      else
                        ...List.generate(
                          v == 10 ? 3 : 5,
                          (i) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              [
                                'Stonestown Galleria',
                                'Tahir Plaza',
                                'Apex Store',
                                'Serena Center',
                                'San Francisco Center',
                              ][i],
                              style: const TextStyle(fontSize: 13),
                            ),
                            subtitle: Text(
                              '${77 + i * 38} Wolf Cape Apt. ${280 + i}\nSan Francisco, CA',
                              style: const TextStyle(fontSize: 11, height: 1.8),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.location_solid,
                                  size: 17,
                                  color: selectedStore == i
                                      ? BrightColors.pink
                                      : BrightColors.muted,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${433 + i * 50}.3 m',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: BrightColors.muted,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => setState(() => selectedStore = i),
                          ),
                        ),
                      const DemoNote(
                        'Illustrative store map. No real location or directions are requested.',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    ],
  );
  Widget _detail(int v) => Column(
    children: [
      _header('Half Red Dress'),
      Expanded(
        child: ListView(
          children: [
            SizedBox(
              height: 330,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (_, i) => v == 12
                    ? Container(width: 250, color: const Color(0xffdc8787))
                    : DemoPhoto(selected.image, width: 270, radius: 0),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                '●  ●  ●',
                textAlign: TextAlign.center,
                style: TextStyle(color: BrightColors.pink, fontSize: 8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(selected.name, style: heading(20))),
                      Text(money(selected.price), style: heading(21)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '★★★★☆ (4.0)',
                    style: TextStyle(fontSize: 11, color: BrightColors.muted),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'The prints continue to confound with the occasional Half Full Dress that looks like an ordinary walking dress that looks like a formal ball dress.',
                    style: TextStyle(
                      color: BrightColors.muted,
                      height: 1.7,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Color'),
                  const SizedBox(height: 14),
                  Row(
                    children: List.generate(
                      4,
                      (i) => Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () => setState(() => color = i),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: [
                              const Color(0xffff6969),
                              Colors.cyanAccent,
                              Colors.blueAccent,
                              Colors.deepPurpleAccent,
                            ][i],
                            child: color == i
                                ? const Icon(
                                    CupertinoIcons.check_mark,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Select Size'),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    children: ['S', 'M', 'L']
                        .map(
                          (s) => ChoiceChip(
                            label: Text(s),
                            selected: size == s,
                            onSelected: (_) => setState(() => size = s),
                            showCheckmark: false,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  if (v == 12)
                    OutlinedButton(
                      onPressed: () {
                        setState(() => favoriteIds.add(selected.id));
                        toast(context, 'Saved to your local wishlist.');
                      },
                      child: const Text('ADD TO WISHLIST'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(28, 8, 28, 12),
        child: PrimaryButton('ADD TO BAG', onPressed: _addDress),
      ),
    ],
  );
  void _addDress() {
    ShopScope.of(context).add(selected, size: size, color: selected.image);
    toast(context, '${selected.name} · $size added to your bag.');
    showModalBottomSheet<void>(
      context: context,
      builder: (c) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Added to your bag', style: heading(26)),
              const SizedBox(height: 22),
              PrimaryButton(
                'VIEW MY BAG',
                onPressed: () {
                  Navigator.pop(c);
                  go(context, '/bag');
                },
              ),
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text('Continue browsing'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wishlist() => Column(
    children: [
      _header('Wishlist'),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: fashionProducts
              .take(5)
              .where((p) => !dismissedWishlist.contains(p.id))
              .length,
          separatorBuilder: (_, _) => const SizedBox(height: 22),
          itemBuilder: (_, i) {
            final p = fashionProducts
                .take(5)
                .where((p) => !dismissedWishlist.contains(p.id))
                .toList()[i];
            return Dismissible(
              key: ValueKey(p.id),
              onDismissed: (_) => setState(() => dismissedWishlist.add(p.id)),
              background: Container(
                color: BrightColors.pink,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                child: const Icon(CupertinoIcons.trash, color: Colors.white),
              ),
              child: Row(
                children: [
                  DemoPhoto(p.image, width: 115, height: 125, radius: 5),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(
                          'Color: ${i.isEven ? 'Blue' : 'Black'}\nSize: M\nQTY: 1',
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.9,
                            color: BrightColors.muted,
                          ),
                        ),
                        const SizedBox(height: 5),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(100, 30),
                            backgroundColor: BrightColors.ink,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                          onPressed: () {
                            ShopScope.of(context).add(p, size: 'M');
                            toast(context, 'Added to your bag.');
                          },
                          child: const Text(
                            'Add To Bag',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(money(p.price), style: const TextStyle(fontSize: 12)),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
  Widget _magazine(int v) => ListView(
    children: [
      DemoTopBar('Magazine', large: true),
      ...List.generate(
        3,
        (i) => GestureDetector(
          onTap: () => openPreview(context, 'articles', i.isEven ? 3 : 1),
          child: v == 16
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    children: [
                      DemoPhoto(
                        i.isEven ? 'magazine_one' : 'magazine_two',
                        height: 210,
                        width: double.infinity,
                        radius: 7,
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'SUMMER 2019–2020',
                        style: TextStyle(fontSize: 10),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        i.isEven
                            ? 'Curling Irons Are As Individual As\nThe Women Who Use Them'
                            : 'Aiming For Higher The Mastopexy',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: 360,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff665b5d), Color(0xff352f32)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        '28 JAN 2019  ·  12:00 AM',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        i.isEven
                            ? 'Curling Irons Are As Individual As\nThe Women Who Use Them'
                            : 'Aiming For Higher The Mastopexy',
                        style: heading(23, color: Colors.white),
                      ),
                      const SizedBox(height: 25),
                      const Row(
                        children: [
                          DemoAvatar(1, radius: 18),
                          SizedBox(width: 12),
                          Text(
                            'Randall Mason\nSeller',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    ],
  );
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.dark, required this.selected});
  final bool dark;
  final int selected;
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(
      Offset.zero & s,
      Paint()
        ..color = (dark ? const Color(0xff303434) : const Color(0xfff2f1ed)),
    );
    for (int i = -4; i < 12; i++) {
      final p = Paint()
        ..color = (dark ? Colors.white12 : Colors.white)
        ..strokeWidth = i % 3 == 0 ? 8 : 3;
      c.drawLine(Offset(i * 62.0, 0), Offset(i * 62.0 + 140, s.height), p);
      c.drawLine(Offset(0, i * 76.0), Offset(s.width, i * 76.0 - 90), p);
    }
    for (int i = 0; i < 5; i++) {
      final x = s.width * (.17 + (i % 3) * .27),
          y = s.height * (.19 + (i % 4) * .18);
      c.drawCircle(
        Offset(x, y),
        i == selected ? 16 : 12,
        Paint()..color = BrightColors.pink,
      );
      final t = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      t.paint(c, Offset(x - t.width / 2, y - t.height / 2));
    }
  }

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.selected != selected || old.dark != dark;
}
