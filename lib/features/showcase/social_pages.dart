import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';
import 'demo_widgets.dart';

class DashboardDemo extends StatefulWidget {
  const DashboardDemo(this.variant, {super.key});
  final int variant;
  @override
  State<DashboardDemo> createState() => _DashboardDemoState();
}

class _DashboardDemoState extends State<DashboardDemo> {
  int period = 0, point = 3;
  bool earnings = true;
  @override
  Widget build(BuildContext context) {
    final v = widget.variant;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            if (v < 2)
              Container(
                height: 270,
                decoration: const BoxDecoration(
                  color: Color(0xffffe4bd),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(60),
                  ),
                ),
                child: Column(
                  children: [
                    DemoTopBar('Nike Air Max-270', color: Colors.transparent),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(14),
                        child: ShoeImage('dashboard_shoe'),
                      ),
                    ),
                  ],
                ),
              )
            else
              DemoTopBar(v == 2 ? 'Overview' : 'Dashboard', large: v == 4),
            if (v < 2) ...[
              LineChart(
                color: v == 0 && earnings ? blue : Colors.orange,
                height: 255,
                selected: point,
                onTap: () => setState(() => point = (point + 1) % 7),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Jan'),
                    Text('Feb'),
                    Text('Mar'),
                    Text('Apr'),
                    Text('May'),
                    Text('Jun'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => setState(() => earnings = true),
                          child: Text(
                            'Total Earnings',
                            style: TextStyle(
                              fontSize: 18,
                              color: earnings
                                  ? BrightColors.ink
                                  : BrightColors.muted,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => earnings = false),
                          child: Text(
                            'Product Sold',
                            style: TextStyle(
                              fontSize: 18,
                              color: !earnings
                                  ? BrightColors.ink
                                  : BrightColors.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      earnings && v == 0 ? '\$10,302.00' : '870',
                      style: heading(24),
                    ),
                  ],
                ),
              ),
            ],
            if (v == 2)
              ...List.generate(
                3,
                (i) => _ChartCard(
                  ['Total Balance', 'Today Sales', 'Weekly Sales'][i],
                  ['\$32,435.75', '\$845.00', '\$2,378.00'][i],
                  [blue, Colors.deepOrange, Colors.purpleAccent][i],
                  point,
                  () => setState(() => point = (point + 1) % 7),
                ),
              ),
            if (v == 3) ...[
              DateSelector(
                value: period,
                onChanged: (n) => setState(() => period = n),
              ),
              LineChart(
                color: const Color(0xff43cfc2),
                selected: point,
                onTap: () => setState(() => point = (point + 1) % 7),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '${['Day', 'Week', 'Month', 'Year'][period]} total  ·  \$${490 + period * 830}.00',
                  style: heading(23),
                ),
              ),
            ],
            if (v == 4)
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Total Balance',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Text(
                          '\$32,435.75',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 190,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          7,
                          (i) => Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 21,
                                height: <double>[
                                  95,
                                  55,
                                  120,
                                  62,
                                  145,
                                  32,
                                  78,
                                ][i],
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                [
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                  'Sun',
                                ][i],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (v >= 3) ...[
              const Padding(
                padding: EdgeInsets.all(20),
                child: SectionHeading('Recent Transactions'),
              ),
              ...List.generate(
                3,
                (i) => Card(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: blue,
                      child: Icon(
                        i == 0 ? CupertinoIcons.bag : CupertinoIcons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      [
                        'Summer Short Dress',
                        'Verna Roberson',
                        'New collection',
                      ][i],
                      style: const TextStyle(fontSize: 13),
                    ),
                    subtitle: const Text(
                      'Local sample transaction',
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: Text(['\$498.10', '\$1,275.75', '\$845.00'][i]),
                    onTap: () =>
                        toast(context, 'Sample transaction · No real payment.'),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard(this.title, this.value, this.color, this.point, this.tap);
  final String title, value;
  final Color color;
  final int point;
  final VoidCallback tap;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(16, 16, 16, 6),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .06),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(child: Text(title)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(value, style: heading(23)),
                  const Text(
                    '+35%',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        LineChart(color: color, height: 160, selected: point, onTap: tap),
        const Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            'JAN     FEB     MAR     APR     MAY     JUN     JUL',
            style: TextStyle(fontSize: 10, color: BrightColors.muted),
          ),
        ),
      ],
    ),
  );
}

class ProfileDemo extends StatefulWidget {
  const ProfileDemo(this.variant, {super.key});
  final int variant;
  @override
  State<ProfileDemo> createState() => _ProfileDemoState();
}

class _ProfileDemoState extends State<ProfileDemo> {
  bool followed = false;
  @override
  Widget build(BuildContext context) {
    final v = widget.variant;
    final dark = v == 3;
    return Scaffold(
      backgroundColor: dark ? BrightColors.ink : Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            DemoTopBar(
              v == 0
                  ? 'Profile'
                  : v == 4
                  ? 'Profile'
                  : '',
              large: v == 0,
              color: dark ? BrightColors.ink : Colors.white,
              ink: dark ? Colors.white : BrightColors.ink,
            ),
            if (v == 2)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const DemoPhoto('avatar_designer', height: 140, width: 120),
                    const SizedBox(width: 22),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Anna Rakita', style: heading(26)),
                          const SizedBox(height: 8),
                          const Text(
                            'FASHION DESIGNER\n\nURUGUAY',
                            style: TextStyle(fontSize: 9, letterSpacing: 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  if (v == 1 || v == 3)
                    Container(
                      height: 270,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: dark
                              ? [Colors.grey.shade300, BrightColors.ink]
                              : [const Color(0xfff3e8ef), Colors.white],
                        ),
                      ),
                    ),
                  if (v == 0)
                    const Padding(
                      padding: EdgeInsets.only(top: 18, bottom: 22),
                      child: CircleAvatar(
                        radius: 82,
                        backgroundImage: AssetImage(
                          'assets/images/avatar_anna.webp',
                        ),
                      ),
                    ),
                  if (v == 4)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 24),
                      child: DemoPhoto(
                        'avatar_redhead',
                        height: 120,
                        width: 120,
                        radius: 5,
                      ),
                    ),
                  Text(
                    dark ? 'Maude Moody' : 'Anna Rakita',
                    style: heading(
                      dark ? 34 : 25,
                      color: dark ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    v == 0 ? '◉ Ireland' : 'FASHION DESIGNER\n\nURUGUAY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: v == 0 ? 13 : 9,
                      letterSpacing: v == 0 ? 0 : 2,
                      color: dark ? Colors.white70 : BrightColors.muted,
                    ),
                  ),
                  if (v == 0)
                    const Padding(
                      padding: EdgeInsets.all(22),
                      child: Text(
                        'The prints continue to confound with the occasional Half Full Dress that looks like a formal ball dress.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: BrightColors.muted),
                      ),
                    ),
                ],
              ),
            if (v != 1) StatsRow(dark: dark),
            Center(
              child: OutlinedButton(
                onPressed: () => setState(() => followed = !followed),
                child: Text(
                  followed ? 'Following' : 'Follow designer',
                  style: TextStyle(
                    color: dark ? Colors.white : BrightColors.pink,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 18),
              child: SectionHeading(
                dark
                    ? 'Recent Upload'
                    : v == 2
                    ? 'Portfolio'
                    : 'Photos',
                color: dark ? Colors.white : null,
                trailing: TextButton(
                  onPressed: () =>
                      toast(context, 'All portfolio photos are shown below.'),
                  child: const Text('See all', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: v == 0 || v == 1 ? 3 : 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: v == 2 ? 0.9 : 0.8,
                children: List.generate(
                  6,
                  (i) => GestureDetector(
                    onTap: () => showDialog<void>(
                      context: context,
                      builder: (c) => Dialog(
                        child: DemoPhoto(
                          _profilePhotos(v)[i % _profilePhotos(v).length],
                          height: 430,
                        ),
                      ),
                    ),
                    child: DemoPhoto(
                      _profilePhotos(v)[i % _profilePhotos(v).length],
                      radius: 6,
                    ),
                  ),
                ),
              ),
            ),
            if (v == 2) ...[
              const Padding(
                padding: EdgeInsets.all(20),
                child: SectionHeading('Client'),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DemoAvatar(0, radius: 38),
                  DemoAvatar(2, radius: 38),
                  DemoAvatar(4, radius: 38),
                ],
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<String> _profilePhotos(int v) => v == 2 || v == 3
      ? ['portfolio_clothes', 'portfolio_fabric']
      : [
          'photo_one',
          'photo_two',
          'photo_three',
          'avatar_designer',
          'magazine_one',
          'onboard_red',
        ];
}

class MenuDemo extends StatelessWidget {
  const MenuDemo(this.variant, {super.key});
  final int variant;
  @override
  Widget build(BuildContext context) {
    final white = variant != 0;
    final ink = white ? Colors.white : BrightColors.ink;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: variant == 0
              ? const Color(0xfff0f2f5)
              : variant == 1
              ? BrightColors.pink
              : variant == 2
              ? BrightColors.ink
              : null,
          gradient: variant >= 3
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: variant == 3
                      ? [const Color(0xff8135ff), BrightColors.pink]
                      : [const Color(0xffff73a1), const Color(0xff6644b8)],
                )
              : null,
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 10, 20),
                  children: [
                    if (variant == 2 || variant == 4)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            const DemoAvatar(0, radius: 30),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Randall Mason\nPort Dixie',
                                style: TextStyle(color: ink, height: 1.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 22),
                        child: Row(
                          children: [
                            Text('Menu', style: heading(28, color: ink)),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Close menu',
                              onPressed: () => Navigator.maybePop(context),
                              icon: Icon(CupertinoIcons.xmark, color: ink),
                            ),
                          ],
                        ),
                      ),
                    ...List.generate(
                      11,
                      (i) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        minVerticalPadding: 14,
                        leading: Icon(
                          [
                            CupertinoIcons.house,
                            CupertinoIcons.square_grid_2x2,
                            CupertinoIcons.rectangle_stack,
                            CupertinoIcons.bag,
                            CupertinoIcons.heart,
                            CupertinoIcons.chart_bar,
                            CupertinoIcons.gear,
                            CupertinoIcons.tag,
                            CupertinoIcons.bell,
                            CupertinoIcons.info,
                            CupertinoIcons.square_arrow_right,
                          ][i],
                          color: ink,
                          size: 22,
                        ),
                        title: Text(
                          [
                            'HOME',
                            'AFFILIATE CENTER',
                            'PRODUCTS',
                            'MY BAG',
                            'WISHLISTS',
                            'SALES',
                            'ACCOUNT SETTINGS',
                            'COUPON',
                            'NOTIFICATIONS',
                            'HELP',
                            'LOG OUT',
                          ][i],
                          style: TextStyle(fontSize: 14, color: ink),
                        ),
                        onTap: () => _navigate(context, i),
                      ),
                    ),
                  ],
                ),
              ),
              if (variant == 0 || variant == 1 || variant == 4)
                Container(
                  width: 60,
                  height: 610,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .25),
                        blurRadius: 22,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Icon(CupertinoIcons.line_horizontal_3),
                      const SizedBox(height: 40),
                      const Expanded(child: DemoPhoto('shop_women', radius: 0)),
                      const SizedBox(height: 20),
                      const Icon(
                        CupertinoIcons.house,
                        color: BrightColors.pink,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext c, int i) {
    switch (i) {
      case 0:
        go(c, '/gallery');
      case 1:
        openPreview(c, 'dashboard', 2);
      case 2:
        openPreview(c, 'fashion', 0);
      case 3:
        go(c, '/bag');
      case 4:
        go(c, '/wishlist');
      case 5:
        openPreview(c, 'activity', 0);
      case 6:
        go(c, '/settings');
      case 7:
        toast(c, 'Demo coupon BRIGHT10 · No live promotion is applied.');
      case 8:
        go(c, '/notifications');
      case 9:
        go(c, '/legal');
      case 10:
        Navigator.pushNamedAndRemoveUntil(c, '/gallery', (_) => false);
    }
  }
}

class FeedDemo extends StatefulWidget {
  const FeedDemo(this.variant, {super.key});
  final int variant;
  @override
  State<FeedDemo> createState() => _FeedDemoState();
}

class _FeedDemoState extends State<FeedDemo> {
  final likes = <int>{}, saved = <int>{};
  int stories = 0;
  final comments = <String>[];
  @override
  Widget build(BuildContext context) {
    final v = widget.variant;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            DemoTopBar(
              'Feed',
              large: v >= 3,
              onSearch: () => toast(context, 'Showing your local sample feed.'),
            ),
            if (v == 0 || v == 3 || v == 4)
              SizedBox(
                height: v == 0 ? 110 : 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  itemCount: 5 + stories,
                  separatorBuilder: (_, _) => const SizedBox(width: 15),
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => i == 0
                        ? _addStory()
                        : showDialog<void>(
                            context: context,
                            builder: (c) => Dialog(
                              child: DemoPhoto(
                                ['feed_neon', 'feed_arch', 'feed_yellow'][i %
                                    3],
                                height: 480,
                              ),
                            ),
                          ),
                    child: v == 0
                        ? Column(
                            children: [
                              i == 0
                                  ? const CircleAvatar(
                                      radius: 28,
                                      backgroundColor: BrightColors.pink,
                                      child: Icon(
                                        CupertinoIcons.camera,
                                        color: Colors.white,
                                      ),
                                    )
                                  : DemoAvatar(i, radius: 28),
                              const SizedBox(height: 7),
                              Text(
                                i == 0
                                    ? 'Add Story'
                                    : demoPeople[i % 6].split(' ').first,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              DemoPhoto(
                                ['photo_one', 'feed_arch', 'feed_collage'][i %
                                    3],
                                width: 135,
                                height: 180,
                                radius: 22,
                              ),
                              Positioned(
                                left: 14,
                                right: 10,
                                bottom: 15,
                                child: Text(
                                  i == 0 ? '⊕ Add Story' : demoPeople[i % 6],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ...List.generate(
              4,
              (i) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
                child: Column(
                  children: [
                    Row(
                      children: [
                        DemoAvatar(i + 3, radius: 22),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(demoPeople[(i + 3) % 6]),
                              const Text(
                                'Venezuela',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: BrightColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${12 + i * 4} min ago',
                          style: const TextStyle(
                            fontSize: 10,
                            color: BrightColors.muted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onDoubleTap: () => setState(() => likes.add(i)),
                      child: v == 4
                          ? SizedBox(
                              height: 240,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Expanded(
                                          child: DemoPhoto('feed_neon'),
                                        ),
                                        const SizedBox(height: 8),
                                        const Expanded(
                                          child: DemoPhoto('photo_one'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    flex: 2,
                                    child: DemoPhoto(
                                      'feed_collage',
                                      height: 240,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : DemoPhoto(
                              [
                                'feed_neon',
                                'feed_blue',
                                'feed_arch',
                                'feed_yellow',
                              ][v % 4],
                              height: 340,
                              width: double.infinity,
                              radius: 20,
                            ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Like post',
                          onPressed: () => setState(
                            () => likes.contains(i)
                                ? likes.remove(i)
                                : likes.add(i),
                          ),
                          icon: Icon(
                            likes.contains(i)
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: BrightColors.pink,
                            size: 22,
                          ),
                        ),
                        Text(
                          '${2091 + (likes.contains(i) ? 1 : 0)}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          tooltip: 'Comments',
                          onPressed: _comment,
                          icon: const Icon(
                            CupertinoIcons.chat_bubble,
                            size: 20,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Save post',
                          onPressed: () => setState(
                            () => saved.contains(i)
                                ? saved.remove(i)
                                : saved.add(i),
                          ),
                          icon: Icon(
                            saved.contains(i)
                                ? CupertinoIcons.bookmark_fill
                                : CupertinoIcons.bookmark,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addStory() {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Add a demo story'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Story caption'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              setState(() => stories++);
              Navigator.pop(c);
              toast(context, 'Story added locally.');
            },
            child: const Text('Add story'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _comment() {
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (c) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.viewInsetsOf(c).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${comments.length} local comments', style: heading(24)),
            ...comments.map((e) => ListTile(title: Text(e))),
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Write a comment'),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              'POST COMMENT',
              onPressed: () {
                if (controller.text.trim().isEmpty) return;
                setState(() => comments.add(controller.text.trim()));
                Navigator.pop(c);
              },
            ),
          ],
        ),
      ),
    ).then((_) => controller.dispose());
  }
}
