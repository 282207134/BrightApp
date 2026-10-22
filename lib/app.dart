import 'package:flutter/material.dart';
import 'core/store.dart';
import 'core/theme.dart';
import 'data/models.dart';
import 'data/screen_catalog.dart';
import 'features/showcase/gallery.dart';
import 'features/showcase/fashion_pages.dart';
import 'features/account/account_pages.dart';
import 'features/auth/auth_pages.dart';
import 'features/catalog/catalog_pages.dart';
import 'features/catalog/product_page.dart';
import 'features/checkout/checkout_pages.dart';
import 'shared/widgets.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class BrightApp extends StatelessWidget {
  const BrightApp({super.key, required this.store, this.initialRoute});
  final ShopStore store;
  final String? initialRoute;
  @override
  Widget build(BuildContext context) => ShopScope(
    store: store,
    child: MaterialApp(
      title: 'Bright UI Gallery',
      debugShowCheckedModeBanner: false,
      theme: brightTheme(),
      navigatorKey: navigatorKey,
      initialRoute: initialRoute ?? '/gallery',
      onGenerateRoute: (settings) {
        final Widget page = switch (settings.name) {
          '/gallery' => const GalleryPage(),
          '/module' => ModulePage(category: settings.arguments as int),
          '/preview' => PreviewPage(screen: settings.arguments as ScreenSpec),
          '/' => const SplashPage(),
          '/onboarding' => const OnboardingPage(),
          '/login' => const AuthPage(),
          '/register' => const AuthPage(register: true),
          '/reset' => const AuthPage(reset: true),
          '/home' => const HomeShell(),
          '/collection' => const CollectionPage(),
          '/search' => const SearchPage(),
          '/filter' => const FilterPage(),
          '/wishlist' => const WishlistPage(),
          '/product' =>
            (settings.arguments as Product).category == 'fashion'
                ? FashionDemo(13, product: settings.arguments as Product)
                : ProductPage(product: settings.arguments as Product),
          '/details' => ProductDetailsPage(
            product: settings.arguments as Product,
          ),
          '/measure' => const MeasurePage(),
          '/scan' => const ScanPage(),
          '/size-result' => const SizeResultPage(),
          '/video' => const VideoPage(),
          '/bag' => const BagPage(),
          '/shipping' => const ShippingPage(),
          '/address' => const AddressPage(),
          '/payment' => const PaymentPage(),
          '/payment-settings' => const PaymentPage(manage: true),
          '/review' => const ReviewPage(),
          '/success' => SuccessPage(order: settings.arguments as Order),
          '/orders' => const OrdersPage(),
          '/notifications' => const NotificationsPage(),
          '/settings' => const SettingsPage(),
          '/legal' => const LegalPage(),
          _ => const HomeShell(),
        };
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => page,
        );
      },
    ),
  );
}
