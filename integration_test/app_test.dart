import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bright_app/app.dart';
import 'package:bright_app/core/store.dart';
import 'package:bright_app/data/catalog.dart';
import 'package:bright_app/data/screen_catalog.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('shopping journey and page screenshots on iPhone', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final store = ShopStore(await SharedPreferences.getInstance());
    await tester.pumpWidget(BrightApp(store: store, initialRoute: '/home'));
    await tester.pumpAndSettle();
    const captureIds = String.fromEnvironment('BRIGHT_CAPTURE_IDS');
    if (captureIds.isNotEmpty) {
      for (var i = 0; i < screens.length; i++) {
        if (!captureIds.split(',').contains(screens[i].id)) continue;
        navigatorKey.currentState!.pushNamed('/preview', arguments: screens[i]);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final name = screens[i].name.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_');
        await binding.takeScreenshot(
          'ui_${(i + 1).toString().padLeft(3, '0')}_$name',
        );
        navigatorKey.currentState!.pop();
        await tester.pumpAndSettle();
      }
      return;
    }
    Future<void> shot(String name) async {
      ScaffoldMessenger.of(
        navigatorKey.currentContext!,
      ).removeCurrentSnackBar();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: name);
      await binding.takeScreenshot(name);
    }

    Future<void> route(String name, [Object? args]) async {
      navigatorKey.currentState!.pushNamed(name, arguments: args);
      await tester.pumpAndSettle();
    }

    Future<void> home() async {
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/home', (_) => false);
      await tester.pumpAndSettle();
    }

    await shot('01_discover');
    await route('/');
    await shot('02_splash');
    await route('/onboarding');
    await shot('03_onboarding');
    await route('/login');
    await shot('04_login');
    await tester.tap(find.widgetWithText(FilledButton, 'LOGIN'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'demo@bright.app');
    await tester.enterText(find.byType(TextFormField).at(1), 'demo123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'LOGIN'));
    await tester.tap(find.widgetWithText(FilledButton, 'LOGIN'));
    await tester.pumpAndSettle();
    expect(store.signedIn, isTrue);
    await route('/register');
    await shot('05_register');
    await route('/reset');
    await shot('06_reset_password');
    await home();
    await route('/collection');
    await shot('07_collection');
    await route('/search');
    await shot('08_search');
    await tester.enterText(
      find.byKey(const ValueKey('search-field')),
      'HUSTLE',
    );
    await tester.pumpAndSettle();
    expect(find.text('1 sneakers'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await route('/filter');
    await shot('09_filter');
    await home();
    await route('/product', products[1]);
    await shot('10_product');
    await tester.tap(
      find.widgetWithText(FilledButton, 'ADD TO BAG  ·  \$150.00'),
    );
    await tester.pumpAndSettle();
    expect(store.bag, isEmpty);
    expect(find.text('Select your size first.'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('size-8.5')));
    await tester.tap(find.byKey(const ValueKey('size-8.5')));
    await tester.pumpAndSettle();
    await shot('11_product_size');
    await route('/details', products[1]);
    await shot('12_product_details');
    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    await route('/measure');
    await shot('13_measure');
    await tester.tap(find.widgetWithText(FilledButton, 'TRY DEMO SCAN'));
    await tester.pumpAndSettle();
    await shot('14_scan');
    await tester.tap(find.widgetWithText(FilledButton, 'VIEW DEMO RESULT'));
    await tester.pumpAndSettle();
    await shot('15_size_result');
    await tester.tap(find.widgetWithText(FilledButton, 'USE UK 8.5'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('size-8.5')), findsOneWidget);
    await home();
    await route('/video');
    await shot('16_media_preview');
    await home();
    await route('/product', products[1]);
    await tester.ensureVisible(find.byKey(const ValueKey('size-8')));
    await tester.tap(find.byKey(const ValueKey('size-8')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(FilledButton, 'ADD TO BAG  ·  \$150.00'),
    );
    await tester.pumpAndSettle();
    expect(store.count, 1);
    await shot('17_added_to_bag');
    await tester.tap(find.widgetWithText(FilledButton, 'VIEW MY BAG'));
    await tester.pumpAndSettle();
    store.add(products[4]);
    store.add(products[5]);
    await tester.pumpAndSettle();
    await shot('18_bag');
    await tester.tap(find.byTooltip('Increase quantity').first);
    await tester.pumpAndSettle();
    expect(store.count, 4);
    await tester.tap(find.byTooltip('Decrease quantity').first);
    await tester.pumpAndSettle();
    expect(store.count, 3);
    await tester.tap(find.widgetWithText(FilledButton, 'CHECKOUT'));
    await tester.pumpAndSettle();
    await shot('19_shipping');
    await tester.tap(find.text('Free Shipping'));
    await tester.pumpAndSettle();
    expect(store.shipping, 0);
    await tester.tap(find.text('Standard Shipping'));
    await tester.pumpAndSettle();
    expect(store.shipping, 1);
    await tester.tap(find.widgetWithText(FilledButton, 'CONTINUE TO ADDRESS'));
    await tester.pumpAndSettle();
    await shot('20_address');
    await tester.tap(find.widgetWithText(FilledButton, 'CONTINUE TO PAYMENT'));
    await tester.pumpAndSettle();
    await shot('21_payment');
    await tester.tap(find.widgetWithText(FilledButton, 'REVIEW ORDER'));
    await tester.pumpAndSettle();
    await shot('22_review');
    final expectedTotal = store.total;
    await tester.tap(find.widgetWithText(FilledButton, 'PLACE DEMO ORDER'));
    await tester.pumpAndSettle();
    expect(store.orders.single.total, expectedTotal);
    expect(store.bag, isEmpty);
    await shot('23_order_success');
    await tester.tap(find.text('View my orders'));
    await tester.pumpAndSettle();
    await shot('24_orders');
    await home();
    await tester.tap(find.byKey(const ValueKey('tab-1')));
    await tester.pumpAndSettle();
    await shot('25_wishlist');
    await tester.tap(find.byKey(const ValueKey('tab-4')));
    await tester.pumpAndSettle();
    await shot('26_profile');
    await route('/notifications');
    await shot('27_notifications');
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    await shot('28_notifications_empty');
    await route('/settings');
    await shot('29_settings');
    await route('/legal');
    await shot('30_about');
    await home();
    await route('/bag');
    await shot('31_bag_empty');
    await home();
    await store.save();

    // Check representative social interactions before photographing every frame.
    await route(
      '/preview',
      screens.firstWhere((s) => s.kind == 'chat' && s.variant == 1),
    );
    await tester.enterText(
      find.byKey(const ValueKey('chat-input')),
      'Hello from Bright',
    );
    await tester.tap(find.byKey(const ValueKey('send-message')));
    await tester.pumpAndSettle();
    expect(find.text('Hello from Bright'), findsOneWidget);
    await home();
    await route(
      '/preview',
      screens.firstWhere((s) => s.kind == 'activity' && s.variant == 4),
    );
    await tester.tap(find.text('Accept').first);
    await tester.pumpAndSettle();
    expect(find.text('Accepted'), findsOneWidget);
    await home();
    await route('/product', productById('dress4'));
    await tester.tap(find.widgetWithText(FilledButton, 'ADD TO BAG'));
    await tester.pumpAndSettle();
    expect(store.bag.single.productId, 'dress4');
    await home();
    store.bag.clear();
    store.add(products[4]);
    store.add(products[5]);
    store.add(products[6]);

    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      '/gallery',
      (_) => false,
    );
    await tester.pumpAndSettle();
    await shot('00_gallery');
    for (var category = 0; category < 12; category++) {
      await route('/module', category);
      await shot('module_${(category + 1).toString().padLeft(2, '0')}');
      navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();
    }
    for (var i = 0; i < screens.length; i++) {
      final screen = screens[i];
      await route('/preview', screen);
      await shot(
        'ui_${(i + 1).toString().padLeft(3, '0')}_${screen.name.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_')}',
      );
      navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();
      if ((i + 1) % 10 == 0) {
        debugPrint('Gallery screenshots: ${i + 1}/${screens.length}');
      }
    }
    await store.save();
  });
}
