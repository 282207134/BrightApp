import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../data/models.dart';
import '../../shared/widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = ShopScope.of(context);
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text('Profile', style: heading(22)),
          ),
          SizedBox(
            height: 175,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/profile_cover.webp',
                  fit: BoxFit.cover,
                ),
                const ColoredBox(color: Color(0x770a1720)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(store.name, style: heading(28, color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(
                      store.email,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      store.signedIn ? 'BRIGHT MEMBER' : 'DEMO PROFILE',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _ProfileRow('My Orders', () => go(context, '/orders')),
                _ProfileRow('My Favourites', () => go(context, '/wishlist')),
                _ProfileRow('My Wishlist', () => go(context, '/wishlist')),
                _ProfileRow('Transactions', () => go(context, '/orders')),
                _ProfileRow(
                  'Payment Details',
                  () => go(context, '/payment-settings'),
                ),
                _ProfileRow(
                  'Notifications',
                  () => go(context, '/notifications'),
                ),
                _ProfileRow('Settings', () => go(context, '/settings')),
                _ProfileRow('Legal', () => go(context, '/legal')),
                if (!store.signedIn)
                  _ProfileRow('Sign in', () => go(context, '/login')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow(this.label, this.action);
  final String label;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Text(label, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(
          CupertinoIcons.chevron_right,
          size: 15,
          color: BrightColors.muted,
        ),
        onTap: action,
      ),
      const Divider(height: 1),
    ],
  );
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key, this.initiallyEmpty = false});
  final bool initiallyEmpty;
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late bool cleared = widget.initiallyEmpty;
  @override
  Widget build(BuildContext context) {
    final store = ShopScope.of(context);
    final entries = [
      ('Charlie Wolfe', 'bought Nike Air Max-270.', '8 min ago', 'air_max_red'),
      ('Nike', 'updated the new season collection.', '9 min ago', 'epic_react'),
      ('Jordan', 'just dropped a new colorway.', '12 min ago', 'jordan_laney'),
      ('Lillian', 'saved Nike Air Force.', '24 min ago', 'air_force'),
      (
        'Bright',
        'Your next favorite pair is here.',
        '1 hour ago',
        'air_max_pink',
      ),
    ];
    return PageFrame(
      title: 'Notification',
      trailing: TextButton(
        onPressed: () => setState(() => cleared = !cleared),
        child: Text(cleared ? 'Show demo' : 'Clear'),
      ),
      child: cleared || !store.notifications
          ? const EmptyState(
              'No Notification Here',
              'You’re all caught up. Come back soon.',
              icon: CupertinoIcons.bell,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: entries.length,
              separatorBuilder: (_, _) => const Divider(height: 28),
              itemBuilder: (_, i) {
                final e = entries[i];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: BrightColors.canvas,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ShoeImage(e.$4),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${e.$1} ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: e.$2,
                                  style: const TextStyle(
                                    color: BrightColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            e.$3,
                            style: const TextStyle(
                              fontSize: 12,
                              color: BrightColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = ShopScope.of(context).orders;
    return PageFrame(
      title: 'My Orders',
      child: orders.isEmpty
          ? EmptyState(
              'Your next pair awaits',
              'Completed demo orders will appear here.',
              icon: CupertinoIcons.cube_box,
              action: PrimaryButton(
                'EXPLORE THE COLLECTION',
                onPressed: () => go(context, '/collection'),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 20),
              itemBuilder: (_, i) {
                final order = orders[i];
                final date = DateTime.parse(order.date).toLocal();
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    border: Border.all(color: BrightColors.line),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              order.id,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Text(
                            'DEMO ORDER',
                            style: TextStyle(
                              fontSize: 9,
                              color: BrightColors.pink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: BrightColors.muted,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 65,
                                height: 55,
                                child: ShoeImage(item.color),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  '${productById(item.productId).name}\nUK ${item.size} · Qty ${item.quantity}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Expanded(child: Text('Total')),
                          Text(money(order.total), style: heading(23)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController();
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final store = ShopScope.of(context);
      name.text = store.name;
      email.text = store.email;
      initialized = true;
    }
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ShopScope.of(context);
    return PageFrame(
      title: 'Settings',
      bottom: PrimaryButton(
        'SAVE CHANGES',
        onPressed: () {
          if (!form.currentState!.validate()) return;
          store.name = name.text.trim();
          store.email = email.text.trim();
          store.save();
          toast(context, 'Your profile has been updated.');
        },
      ),
      child: ListView(
        padding: const EdgeInsets.all(28),
        children: [
          Form(
            key: form,
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (v) =>
                      v!.trim().isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v!.trim())
                      ? null
                      : 'Enter a valid email',
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Demo notifications'),
            subtitle: const Text(
              'Show the sample activity feed',
              style: TextStyle(fontSize: 11),
            ),
            value: store.notifications,
            onChanged: (v) {
              store.notifications = v;
              store.save();
            },
          ),
          const Divider(),
          const SizedBox(height: 20),
          const DemoNote(
            'Your profile, favorites, bag and orders are saved locally on this device.',
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              store.signedIn = false;
              store.save();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/onboarding',
                (_) => false,
              );
            },
            child: Text(store.signedIn ? 'Sign out' : 'Back to welcome'),
          ),
        ],
      ),
    );
  }
}

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'About Bright',
    child: ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Text('Bright.', style: heading(54)),
        const SizedBox(height: 6),
        const Text(
          'Sneakers, with a brighter perspective.',
          style: TextStyle(color: BrightColors.muted),
        ),
        const SizedBox(height: 36),
        const SectionHeading('A design brought to life'),
        const SizedBox(height: 16),
        const Text(
          'Built with Flutter from the Bright Design File in Pixso. Product imagery and interface references come from the provided design file. Nike and other brand names belong to their respective owners.',
        ),
        const SizedBox(height: 30),
        const SectionHeading('Your data'),
        const SizedBox(height: 16),
        const Text(
          'This is an offline demonstration. Profile details, favorites, shopping bag, addresses and demo orders are stored on your device. Passwords and full card numbers are never saved. No analytics or external services are connected.',
        ),
        const SizedBox(height: 30),
        const SectionHeading('Demo features'),
        const SizedBox(height: 16),
        const Text(
          'Sign-in, checkout, notifications, price history, media controls and foot scanning demonstrate interface behavior. They do not authenticate with a server, charge a card, send notifications, play a video or measure feet.',
        ),
        const SizedBox(height: 30),
        const Text(
          'Version 1.0.0',
          style: TextStyle(color: BrightColors.muted),
        ),
        TextButton(
          onPressed: () => showLicensePage(
            context: context,
            applicationName: 'Bright',
            applicationVersion: '1.0.0',
          ),
          child: const Text('Open source licenses'),
        ),
      ],
    ),
  );
}
