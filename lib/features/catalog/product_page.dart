import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../data/models.dart';
import '../../shared/widgets.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.product, this.initialSize});
  final Product product;
  final String? initialSize;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late String? size = widget.initialSize;
  int color = 0, photo = 0;
  bool usa = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final image = p.id == 'max' ? colorways[color] : p.image;
    return Scaffold(
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 28, 8),
          child: PrimaryButton(
            'ADD TO BAG  ·  ${money(p.price)}',
            icon: CupertinoIcons.bag,
            onPressed: () {
              if (size == null) {
                toast(context, 'Select your size first.');
                return;
              }
              ShopScope.of(context).add(p, size: size!, color: image);
              showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.white,
                builder: (c) => SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          color: BrightColors.pink,
                          size: 44,
                        ),
                        const SizedBox(height: 16),
                        Text('A great choice.', style: heading(28)),
                        const SizedBox(height: 8),
                        Text('${p.name} · UK $size added to your bag.'),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          'VIEW MY BAG',
                          onPressed: () {
                            Navigator.pop(c);
                            go(context, '/bag');
                          },
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: const Text('Keep exploring'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 350,
              child: Stack(
                children: [
                  Positioned(
                    top: -200,
                    left: -24,
                    right: -90,
                    height: 560,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(p.color),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(300),
                          bottomRight: Radius.circular(70),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: 'Back',
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              CupertinoIcons.arrow_left,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              p.brand,
                              textAlign: TextAlign.center,
                              style: heading(22, color: Colors.white),
                            ),
                          ),
                          FavoriteButton(p, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 28,
                    right: 24,
                    top: 116,
                    bottom: 8,
                    child: Transform.flip(
                      flipX: photo == 1,
                      child: ShoeImage(image),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.list(
              children: [
                SizedBox(
                  height: 62,
                  child: Row(
                    children: List.generate(
                      4,
                      (i) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (i == 3) {
                              go(context, '/video');
                            } else {
                              setState(() => photo = i);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: i == 3 ? 0 : 14),
                            decoration: BoxDecoration(
                              color: const Color(0xfff6f6f7),
                              borderRadius: BorderRadius.circular(5),
                              border: Border(
                                bottom: BorderSide(
                                  color: photo == i
                                      ? BrightColors.pink
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Transform.flip(
                                    flipX: i == 1,
                                    child: ShoeImage(image),
                                  ),
                                ),
                                if (i == 3)
                                  const CircleAvatar(
                                    radius: 13,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      CupertinoIcons.play_fill,
                                      size: 14,
                                      color: BrightColors.ink,
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
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        p.name == 'AIR-MAX-270' ? 'Air-Max-270' : p.name,
                        style: heading(24),
                      ),
                    ),
                    Text(money(p.price), style: heading(23)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'The Nike Air Max amps up an icon with a huge Max Air unit for cushioning under every step. It features a stretchy inner sleeve for a snug, sock-like fit.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff77797d),
                    height: 1.65,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: BrightColors.ink,
                    ),
                    onPressed: () => go(context, '/details', p),
                    child: const Text(
                      'MORE DETAILS',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.5,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SectionHeading(
                  'Size',
                  trailing: Row(
                    children: [
                      TextButton(
                        onPressed: () => setState(() => usa = false),
                        child: Text(
                          'UK',
                          style: TextStyle(
                            color: usa ? BrightColors.muted : BrightColors.ink,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => usa = true),
                        child: Text(
                          'USA',
                          style: TextStyle(
                            color: usa ? BrightColors.ink : BrightColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        final suggested = await Navigator.pushNamed(
                          context,
                          '/measure',
                        );
                        if (suggested is String && mounted) {
                          setState(() => size = suggested);
                        }
                      },
                      child: const Text(
                        'Try it  ♧',
                        style: TextStyle(color: BrightColors.ink),
                      ),
                    ),
                    ...['7.5', '8', '8.5', '9.5', '10'].map(
                      (s) => SizedBox(
                        width: 58,
                        height: 48,
                        child: OutlinedButton(
                          key: ValueKey('size-$s'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: size == s
                                ? BrightColors.ink
                                : Colors.white,
                            foregroundColor: size == s
                                ? Colors.white
                                : BrightColors.ink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: const BorderSide(color: BrightColors.line),
                          ),
                          onPressed: () => setState(() => size = s),
                          child: Text(usa ? '${double.parse(s) + 1}' : s),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                const SectionHeading('Color'),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(
                    p.id == 'max' ? colorways.length : 1,
                    (i) => GestureDetector(
                      onTap: () => setState(() => color = i),
                      child: Container(
                        width: 70,
                        height: 58,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xfff6f6f7),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: color == i
                                ? BrightColors.pink
                                : Colors.transparent,
                          ),
                        ),
                        child: ShoeImage(
                          p.id == 'max' ? colorways[i] : p.image,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                const SectionHeading(
                  'Price Trending',
                  trailing: Text(
                    'This week',
                    style: TextStyle(fontSize: 11, color: BrightColors.muted),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Illustrative price history',
                  style: TextStyle(fontSize: 10, color: BrightColors.muted),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 130,
                  child: CustomPaint(painter: _TrendPainter()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']
                      .map(
                        (d) => Text(
                          d,
                          style: const TextStyle(
                            fontSize: 11,
                            color: BrightColors.muted,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * .8)
      ..cubicTo(
        size.width * .12,
        size.height,
        size.width * .15,
        size.height * .5,
        size.width * .32,
        size.height * .65,
      )
      ..cubicTo(
        size.width * .48,
        size.height * .8,
        size.width * .5,
        4,
        size.width * .64,
        size.height * .22,
      )
      ..cubicTo(
        size.width * .8,
        size.height * .38,
        size.width * .87,
        size.height * .72,
        size.width,
        size.height * .85,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = BrightColors.pink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      Offset(size.width * .6, size.height * .2),
      7,
      Paint()..color = BrightColors.pink,
    );
    canvas.drawCircle(
      Offset(size.width * .6, size.height * .2),
      7,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: product.name,
    child: ListView(
      padding: const EdgeInsets.all(28),
      children: const [
        Text(
          'HERITAGE STYLE MEETS MODERN COMFORT.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 22),
        Text(
          'Visible cushioning under every step. Updated for modern comfort, this pair pays homage to the original Air Max with an exaggerated tongue and heritage logo.',
          style: TextStyle(color: BrightColors.muted, height: 1.7),
        ),
        SizedBox(height: 28),
        SectionHeading('Benefits'),
        SizedBox(height: 16),
        Text(
          '01   Large Max Air unit offers responsive cushioning.\n\n02   Engineered textile in the forefoot offers breathability.\n\n03   3-piece midsole offers durability and a smooth transition with every step.',
          style: TextStyle(color: BrightColors.muted, height: 1.7),
        ),
        SizedBox(height: 28),
        SectionHeading('Product details'),
        SizedBox(height: 16),
        Text(
          'Foam midsole\nTextile and synthetic upper\nRubber outsole\nStyle: CJ0520-001',
          style: TextStyle(color: BrightColors.muted, height: 2),
        ),
      ],
    ),
  );
}

class MeasurePage extends StatelessWidget {
  const MeasurePage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Measure Your Foot',
    bottom: PrimaryButton(
      'TRY DEMO SCAN',
      onPressed: () async {
        final suggested = await Navigator.pushNamed(context, '/scan');
        if (suggested is String && context.mounted) {
          Navigator.pop(context, suggested);
        }
      },
    ),
    child: ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const SizedBox(height: 20),
        const SizedBox(
          height: 200,
          child: CustomPaint(painter: _FootPainter()),
        ),
        const SizedBox(height: 30),
        const Text(
          'INSTRUCTIONS',
          style: TextStyle(fontSize: 12, letterSpacing: 1),
        ),
        const SizedBox(height: 20),
        const Text(
          '1. Place both feet flat on a level surface.\n\n2. Keep your heels aligned and leave space around your feet.\n\n3. Follow the guide to choose a comfortable size.',
          style: TextStyle(color: BrightColors.muted, height: 1.7),
        ),
        const SizedBox(height: 28),
        const DemoNote(
          'Visual demo only. No camera access or foot measurement is performed. Always check the brand’s size guide.',
        ),
      ],
    ),
  );
}

class _FootPainter extends CustomPainter {
  const _FootPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = BrightColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (var i = 0; i < 2; i++) {
      canvas.save();
      canvas.translate(size.width * (i == 0 ? .31 : .69), 30);
      if (i == 1) canvas.scale(-1, 1);
      final foot = Path()
        ..moveTo(0, 160)
        ..cubicTo(-14, 145, -32, 94, -32, 62)
        ..cubicTo(-35, 35, 14, 12, 34, 34)
        ..cubicTo(60, 58, 26, 80, 22, 118)
        ..cubicTo(16, 150, 18, 173, 0, 160);
      canvas.drawPath(foot, paint);
      for (var j = 0; j < 5; j++) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(-34 + j * 13, 24 - j * 4),
            width: 9.0 + j,
            height: 15.0 + j * 2,
          ),
          paint,
        );
      }
      canvas.restore();
    }
    canvas.drawLine(
      Offset(size.width * .17, 135),
      Offset(size.width * .83, 135),
      Paint()
        ..color = BrightColors.pink
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..forward();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: BrightColors.ink,
    appBar: AppBar(
      backgroundColor: BrightColors.ink,
      foregroundColor: Colors.white,
      title: const Text('Demo Scan'),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Spacer(),
            const SizedBox(
              height: 200,
              child: ColoredBox(
                color: Colors.white,
                child: CustomPaint(
                  painter: _FootPainter(),
                  child: SizedBox.expand(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            AnimatedBuilder(
              animation: controller,
              builder: (_, _) => Column(
                children: [
                  LinearProgressIndicator(
                    value: controller.value,
                    color: BrightColors.pink,
                    backgroundColor: Colors.white12,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${(controller.value * 100).round()}%  ·  Demo preview',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const DemoNote(
              'Illustrative scan. This is not a real measurement.',
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              'VIEW DEMO RESULT',
              onPressed: () async {
                final suggested = await Navigator.pushNamed(
                  context,
                  '/size-result',
                );
                if (suggested is String && context.mounted) {
                  Navigator.pop(context, suggested);
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class SizeResultPage extends StatelessWidget {
  const SizeResultPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Your fit',
    bottom: PrimaryButton(
      'USE UK 8.5',
      onPressed: () {
        Navigator.pop(context, '8.5');
      },
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const ShoeImage('epic_react', height: 180),
        const SizedBox(height: 30),
        Text('Your demo size is', style: heading(25)),
        const SizedBox(height: 12),
        Text('8.5', style: heading(80)),
        const Text(
          'UK  ·  EU 43  ·  US 9.5',
          style: TextStyle(color: BrightColors.muted),
        ),
        const Padding(
          padding: EdgeInsets.all(28),
          child: DemoNote(
            'Sample result only. This size is not based on a scan of your feet.',
          ),
        ),
      ],
    ),
  );
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool playing = false;
  double value = 5;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: BrightColors.ink,
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/onboarding.webp', fit: BoxFit.cover),
        const ColoredBox(color: Color(0x55000000)),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    RoundIcon(
                      CupertinoIcons.arrow_left,
                      label: 'Back',
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Chip(
                      label: Text(
                        'PRODUCT PREVIEW · DEMO',
                        style: TextStyle(fontSize: 9),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text('Made to move.', style: heading(42, color: Colors.white)),
                const SizedBox(height: 12),
                const Text(
                  'Static product preview · No video source connected',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Slider(
                        value: value,
                        min: 0,
                        max: 169,
                        onChanged: (v) => setState(() => value = v),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '00:${value.round().toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Toggle preview',
                            onPressed: () => setState(() => playing = !playing),
                            icon: Icon(
                              playing
                                  ? CupertinoIcons.pause_fill
                                  : CupertinoIcons.play_fill,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            '02:49',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
