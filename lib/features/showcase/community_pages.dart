import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../shared/widgets.dart';
import 'demo_widgets.dart';

class ChatDemo extends StatefulWidget {
  const ChatDemo(this.variant, {super.key});
  final int variant;
  @override
  State<ChatDemo> createState() => _ChatDemoState();
}

class _ChatDemoState extends State<ChatDemo> {
  final input = TextEditingController();
  final scroll = ScrollController();
  final sent = <String>[];
  int tab = 0;
  bool emoji = false, photos = false;
  @override
  void initState() {
    super.initState();
    if (widget.variant == 2 || widget.variant == 3) {
      input.text = 'How are you today?';
    }
    emoji = widget.variant == 3;
    photos = widget.variant == 4;
  }

  @override
  void dispose() {
    input.dispose();
    scroll.dispose();
    super.dispose();
  }

  void send() {
    if (input.text.trim().isEmpty) return;
    setState(() {
      sent.add(input.text.trim());
      input.clear();
      emoji = false;
      photos = false;
    });
    FocusScope.of(context).unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      widget.variant == 0 ? _list() : _conversation();
  Widget _list() => Scaffold(
    backgroundColor: indigo,
    body: SafeArea(
      child: Column(
        children: [
          DemoTopBar(
            '',
            color: indigo,
            ink: Colors.white,
            onSearch: () => toast(context, 'Local contacts only.'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Row(
              children: List.generate(
                3,
                (i) => Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => tab = i),
                    child: Text(
                      ['Chats', 'Calls', 'People'][i],
                      style: heading(
                        32,
                        color: tab == i ? Colors.white : Colors.white38,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SectionHeading(
                    'Active',
                    trailing: Text(
                      'See all',
                      style: TextStyle(fontSize: 10, color: BrightColors.muted),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      5,
                      (i) => GestureDetector(
                        onTap: () => openPreview(context, 'chat', 1),
                        child: DemoAvatar(i, radius: 26, online: true),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SectionHeading(
                    ['Recent Chat', 'Recent Calls', 'People you know'][tab],
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(
                    7,
                    (i) => Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: DemoAvatar(i, online: i % 2 == 0),
                          title: Text(demoPeople[i % 6]),
                          subtitle: Text(
                            tab == 0
                                ? 'Let’s create something bright.'
                                : tab == 1
                                ? 'Demo call · Yesterday'
                                : 'Available for a conversation',
                            style: const TextStyle(
                              fontSize: 11,
                              color: BrightColors.muted,
                            ),
                          ),
                          trailing: tab == 1
                              ? const Icon(CupertinoIcons.phone, size: 18)
                              : Text(
                                  '${i + 1}:24',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: BrightColors.muted,
                                  ),
                                ),
                          onTap: () => openPreview(context, 'chat', 1),
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
  Widget _conversation() => Scaffold(
    backgroundColor: indigo,
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Back to chats',
                  onPressed: () => openPreview(context, 'chat', 0),
                  icon: const Icon(
                    CupertinoIcons.chevron_left,
                    color: Colors.white,
                  ),
                ),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jeremy Hubbard',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '● Active now',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Demo voice call',
                  onPressed: () => toast(
                    context,
                    'Voice calling is not connected in this UI demo.',
                  ),
                  icon: const Icon(
                    CupertinoIcons.phone_circle_fill,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                IconButton(
                  tooltip: 'Demo video call',
                  onPressed: () => toast(
                    context,
                    'Video calling is not connected in this UI demo.',
                  ),
                  icon: const Icon(
                    CupertinoIcons.video_camera_solid,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: ListView(
                controller: scroll,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                children: [
                  _bubble(
                    'Many have unsuccessfully launched a business venture that is internet based but only a handful.',
                    false,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Friday, 09:20 am',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: BrightColors.muted),
                    ),
                  ),
                  if (widget.variant == 1)
                    _bubble(
                      'Many people sign up for affiliate programs with the hopes of making some serious money.',
                      true,
                    ),
                  _bubble(
                    'The troubling thing is, there are maybe a tenfold or even a hundredfold of stories inconsistent to theirs.',
                    false,
                  ),
                  _bubble(
                    'There are numerous success stories you will hear about businesses making it good on the internet.',
                    true,
                  ),
                  const Text(
                    'Seen 2:30 PM',
                    style: TextStyle(fontSize: 9, color: BrightColors.muted),
                  ),
                  ...sent.map((m) => _bubble(m, true)),
                  if (widget.variant == 2) _bubble('● ● ●', false),
                ],
              ),
            ),
          ),
          Container(
            color: const Color(0xfff8f8fa),
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Emoji',
                      onPressed: () => setState(() {
                        emoji = !emoji;
                        photos = false;
                      }),
                      icon: Icon(
                        CupertinoIcons.smiley,
                        color: emoji ? BrightColors.pink : BrightColors.muted,
                        size: 21,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Demo camera',
                      onPressed: () => toast(
                        context,
                        'Camera is not connected in this UI preview.',
                      ),
                      icon: const Icon(
                        CupertinoIcons.camera_fill,
                        color: BrightColors.muted,
                        size: 21,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Photos',
                      onPressed: () => setState(() {
                        photos = !photos;
                        emoji = false;
                      }),
                      icon: Icon(
                        CupertinoIcons.photo_fill,
                        color: photos ? BrightColors.pink : BrightColors.muted,
                        size: 21,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Demo microphone',
                      onPressed: () =>
                          toast(context, 'Voice recording is not connected.'),
                      icon: const Icon(
                        CupertinoIcons.mic_fill,
                        color: BrightColors.muted,
                        size: 21,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const ValueKey('chat-input'),
                        controller: input,
                        onSubmitted: (_) => send(),
                        decoration: InputDecoration(
                          hintText: 'Write Message',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: BrightColors.line,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('send-message'),
                      tooltip: 'Send message',
                      onPressed: send,
                      icon: const Icon(
                        CupertinoIcons.paperplane_fill,
                        color: BrightColors.pink,
                      ),
                    ),
                  ],
                ),
                if (emoji)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 14,
                      children:
                          [
                                '😀',
                                '😍',
                                '👋',
                                '✨',
                                '❤️',
                                '👍',
                                '🎉',
                                '🙌',
                                '🌞',
                                '👟',
                                '💬',
                                '🌈',
                              ]
                              .map(
                                (e) => GestureDetector(
                                  onTap: () => input.text += e,
                                  child: Text(
                                    e,
                                    style: const TextStyle(fontSize: 27),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                if (photos)
                  SizedBox(
                    height: 174,
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: List.generate(
                        8,
                        (i) => GestureDetector(
                          onTap: () {
                            setState(() {
                              sent.add('📷 Shared a demo photo');
                              photos = false;
                            });
                          },
                          child: DemoPhoto(
                            [
                              'avatar_anna',
                              'feed_arch',
                              'avatar_bill',
                              'photo_one',
                            ][i % 4],
                            radius: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget _bubble(String text, bool mine) => Align(
    alignment: mine ? Alignment.centerLeft : Alignment.centerRight,
    child: Container(
      width: 290,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: mine ? indigo : BrightColors.canvas,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(22),
          topRight: const Radius.circular(22),
          bottomLeft: Radius.circular(mine ? 22 : 0),
          bottomRight: Radius.circular(mine ? 0 : 22),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: mine ? Colors.white : BrightColors.ink,
          fontSize: 14,
          height: 1.5,
        ),
      ),
    ),
  );
}

class ActivityDemo extends StatefulWidget {
  const ActivityDemo(this.variant, {super.key});
  final int variant;
  @override
  State<ActivityDemo> createState() => _ActivityDemoState();
}

class _ActivityDemoState extends State<ActivityDemo> {
  int period = 0;
  final dismissed = <int>{}, accepted = <int>{};
  @override
  Widget build(BuildContext context) {
    final v = widget.variant;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DemoTopBar(
              v == 3
                  ? 'My Activity'
                  : v == 4
                  ? 'Connection Requests'
                  : 'Activity',
              large: v == 0,
            ),
            Expanded(
              child: v == 0
                  ? _stats()
                  : v == 1 || v == 4
                  ? _events(v)
                  : v == 2
                  ? _products()
                  : _collections(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stats() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: _card(),
        child: Column(
          children: [
            DateSelector(
              value: period,
              onChanged: (v) => setState(() => period = v),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 270,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, 270),
                    painter: DonutPainter(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total Sale',
                        style: TextStyle(color: BrightColors.muted),
                      ),
                      Text('\$${4304 + period * 840}.04'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: _card(),
        child: Column(
          children: [
            ...List.generate(
              4,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: [
                        blue,
                        const Color(0xff08cbb0),
                        BrightColors.pink,
                        const Color(0xffff7754),
                      ][i],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        ['NIKE SNEAKERS', 'ADIDAS', 'RADTAPE', 'REEBOK'][i],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      ['\$3,012.01', '\$516.48', '\$430.04', '\$344.32'][i],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            const Row(
              children: [
                Expanded(child: Text('TOTAL')),
                Text('\$4,304.04'),
              ],
            ),
          ],
        ),
      ),
    ],
  );
  BoxDecoration _card() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: .06),
        blurRadius: 15,
        offset: const Offset(0, 5),
      ),
    ],
  );
  Widget _events(int v) => ListView(
    padding: const EdgeInsets.all(16),
    children: List.generate(8, (i) => i)
        .where((i) => !dismissed.contains(i))
        .map(
          (i) => Dismissible(
            key: ValueKey('event-$i'),
            background: Container(
              color: blue,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(20),
              child: const Icon(CupertinoIcons.check_mark, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: BrightColors.pink,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(20),
              child: const Icon(CupertinoIcons.trash, color: Colors.white),
            ),
            onDismissed: (_) => setState(() => dismissed.add(i)),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: DemoAvatar(i, radius: 24),
                  title: Text(
                    v == 4
                        ? '${demoPeople[i % 6]} sent you a connection request.'
                        : '${demoPeople[i % 6]} ${i % 2 == 0 ? 'bought Nike Air Max-270.' : 'updated their profile image.'}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  subtitle: Text(
                    v == 4
                        ? '${12 + i * 3} mutual connections'
                        : '${8 + i * 3} min ago',
                    style: const TextStyle(
                      fontSize: 11,
                      color: BrightColors.muted,
                    ),
                  ),
                ),
                if (v == 4)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => accepted.add(i)),
                        child: Text(
                          accepted.contains(i) ? 'Accepted' : 'Accept',
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => dismissed.add(i)),
                        child: const Text('Reject'),
                      ),
                    ],
                  ),
                const Divider(height: 16),
              ],
            ),
          ),
        )
        .toList(),
  );
  Widget _products() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      SizedBox(
        height: 160,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 2,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (_, i) => Container(
            width: 280,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: i == 0 ? const Color(0xffdfa08e) : const Color(0xff9b83dc),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    i == 0 ? 'ADIDAS\n382 SOLD' : 'NIKE\n849 SOLD',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                ShoeImage(i == 0 ? 'dashboard_shoe' : 'epic_react', width: 130),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 28),
      const SectionHeading('Top Sold Product'),
      const SizedBox(height: 20),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: .8,
        children: [6, 7, 9, 8].map((i) => ProductTile(products[i])).toList(),
      ),
    ],
  );
  Widget _collections() => ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: 4,
    separatorBuilder: (_, _) => const SizedBox(height: 16),
    itemBuilder: (_, i) => GestureDetector(
      onTap: () => openPreview(context, 'fashion', i == 2 ? 15 : 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          DemoPhoto(
            [
              'activity_dress',
              'activity_jeans',
              'activity_shoes',
              'feed_yellow',
            ][i],
            height: 200,
            width: double.infinity,
            radius: 7,
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          Text(
            [
              'Dress Collection',
              'Jeans Collection',
              'Sneakers Collection',
              'New Collection',
            ][i],
            style: heading(27, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

class ArticlesDemo extends StatefulWidget {
  const ArticlesDemo(this.variant, {super.key});
  final int variant;
  @override
  State<ArticlesDemo> createState() => _ArticlesDemoState();
}

class _ArticlesDemoState extends State<ArticlesDemo> {
  final saved = <int>{};
  bool search = false;
  String query = '';
  static const titles = [
    'Look Up In\nThe Sky',
    'The Amazing\nHubble',
    'Put Wings On Your\nDreams',
    'Going Wireless With\nYour Headphones',
  ];
  static const body =
      'Creative work starts with a moment of curiosity. Look closer at the people, colors and places around you. Every small detail can become the beginning of a new story.\n\nThis editorial content is a local UI sample. Explore the layout, save an article, or return to the collection to discover another perspective.';
  @override
  Widget build(BuildContext context) {
    final v = widget.variant;
    return Scaffold(
      body: SafeArea(
        top: v == 0 || v == 2,
        child: v == 0 || v == 2 ? _list(v) : _detail(v),
      ),
    );
  }

  Widget _list(int v) => ListView(
    children: [
      DemoTopBar(
        'Articles',
        large: v == 0,
        onSearch: () => setState(() => search = !search),
      ),
      if (search)
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (s) => setState(() => query = s),
            decoration: const InputDecoration(
              labelText: 'Search articles',
              prefixIcon: Icon(CupertinoIcons.search),
            ),
          ),
        ),
      ...List.generate(4, (i) => i)
          .where((i) => titles[i].toLowerCase().contains(query.toLowerCase()))
          .map(
            (i) => GestureDetector(
              onTap: () => openPreview(context, 'articles', i % 2 == 0 ? 1 : 3),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(v == 0 ? 22 : 7),
                  color: Colors.white,
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
                    Container(
                      height: v == 0 ? 280 : 200,
                      padding: const EdgeInsets.all(16),
                      color: v == 0
                          ? const Color(0xffff898c)
                          : const Color(0xff826666),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              tooltip: 'Bookmark article',
                              onPressed: () => setState(
                                () => saved.contains(i)
                                    ? saved.remove(i)
                                    : saved.add(i),
                              ),
                              icon: Icon(
                                saved.contains(i)
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            titles[i],
                            style: heading(
                              v == 0 ? 32 : 23,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'TONY SINGLETON',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              Text(
                                '13.06.2019',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (v == 0)
                      const Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          'There are many variations of passages, but the majority have an unexpected story to tell.',
                          style: TextStyle(height: 1.9),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
    ],
  );
  Widget _detail(int v) => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: SizedBox(
          height: v == 4 ? 400 : 350,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (v == 3)
                const DemoPhoto('article_body', radius: 0)
              else
                ColoredBox(color: Color(v == 1 ? 0xffde9695 : 0xffe29392)),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        tooltip: 'Back to articles',
                        onPressed: () => openPreview(context, 'articles', 0),
                        icon: const Icon(
                          CupertinoIcons.arrow_left,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Bookmark article',
                        onPressed: () => setState(
                          () => saved.contains(0)
                              ? saved.remove(0)
                              : saved.add(0),
                        ),
                        icon: Icon(
                          saved.contains(0)
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (v == 1)
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pictures In The\nSky Moon',
                        style: heading(34, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'JAYDEN WRIGHT                 13.06.2019',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(v == 4 ? 38 : 0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (v != 1) ...[
                Text(
                  v == 3
                      ? 'How To Use Eye Shadow\nLike The Stars'
                      : 'Is The Herbal Way The\nRight Way',
                  style: heading(26),
                ),
                const SizedBox(height: 16),
              ],
              const Text(
                body,
                style: TextStyle(height: 1.9, color: Color(0xff606268)),
              ),
              const SizedBox(height: 24),
              DemoPhoto(
                v == 1 ? 'article_neon' : 'article_hero',
                height: 250,
                width: double.infinity,
              ),
              const SizedBox(height: 20),
              const Text(
                'A fresh point of view.',
                textAlign: TextAlign.center,
                style: TextStyle(color: BrightColors.muted),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ],
  );
}
