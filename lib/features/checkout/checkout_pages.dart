import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../data/models.dart';
import '../../shared/widgets.dart';

class BagPage extends StatelessWidget {
  const BagPage({super.key, this.embedded = false});
  final bool embedded;
  @override
  Widget build(BuildContext context) {
    final store = ShopScope.of(context);
    final body = store.bag.isEmpty
        ? EmptyState(
            'Your bag is empty',
            'A fresh pair is just a few steps away.',
            action: PrimaryButton(
              'EXPLORE SNEAKERS',
              onPressed: () => go(context, '/collection'),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            itemCount: store.bag.length,
            separatorBuilder: (_, _) => const SizedBox(height: 28),
            itemBuilder: (_, i) {
              final item = store.bag[i], p = productById(item.productId);
              return Row(
                children: [
                  GestureDetector(
                    onTap: () => go(context, '/product', p),
                    child: Container(
                      width: 132,
                      height: 136,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: BrightColors.canvas,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: ShoeImage(item.color),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(fontSize: 11)),
                        const SizedBox(height: 5),
                        Text(
                          'UK ${item.size}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: BrightColors.muted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(money(p.price), style: heading(24)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _QuantityButton(
                              CupertinoIcons.minus,
                              'Decrease quantity',
                              () => store.changeQuantity(item, -1),
                            ),
                            SizedBox(
                              width: 44,
                              child: Text(
                                '${item.quantity}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            _QuantityButton(
                              CupertinoIcons.plus,
                              'Increase quantity',
                              () => store.changeQuantity(item, 1),
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Remove item',
                              onPressed: () {
                                store.changeQuantity(item, -item.quantity);
                              },
                              icon: const Icon(
                                CupertinoIcons.trash,
                                size: 16,
                                color: BrightColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
    final bottom = store.bag.isEmpty
        ? null
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('TOTAL', style: TextStyle(fontSize: 11)),
                  const Spacer(),
                  Text(money(store.subtotal), style: heading(25)),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                'CHECKOUT',
                icon: CupertinoIcons.arrow_right,
                onPressed: () => go(context, '/shipping'),
              ),
            ],
          );
    if (!embedded) {
      return PageFrame(
        title: 'My Bag',
        trailing: Text(
          'Total ${store.count} items',
          style: const TextStyle(fontSize: 12),
        ),
        bottom: bottom,
        child: body,
      );
    }
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Row(
              children: [
                Expanded(child: Text('My Bag', style: heading(34))),
                Text(
                  'Total ${store.count} items',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: body),
          if (bottom != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
              child: bottom,
            ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton(this.icon, this.label, this.action);
  final IconData icon;
  final String label;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 34,
    height: 30,
    child: IconButton(
      padding: EdgeInsets.zero,
      tooltip: label,
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xfff5f5f6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      onPressed: action,
      icon: Icon(icon, size: 18),
    ),
  );
}

class ShippingPage extends StatelessWidget {
  const ShippingPage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = ShopScope.of(context);
    const descriptions = [
      'Your new pair, delivered in 7–10 business days.',
      'Reliable delivery in 3–5 business days. Includes tracking.',
      'Your favorites, faster. Delivery in 1–2 business days.',
    ];
    return PageFrame(
      title: 'Shipping Method',
      bottom: PrimaryButton(
        'CONTINUE TO ADDRESS',
        onPressed: () => go(context, '/address'),
      ),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Choose your shipping method'),
          const SizedBox(height: 24),
          ...List.generate(3, (i) {
            final selected = store.shipping == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Semantics(
                selected: selected,
                button: true,
                child: InkWell(
                  onTap: () => store.chooseShipping(i),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: selected
                          ? BrightColors.ink
                          : const Color(0xfff7f8fb),
                      border: Border.all(
                        color: selected ? BrightColors.ink : BrightColors.line,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                ShopStore.shippingNames[i],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: selected
                                      ? Colors.white
                                      : BrightColors.ink,
                                ),
                              ),
                            ),
                            Text(
                              money(ShopStore.shippingPrices[i]),
                              style: TextStyle(
                                fontSize: 16,
                                color: selected
                                    ? Colors.white
                                    : BrightColors.ink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          descriptions[i],
                          style: TextStyle(
                            fontSize: 13,
                            color: selected
                                ? Colors.white70
                                : BrightColors.muted,
                            height: 1.6,
                          ),
                        ),
                        if (selected)
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(
                              CupertinoIcons.check_mark_circled,
                              color: BrightColors.pink,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});
  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final form = GlobalKey<FormState>();
  final controllers = List.generate(4, (_) => TextEditingController());
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final lines = ShopScope.of(context).address.split('\n');
      for (var i = 0; i < 4; i++) {
        controllers[i].text = lines.length > i ? lines[i] : '';
      }
      initialized = true;
    }
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Shipping Address',
    bottom: PrimaryButton(
      'CONTINUE TO PAYMENT',
      onPressed: () {
        if (!form.currentState!.validate()) return;
        ShopScope.of(context).address = controllers
            .map((c) => c.text.trim())
            .join('\n');
        ShopScope.of(context).save();
        go(context, '/payment');
      },
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CheckoutSteps(step: 1),
            const SizedBox(height: 28),
            ...List.generate(
              4,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: controllers[i],
                  decoration: InputDecoration(
                    labelText: [
                      'Full Name',
                      'Street Address',
                      'City / Postal Code',
                      'Country',
                    ][i],
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (v) => v!.trim().length < 2
                      ? 'Please complete this field'
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const DemoNote(
              'This address is stored on this device for the demo. No shipment will be created.',
            ),
          ],
        ),
      ),
    ),
  );
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, this.manage = false});
  final bool manage;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final form = GlobalKey<FormState>();
  final holder = TextEditingController(text: 'Matthew Stokes');
  final number = TextEditingController(text: '4242 4242 4242 8654');
  final expiry = TextEditingController(text: '12/30');
  @override
  void dispose() {
    holder.dispose();
    number.dispose();
    expiry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Card Details',
    bottom: PrimaryButton(
      widget.manage ? 'SAVE DEMO CARD' : 'REVIEW ORDER',
      onPressed: () {
        if (!form.currentState!.validate()) return;
        final digits = number.text.replaceAll(' ', '');
        final store = ShopScope.of(context);
        store.cardLast4 = digits.substring(digits.length - 4);
        store.save();
        if (widget.manage) {
          Navigator.pop(context);
          toast(context, 'Demo card saved. Only the last 4 digits are stored.');
        } else {
          go(context, '/review');
        }
      },
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 186,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                gradient: const LinearGradient(
                  colors: [Color(0xff4777ff), Color(0xff638fff)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.creditcard,
                        color: Colors.white70,
                        size: 34,
                      ),
                      const Spacer(),
                      Text('VISA', style: heading(24, color: Colors.white)),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    '••••   ••••   ••••   8654',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'MATTHEW STOKES',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Text(
                        'DEMO',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const DemoNote(
              'Demo checkout — no charge is made. Use the sample card shown here. Only the last 4 digits are saved locally.',
            ),
            const SizedBox(height: 22),
            TextFormField(
              controller: holder,
              decoration: const InputDecoration(labelText: 'Card Holder Name'),
              validator: (v) => v!.trim().isEmpty ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: number,
              decoration: const InputDecoration(labelText: 'Demo Card Number'),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  RegExp(r'^\d{16}$').hasMatch(v!.replaceAll(' ', ''))
                  ? null
                  : 'Enter the 16-digit demo number',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: expiry,
              decoration: const InputDecoration(labelText: 'Expiry · MM/YY'),
              keyboardType: TextInputType.datetime,
              validator: (v) {
                final parts = v!.split('/');
                if (parts.length != 2) return 'Use MM/YY';
                final month = int.tryParse(parts[0]),
                    year = int.tryParse(parts[1]);
                final now = DateTime.now();
                if (month == null ||
                    year == null ||
                    month < 1 ||
                    month > 12 ||
                    year < 0 ||
                    year > 99 ||
                    DateTime(2000 + year, month + 1).isBefore(now)) {
                  return 'Enter a future expiry';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

class CheckoutSteps extends StatelessWidget {
  const CheckoutSteps({super.key, required this.step});
  final int step;
  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(
      3,
      (i) => Expanded(
        child: Column(
          children: [
            Container(
              height: 3,
              color: i <= step ? BrightColors.pink : BrightColors.line,
            ),
            const SizedBox(height: 8),
            Text(
              ['Shipping', 'Address', 'Payment'][i],
              style: TextStyle(
                fontSize: 10,
                color: i <= step ? BrightColors.ink : BrightColors.muted,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool placing = false;
  @override
  Widget build(BuildContext context) {
    final store = ShopScope.of(context);
    return PageFrame(
      title: 'Review Order',
      bottom: PrimaryButton(
        'PLACE DEMO ORDER',
        onPressed: placing || store.bag.isEmpty
            ? null
            : () {
                setState(() => placing = true);
                final order = store.placeOrder();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/success',
                  ModalRoute.withName('/home'),
                  arguments: order,
                );
              },
      ),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CheckoutSteps(step: 2),
          const SizedBox(height: 28),
          ...store.bag.map((i) {
            final p = productById(i.productId);
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Row(
                children: [
                  SizedBox(width: 75, height: 70, child: ShoeImage(i.color)),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(fontSize: 11)),
                        Text(
                          'UK ${i.size}  ·  Qty ${i.quantity}',
                          style: const TextStyle(
                            color: BrightColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(money(p.price * i.quantity)),
                ],
              ),
            );
          }),
          const Divider(),
          const SizedBox(height: 22),
          const SectionHeading('Deliver to'),
          const SizedBox(height: 12),
          Text(
            store.address,
            style: const TextStyle(color: BrightColors.muted, height: 1.8),
          ),
          const SizedBox(height: 24),
          const SectionHeading('Payment'),
          const SizedBox(height: 12),
          Text('Visa  •••• ${store.cardLast4}   ·   Demo card'),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          _SummaryRow('Subtotal', money(store.subtotal)),
          _SummaryRow(
            ShopStore.shippingNames[store.shipping],
            money(ShopStore.shippingPrices[store.shipping]),
          ),
          const SizedBox(height: 10),
          _SummaryRow('Total', money(store.total), large: true),
          const SizedBox(height: 20),
          const DemoNote(
            'This creates a local demo order. No payment or shipping service is called.',
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.large = false});
  final String label, value;
  final bool large;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(fontSize: large ? 18 : 12)),
        ),
        Text(value, style: large ? heading(27) : const TextStyle(fontSize: 14)),
      ],
    ),
  );
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: BrightColors.canvas,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.check_mark,
                size: 64,
                color: BrightColors.pink,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Great steps ahead.',
              style: heading(36),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            const Text(
              'Your demo order has been placed.',
              style: TextStyle(color: BrightColors.muted),
            ),
            const SizedBox(height: 28),
            Text(
              order.id,
              style: const TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(money(order.total), style: heading(28)),
            const Spacer(),
            const DemoNote(
              'Saved on this device. No actual purchase was made.',
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              'CONTINUE SHOPPING',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (_) => false,
              ),
            ),
            TextButton(
              onPressed: () => go(context, '/orders'),
              child: const Text('View my orders'),
            ),
          ],
        ),
      ),
    ),
  );
}
