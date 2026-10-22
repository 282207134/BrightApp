import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../data/models.dart';
import '../../shared/widgets.dart';
import '../account/account_pages.dart';
import '../checkout/checkout_pages.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final store = ShopScope.of(context);
    const icons = [
      CupertinoIcons.house,
      CupertinoIcons.heart,
      CupertinoIcons.square_grid_2x2,
      CupertinoIcons.cart,
      CupertinoIcons.person,
    ];
    const labels = ['Discover', 'Wishlist', 'Collection', 'My Bag', 'Profile'];
    return Scaffold(
      body: switch (tab) {
        0 => const DiscoverPage(),
        1 => const WishlistPage(embedded: true),
        2 => const CollectionPage(embedded: true),
        3 => const BagPage(embedded: true),
        _ => const ProfilePage(),
      },
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: BrightColors.canvas),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(
                5,
                (i) => Expanded(
                  child: Semantics(
                    selected: tab == i,
                    label: labels[i],
                    button: true,
                    child: InkWell(
                      key: ValueKey('tab-$i'),
                      onTap: () => setState(() => tab = i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Badge(
                            isLabelVisible: i == 3 && store.count > 0,
                            label: Text('${store.count}'),
                            backgroundColor: BrightColors.pink,
                            child: Icon(
                              icons[i],
                              color: tab == i
                                  ? BrightColors.pink
                                  : const Color(0xff93969c),
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 9,
                              color: tab == i
                                  ? BrightColors.pink
                                  : BrightColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  int brand = 0, category = 1;
  static const brands = ['Nike', 'Adidas', 'Jordan', 'Puma', 'Reebok'];
  @override
  Widget build(BuildContext context) {
    final featured = brand == 2
        ? [products[4]]
        : category == 0
        ? [products[6], products[7]]
        : category == 2
        ? [products[2], products[3]]
        : [products[0], products[1]];
    return SafeArea(
      bottom: false,
      child: Container(
        color: BrightColors.canvas,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
                      child: Row(
                        children: [
                          Expanded(child: Text('Discover', style: heading(34))),
                          IconButton(
                            tooltip: 'All modules',
                            onPressed: () => go(context, '/gallery'),
                            icon: const Icon(
                              CupertinoIcons.square_grid_2x2,
                              size: 20,
                            ),
                          ),
                          RoundIcon(
                            CupertinoIcons.search,
                            label: 'Search',
                            onPressed: () => go(context, '/search'),
                          ),
                          const SizedBox(width: 6),
                          RoundIcon(
                            CupertinoIcons.bell,
                            label: 'Notifications',
                            onPressed: () => go(context, '/notifications'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: brands.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 26),
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: () {
                            if (i == 0 || i == 2) {
                              setState(() => brand = i);
                            } else {
                              toast(
                                context,
                                'No ${brands[i]} products in this demo catalog yet.',
                              );
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 3,
                                  color: brand == i
                                      ? BrightColors.pink
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                            child: Text(
                              brands[i],
                              style: TextStyle(
                                fontSize: 18,
                                color: brand == i
                                    ? BrightColors.ink
                                    : const Color(0xffb9b9bd),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      height: 318,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                3,
                                (i) => GestureDetector(
                                  onTap: () => setState(() => category = i),
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(9),
                                      child: Text(
                                        ['Upcoming', 'Featured', 'New'][i],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: category == i
                                              ? BrightColors.ink
                                              : const Color(0xffb8b9bd),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              padding: const EdgeInsets.only(
                                left: 14,
                                right: 28,
                                bottom: 10,
                              ),
                              itemCount: featured.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 36),
                              itemBuilder: (_, i) {
                                final p =
                                    featured[(i + (category == 2 ? 1 : 0)) %
                                        featured.length];
                                return GestureDetector(
                                  key: ValueKey('featured-${p.id}'),
                                  onTap: () => go(context, '/product', p),
                                  child: SizedBox(
                                    width: 218,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(p.color),
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(
                                                  p.color,
                                                ).withValues(alpha: .15),
                                                blurRadius: 28,
                                                offset: const Offset(0, 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 18,
                                          top: 22,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                p.brand.toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                p.name,
                                                style: heading(
                                                  23,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                money(p.price),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 3,
                                          right: 2,
                                          child: FavoriteButton(
                                            p,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Positioned(
                                          top: 110,
                                          left: 8,
                                          right: -30,
                                          bottom: 44,
                                          child: ShoeImage(p.image),
                                        ),
                                        const Positioned(
                                          bottom: 18,
                                          right: 22,
                                          child: Icon(
                                            CupertinoIcons.arrow_right,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 12, 4),
              sliver: SliverToBoxAdapter(
                child: SectionHeading(
                  'More',
                  trailing: IconButton(
                    tooltip: 'View all products',
                    onPressed: () => go(context, '/collection'),
                    icon: const Icon(CupertinoIcons.arrow_right, size: 26),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: .88,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ProductTile(products[[2, 3, 4, 5][i]]),
                  childCount: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key, this.embedded = false});
  final bool embedded;
  @override
  Widget build(BuildContext context) {
    final content = CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () => go(context, '/product', productById('mamba')),
            child: SizedBox(
              height: 280,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/mamba_banner.webp',
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xbb000000), Color(0x22000000)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'BEST SELLER',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Nike Black Mamba',
                          style: heading(30, color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '\$128.00',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'SHOP THE COLLECTION  →',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
          sliver: SliverToBoxAdapter(
            child: SectionHeading(
              'The collection',
              trailing: IconButton(
                tooltip: 'Search and filter',
                onPressed: () => go(context, '/search'),
                icon: const Icon(CupertinoIcons.slider_horizontal_3),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: .82,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) => ProductTile(sneakerProducts[i]),
              childCount: sneakerProducts.length,
            ),
          ),
        ),
      ],
    );
    return embedded
        ? SafeArea(
            bottom: false,
            child: ColoredBox(color: BrightColors.canvas, child: content),
          )
        : PageFrame(
            title: 'Nike',
            child: ColoredBox(color: BrightColors.canvas, child: content),
          );
  }
}

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key, this.embedded = false});
  final bool embedded;
  @override
  Widget build(BuildContext context) {
    final store = ShopScope.of(context),
        items = products
            .where((p) => ShopScope.of(context).favorites.contains(p.id))
            .toList();
    final child = items.isEmpty
        ? EmptyState(
            'Your wishlist is waiting',
            'Save the pairs you love with the heart icon.',
            icon: CupertinoIcons.heart,
            action: PrimaryButton(
              'DISCOVER SNEAKERS',
              onPressed: () => go(context, '/collection'),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 24),
            itemBuilder: (_, i) {
              final p = items[i];
              return Row(
                children: [
                  GestureDetector(
                    onTap: () => go(context, '/product', p),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: BrightColors.canvas,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ShoeImage(p.image),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(fontSize: 11)),
                        const SizedBox(height: 7),
                        Text(money(p.price), style: heading(24)),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 115,
                          height: 34,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              store.add(p);
                              toast(context, 'Added to your bag · UK 8');
                            },
                            child: const Text(
                              'ADD TO CART',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FavoriteButton(p),
                ],
              );
            },
          );
    final title = Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Row(
        children: [
          Expanded(child: Text('Wishlist', style: heading(34))),
          Text(
            'Total ${items.length} items',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
    return embedded
        ? SafeArea(
            bottom: false,
            child: Column(
              children: [
                title,
                const Divider(height: 1),
                Expanded(child: child),
              ],
            ),
          )
        : PageFrame(title: 'Wishlist', child: child);
  }
}

class CatalogFilter {
  CatalogFilter({
    this.range = const RangeValues(0, 220),
    Set<String>? brands,
    this.color,
  }) : brands = brands ?? {};
  RangeValues range;
  Set<String> brands;
  int? color;
  bool accepts(Product p) =>
      p.price >= range.start * 100 &&
      p.price <= range.end * 100 &&
      (brands.isEmpty || brands.contains(p.brand)) &&
      (color == null || p.color == color);
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  final searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  CatalogFilter filter = CatalogFilter();
  @override
  Widget build(BuildContext context) {
    final result = products
        .where(
          (p) =>
              p.category == 'sneakers' &&
              p.name.toLowerCase().contains(query.toLowerCase()) &&
              filter.accepts(p),
        )
        .toList();
    return PageFrame(
      title: 'Find your pair',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const ValueKey('search-field'),
                    controller: searchController,
                    onChanged: (v) => setState(() => query = v),
                    decoration: const InputDecoration(
                      hintText: 'Search sneakers',
                      prefixIcon: Icon(CupertinoIcons.search),
                      filled: true,
                      fillColor: BrightColors.canvas,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                RoundIcon(
                  CupertinoIcons.slider_horizontal_3,
                  label: 'Filter',
                  onPressed: () async {
                    final value = await Navigator.push<CatalogFilter>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FilterPage(initial: filter),
                      ),
                    );
                    if (value != null && mounted) {
                      setState(() => filter = value);
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${result.length} sneakers',
                  style: const TextStyle(color: BrightColors.muted),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() {
                    query = '';
                    searchController.clear();
                    filter = CatalogFilter();
                  }),
                  child: const Text('Reset filters'),
                ),
              ],
            ),
          ),
          Expanded(
            child: result.isEmpty
                ? const EmptyState(
                    'No sneakers found',
                    'Try another search or clear your filters.',
                    icon: CupertinoIcons.search,
                  )
                : ColoredBox(
                    color: BrightColors.canvas,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: .85,
                          ),
                      itemCount: result.length,
                      itemBuilder: (_, i) => ProductTile(result[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class FilterPage extends StatefulWidget {
  const FilterPage({super.key, this.initial});
  final CatalogFilter? initial;
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late CatalogFilter filter;
  @override
  void initState() {
    super.initState();
    filter = CatalogFilter(
      range: widget.initial?.range ?? const RangeValues(0, 220),
      brands: {...?widget.initial?.brands},
      color: widget.initial?.color,
    );
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Filter',
    bottom: PrimaryButton(
      'APPLY FILTERS',
      onPressed: () => Navigator.pop(context, filter),
    ),
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SectionHeading(
          'Price Range',
          trailing: TextButton(
            onPressed: () => setState(() => filter = CatalogFilter()),
            child: const Text('Clear'),
          ),
        ),
        const SizedBox(height: 24),
        RangeSlider(
          values: filter.range,
          min: 0,
          max: 220,
          divisions: 44,
          labels: RangeLabels(
            money((filter.range.start * 100).round()),
            money((filter.range.end * 100).round()),
          ),
          onChanged: (v) => setState(() => filter.range = v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(money((filter.range.start * 100).round())),
            const Text('To'),
            Text(money((filter.range.end * 100).round())),
          ],
        ),
        const SizedBox(height: 44),
        const SectionHeading('Color'),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 14,
          children: [0xffd99b88, 0xff438fd3, 0xffee7c9f, 0xff33383a, 0xffa1d846]
              .map(
                (c) => GestureDetector(
                  onTap: () => setState(
                    () => filter.color = filter.color == c ? null : c,
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(c),
                    child: filter.color == c
                        ? const Icon(
                            CupertinoIcons.check_mark,
                            color: Colors.white,
                            size: 20,
                          )
                        : null,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 44),
        const SectionHeading('Select Brand'),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 14,
          children: ['Nike', 'Jordan']
              .map(
                (b) => FilterChip(
                  label: Text(b),
                  selected: filter.brands.contains(b),
                  onSelected: (v) => setState(() {
                    v ? filter.brands.add(b) : filter.brands.remove(b);
                  }),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}
