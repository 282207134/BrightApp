import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/store.dart';
import '../core/theme.dart';
import '../data/models.dart';

class ShopScope extends InheritedNotifier<ShopStore> {
  const ShopScope({super.key, required ShopStore store, required super.child})
    : super(notifier: store);
  static ShopStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShopScope>()!.notifier!;
}

void go(BuildContext context, String route, [Object? args]) =>
    Navigator.of(context).pushNamed(route, arguments: args);
void toast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onPressed,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        if (icon != null) ...[const SizedBox(width: 14), Icon(icon, size: 18)],
      ],
    ),
  );
}

class RoundIcon extends StatelessWidget {
  const RoundIcon(
    this.icon, {
    super.key,
    required this.onPressed,
    required this.label,
    this.color,
    this.background,
  });
  final IconData icon;
  final VoidCallback onPressed;
  final String label;
  final Color? color, background;
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: label,
    onPressed: onPressed,
    style: IconButton.styleFrom(
      backgroundColor: background ?? const Color(0xfff5f5f6),
    ),
    icon: Icon(icon, size: 22, color: color ?? BrightColors.ink),
  );
}

class ShoeImage extends StatelessWidget {
  const ShoeImage(
    this.image, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });
  final String image;
  final double? height, width;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$image.webp',
    height: height,
    width: width,
    fit: fit,
    filterQuality: FilterQuality.high,
    errorBuilder: (_, _, _) => const Icon(CupertinoIcons.cube_box, size: 48),
  );
}

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    required this.child,
    this.bottom,
    this.trailing,
  });
  final String title;
  final Widget child;
  final Widget? bottom, trailing;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        tooltip: 'Back',
        icon: const Icon(CupertinoIcons.arrow_left),
        onPressed: () => Navigator.maybePop(context),
      ),
    ),
    body: SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 14),
            child: Row(
              children: [
                Expanded(child: Text(title, style: heading(34))),
                ?trailing,
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: child),
          if (bottom != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 12),
              child: bottom,
            ),
        ],
      ),
    ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.trailing, this.color});
  final String title;
  final Widget? trailing;
  final Color? color;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: heading(23, color: color)),
      ),
      ?trailing,
    ],
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState(
    this.title,
    this.subtitle, {
    super.key,
    this.icon = CupertinoIcons.bag,
    this.action,
  });
  final String title, subtitle;
  final IconData icon;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: BrightColors.canvas,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 52, color: BrightColors.pink),
          ),
          const SizedBox(height: 28),
          Text(title, style: heading(25), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: BrightColors.muted),
          ),
          if (action != null) ...[const SizedBox(height: 28), action!],
        ],
      ),
    ),
  );
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton(this.product, {super.key, this.color});
  final Product product;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final store = ShopScope.of(context),
        selected = ShopScope.of(context).isFavorite(product.id);
    return IconButton(
      tooltip: selected ? 'Remove favorite' : 'Add favorite',
      onPressed: () => store.toggleFavorite(product.id),
      icon: Icon(
        selected ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
        color: selected ? BrightColors.pink : color ?? BrightColors.ink,
        size: 24,
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  const ProductTile(this.product, {super.key});
  final Product product;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(7),
    child: InkWell(
      onTap: () => go(context, '/product', product),
      borderRadius: BorderRadius.circular(7),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 32, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Hero(
                      tag: 'tile-${product.id}',
                      child: ShoeImage(product.image),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 5),
                Text(
                  money(product.price),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Positioned(top: 0, right: 0, child: FavoriteButton(product)),
        ],
      ),
    ),
  );
}

class DemoNote extends StatelessWidget {
  const DemoNote(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: BrightColors.canvas,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(CupertinoIcons.info, size: 16, color: BrightColors.muted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: BrightColors.muted,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}
