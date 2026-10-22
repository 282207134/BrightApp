import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bright_app/core/store.dart';
import 'package:bright_app/core/theme.dart';
import 'package:bright_app/data/screen_catalog.dart';
import 'package:bright_app/features/showcase/gallery.dart';
import 'package:bright_app/shared/widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await (FontLoader('Lato')
          ..addFont(rootBundle.load('assets/fonts/Lato-Regular.ttf'))
          ..addFont(rootBundle.load('assets/fonts/Lato-Bold.ttf')))
        .load();
    await (FontLoader(
      'Josefin Sans',
    )..addFont(rootBundle.load('assets/fonts/JosefinSans.ttf'))).load();
  });
  test('Pixso manifest registers all 97 unique frames in 12 modules', () {
    expect(screens.length, 97);
    expect(screens.map((s) => s.id).toSet().length, 97);
    expect(screens.map((s) => s.category).toSet().length, 12);
    expect(screens.where((s) => s.kind == 'sneakers').length, 18);
    expect(screens.where((s) => s.kind == 'fashion').length, 18);
  });
  for (final screen in screens) {
    testWidgets('${screen.name} renders without layout errors', (tester) async {
      tester.view.physicalSize = const Size(1206, 2622);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      final store = ShopStore(await SharedPreferences.getInstance());
      await tester.pumpWidget(
        ShopScope(
          store: store,
          child: MaterialApp(
            theme: brightTheme(),
            home: PreviewPage(screen: screen),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: screen.name);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  }
}
