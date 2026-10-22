import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/screen_catalog.dart';
import '../../shared/widgets.dart';
import 'preview.dart';

const moduleSubtitles = [
  'Five ways to say hello',
  'First impressions that last',
  'Welcome back, beautifully',
  'Make yourself at home',
  'Fashion & sneakers',
  'A clearer view of your data',
  'People, stories & portfolios',
  'Find your way around',
  'A little inspiration, daily',
  'Keep the conversation going',
  'Every interaction matters',
  'Stories worth your time',
];
const moduleImages = [
  'splash_city',
  'onboard_fashion',
  'splash_suit',
  'avatar_anna',
  'epic_react',
  'dashboard_shoe',
  'avatar_designer',
  'splash_fashion',
  'feed_collage',
  'avatar_elina',
  'activity_shoes',
  'article_neon',
];
const moduleIcons = [
  CupertinoIcons.sparkles,
  CupertinoIcons.rectangle_stack,
  CupertinoIcons.lock,
  CupertinoIcons.person_add,
  CupertinoIcons.bag,
  CupertinoIcons.chart_bar,
  CupertinoIcons.person_crop_circle,
  CupertinoIcons.line_horizontal_3,
  CupertinoIcons.square_stack,
  CupertinoIcons.chat_bubble_2,
  CupertinoIcons.bolt,
  CupertinoIcons.doc_text,
];

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xfff5f5f9),
    body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Bright.', style: heading(36)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'FLUTTER UI COLLECTION',
                          style: TextStyle(fontSize: 8, letterSpacing: 1.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text('One kit.\nEndless possibilities.', style: heading(38)),
                  const SizedBox(height: 14),
                  const Text(
                    'Explore 12 modules and 97 screens, brought to life from Pixso.',
                    style: TextStyle(fontSize: 13, color: BrightColors.muted),
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    'OPEN SNEAKERS APP',
                    icon: CupertinoIcons.arrow_right,
                    onPressed: () => go(context, '/home'),
                  ),
                  const SizedBox(height: 28),
                  const SectionHeading('Explore the collection'),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: .82,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ModuleCard(i),
                childCount: 12,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Text(
                'Local UI demonstrations · No external services connected',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: BrightColors.muted),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard(this.index);
  final int index;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      key: ValueKey('module-$index'),
      borderRadius: BorderRadius.circular(14),
      onTap: () => go(context, '/module', index),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ShoeImage(
                        moduleImages[index],
                        fit: index == 4 || index == 5 || index == 10
                            ? BoxFit.contain
                            : BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(
                        moduleIcons[index],
                        size: 15,
                        color: BrightColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(moduleNames[index], style: heading(18)),
            const SizedBox(height: 5),
            Text(
              '${screens.where((s) => s.category == index).length} screens',
              style: const TextStyle(fontSize: 10, color: BrightColors.muted),
            ),
          ],
        ),
      ),
    ),
  );
}

class ModulePage extends StatelessWidget {
  const ModulePage({super.key, required this.category});
  final int category;
  @override
  Widget build(BuildContext context) {
    final entries = screens.where((s) => s.category == category).toList();
    return Scaffold(
      appBar: AppBar(title: Text(moduleNames[category], style: heading(22))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(moduleSubtitles[category], style: heading(30)),
          const SizedBox(height: 10),
          Text(
            '${entries.length} Pixso layouts · Interactive Flutter previews',
            style: const TextStyle(color: BrightColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 24),
          ...entries.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: const Color(0xfff6f6f9),
                borderRadius: BorderRadius.circular(10),
                child: ListTile(
                  key: ValueKey('screen-${s.id}'),
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    width: 52,
                    height: 56,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: ShoeImage(moduleImages[category], fit: BoxFit.cover),
                  ),
                  title: Text(s.name, style: heading(18)),
                  subtitle: Text(
                    screenDescription(s),
                    style: const TextStyle(
                      fontSize: 10,
                      color: BrightColors.muted,
                    ),
                  ),
                  trailing: const Icon(CupertinoIcons.arrow_up_right, size: 18),
                  onTap: () => go(context, '/preview', s),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key, required this.screen});
  final ScreenSpec screen;
  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late ScreenSpec current = widget.screen;
  @override
  Widget build(BuildContext context) {
    final siblings = screens
        .where((s) => s.category == current.category)
        .toList();
    final index = siblings.indexOf(current);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        title: Text(
          current.name,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          tooltip: 'Back to module',
          icon: const Icon(CupertinoIcons.square_grid_2x2, size: 19),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Previous screen',
            onPressed: index > 0
                ? () => setState(() => current = siblings[index - 1])
                : null,
            icon: const Icon(CupertinoIcons.chevron_left, size: 16),
          ),
          Center(
            child: Text(
              '${index + 1}/${siblings.length}',
              style: const TextStyle(fontSize: 10, color: BrightColors.muted),
            ),
          ),
          IconButton(
            tooltip: 'Next screen',
            onPressed: index < siblings.length - 1
                ? () => setState(() => current = siblings[index + 1])
                : null,
            icon: const Icon(CupertinoIcons.chevron_right, size: 16),
          ),
        ],
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: KeyedSubtree(
          key: ValueKey(current.id),
          child: buildPreview(current),
        ),
      ),
    );
  }
}
