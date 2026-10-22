import 'package:flutter/material.dart';
import '../../data/catalog.dart';
import '../../data/screen_catalog.dart';
import '../../shared/widgets.dart';
import '../account/account_pages.dart';
import '../catalog/catalog_pages.dart';
import '../catalog/product_page.dart';
import '../checkout/checkout_pages.dart';
import 'auth_previews.dart';
import 'community_pages.dart';
import 'fashion_pages.dart';
import 'social_pages.dart';

String screenDescription(ScreenSpec s) => switch (s.kind) {
  'splash' => 'Brand introduction · Tap to continue',
  'onboarding' => 'Welcome layout and first-run navigation',
  'login' =>
    'Sign-in form · ${s.variant.isOdd ? 'Filled input state' : 'Empty input state'}',
  'register' =>
    s.variant < 4
        ? 'Account form · ${s.variant.isOdd ? 'Filled state' : 'Empty state'}'
        : s.variant < 6
        ? 'Phone number · Local demonstration'
        : s.variant < 8
        ? 'SMS code · Demo code 5274'
        : 'Password reset · Local demonstration',
  'sneakers' => [
    'Discover',
    'Profile',
    'Product detail',
    'Selected size',
    'Product information',
    'Foot measurement instructions',
    'Demo scan',
    'Demo size result',
    'Featured collection',
    'Product grid',
    'Shopping bag',
    'Shipping method',
    'Payment card',
    'Media preview',
    'Filter',
    'Wishlist',
    'Notifications',
    'Empty notifications',
  ][s.variant],
  'fashion' => [
    'Shop collections · Full page',
    'Shop with bottom navigation',
    'Categories · Collapsed',
    'Categories · Expanded',
    'Dress collection',
    'Search · Recent history',
    'Search · Suggestions',
    'Barcode scanner · Demo',
    'Store locator · Map',
    'Store locator · Search',
    'Store locator · Map results',
    'Store locator · List',
    'Dress detail · Color block',
    'Dress detail · Photo',
    'Wishlist',
    'Discover products',
    'Magazine · Cards',
    'Magazine · Editorial',
  ][s.variant],
  'dashboard' => [
    'Product earnings',
    'Product sales',
    'Overview cards',
    'Timeline & transactions',
    'Balance bars',
  ][s.variant],
  'profile' => [
    'Portrait & photo grid',
    'Minimal cover profile',
    'Designer portfolio',
    'Dark profile & uploads',
    'Portrait & photo gallery',
  ][s.variant],
  'menu' => 'Navigation drawer · Style ${s.variant + 1}',
  'feed' => [
    'Circular stories',
    'Photo feed & reactions',
    'Travel feed',
    'Story cards',
    'Collage posts',
  ][s.variant],
  'chat' => [
    'Chats / Calls / People',
    'Conversation',
    'Conversation · Draft',
    'Emoji composer',
    'Photo composer',
  ][s.variant],
  'activity' => [
    'Sales distribution',
    'Swipe activity list',
    'Top selling products',
    'Collection cards',
    'Connection requests',
  ][s.variant],
  'articles' => [
    'Editorial cards',
    'Article detail · Pink cover',
    'Compact article cards',
    'Article detail · Photo cover',
    'Article detail · Rounded sheet',
  ][s.variant],
  _ => 'Interactive Flutter screen',
};
Widget buildPreview(ScreenSpec s) => switch (s.kind) {
  'splash' => SplashDemo(s.variant),
  'onboarding' => OnboardingDemo(s.variant),
  'login' => AuthPreview(register: false, variant: s.variant),
  'register' => AuthPreview(register: true, variant: s.variant),
  'sneakers' => _sneakers(s.variant),
  'fashion' => FashionDemo(s.variant),
  'dashboard' => DashboardDemo(s.variant),
  'profile' => ProfileDemo(s.variant),
  'menu' => MenuDemo(s.variant),
  'feed' => FeedDemo(s.variant),
  'chat' => ChatDemo(s.variant),
  'activity' => ActivityDemo(s.variant),
  'articles' => ArticlesDemo(s.variant),
  _ => const SizedBox.shrink(),
};
Widget _sneakers(int v) => switch (v) {
  0 => const HomeShell(),
  1 => const ProfilePage(),
  2 => ProductPage(product: products[1]),
  3 => ProductPage(product: products[1], initialSize: '8'),
  4 => ProductDetailsPage(product: products[1]),
  5 => const MeasurePage(),
  6 => const ScanPage(),
  7 => const SizeResultPage(),
  8 => const CollectionPage(),
  9 => PageFrame(
    title: 'Nike',
    child: GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: .8,
      children: [
        6,
        7,
        5,
        8,
        9,
        10,
      ].map((i) => ProductTile(products[i])).toList(),
    ),
  ),
  10 => const BagPage(),
  11 => const ShippingPage(),
  12 => const PaymentPage(),
  13 => const VideoPage(),
  14 => const FilterPage(),
  15 => const WishlistPage(),
  16 => const NotificationsPage(),
  _ => const NotificationsPage(initiallyEmpty: true),
};
