import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/screen_catalog.dart';
import '../../shared/widgets.dart';

const indigo = Color(0xff4d49a5);
const blue = Color(0xff477bff);
const demoPeople = [
  'Jeremy Hubbard',
  'Anna Rakita',
  'Randall Mason',
  'Rosa Terry',
  'Charlie Wolfe',
  'Scott Silva',
];
const demoAvatars = [
  'avatar_elina',
  'avatar_anna',
  'avatar_john',
  'avatar_rosa',
  'avatar_bill',
  'avatar_redhead',
];
void openPreview(BuildContext context, String kind, int variant) => go(
  context,
  '/preview',
  screens.firstWhere((s) => s.kind == kind && s.variant == variant),
);

class DemoAvatar extends StatelessWidget {
  const DemoAvatar(
    this.index, {
    super.key,
    this.radius = 25,
    this.online = false,
  });
  final int index;
  final double radius;
  final bool online;
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      CircleAvatar(
        radius: radius,
        backgroundColor: BrightColors.canvas,
        backgroundImage: AssetImage(
          'assets/images/${demoAvatars[index % demoAvatars.length]}.webp',
        ),
      ),
      if (online)
        Positioned(
          right: 0,
          top: 1,
          child: Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
    ],
  );
}

class DemoPhoto extends StatelessWidget {
  const DemoPhoto(
    this.asset, {
    super.key,
    this.height,
    this.width,
    this.radius = 12,
    this.fit = BoxFit.cover,
  });
  final String asset;
  final double? height, width;
  final double radius;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: ShoeImage(asset, height: height, width: width, fit: fit),
  );
}

class DemoTopBar extends StatelessWidget {
  const DemoTopBar(
    this.title, {
    super.key,
    this.large = false,
    this.color = Colors.white,
    this.ink = BrightColors.ink,
    this.onSearch,
  });
  final String title;
  final bool large;
  final Color color, ink;
  final VoidCallback? onSearch;
  @override
  Widget build(BuildContext context) => Container(
    color: color,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Module directory',
              onPressed: () => Navigator.maybePop(context),
              icon: Icon(CupertinoIcons.arrow_left, color: ink, size: 23),
            ),
            if (!large)
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: heading(22, color: ink),
                ),
              )
            else
              const Spacer(),
            IconButton(
              tooltip: 'Search or filter',
              onPressed:
                  onSearch ??
                  () => toast(context, 'Showing local demonstration data.'),
              icon: Icon(
                CupertinoIcons.slider_horizontal_3,
                color: ink,
                size: 20,
              ),
            ),
          ],
        ),
        if (large)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: Text(title, style: heading(35, color: ink)),
          ),
      ],
    ),
  );
}

class DateSelector extends StatelessWidget {
  const DateSelector({super.key, required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: List.generate(
      4,
      (i) => ChoiceChip(
        label: Text(
          ['Day', 'Week', 'Month', 'Year'][i],
          style: const TextStyle(fontSize: 12),
        ),
        selected: value == i,
        showCheckmark: false,
        onSelected: (_) => onChanged(i),
        selectedColor: const Color(0xffffedf2),
        side: BorderSide(
          color: value == i ? BrightColors.pink : Colors.transparent,
        ),
      ),
    ),
  );
}

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, this.dark = false});
  final bool dark;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 22),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        3,
        (i) => Column(
          children: [
            Text(
              ['234K', '126K', '86K'][i],
              style: TextStyle(
                fontSize: 17,
                color: dark ? Colors.white : BrightColors.ink,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              ['FOLLOWERS', 'FOLLOWING', 'FAVOURITES'][i],
              style: TextStyle(
                fontSize: 9,
                color: dark ? Colors.white70 : BrightColors.muted,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    this.color = blue,
    this.height = 210,
    this.selected = 3,
    this.onTap,
  });
  final Color color;
  final double height;
  final int selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: DemoChartPainter(color, selected)),
    ),
  );
}

class DemoChartPainter extends CustomPainter {
  DemoChartPainter(this.color, this.selected);
  final Color color;
  final int selected;
  @override
  void paint(Canvas c, Size s) {
    final points = [.74, .57, .68, .62, .31, .77, .55];
    for (int i = 1; i < 5; i++) {
      final y = s.height * i / 5;
      c.drawLine(
        Offset(0, y),
        Offset(s.width, y),
        Paint()
          ..color = BrightColors.line
          ..strokeWidth = 1,
      );
    }
    final p = Path()..moveTo(0, s.height * points[0]);
    for (int i = 1; i < points.length; i++) {
      final x = s.width * i / (points.length - 1);
      p.lineTo(x, s.height * points[i]);
    }
    final fill = Path.from(p)
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    c.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: .35), color.withValues(alpha: .02)],
        ).createShader(Offset.zero & s),
    );
    c.drawPath(
      p,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    for (int i = 0; i < points.length; i++) {
      final o = Offset(s.width * i / (points.length - 1), s.height * points[i]);
      c.drawCircle(o, i == selected ? 5 : 3, Paint()..color = color);
      c.drawCircle(
        o,
        i == selected ? 5 : 3,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(DemoChartPainter old) =>
      old.color != color || old.selected != selected;
}

class DonutPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final rect = Rect.fromCenter(
      center: Offset(s.width / 2, s.height / 2),
      width: 200,
      height: 200,
    );
    double start = -math.pi / 2;
    for (final e in [
      (blue, .70),
      (const Color(0xff08cbb0), .12),
      (BrightColors.pink, .10),
      (const Color(0xffff7754), .08),
    ]) {
      c.drawArc(
        rect,
        start,
        math.pi * 2 * e.$2,
        false,
        Paint()
          ..color = e.$1
          ..style = PaintingStyle.stroke
          ..strokeWidth = 45,
      );
      start += math.pi * 2 * e.$2;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
