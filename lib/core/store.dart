import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/catalog.dart';
import '../data/models.dart';

/// Owns local demo state. All amounts are integer cents.
class ShopStore extends ChangeNotifier {
  ShopStore(this._preferences);
  final SharedPreferences _preferences;
  final Set<String> favorites = {'hustle', 'grey', 'kyrie'};
  final List<BagItem> bag = [];
  final List<Order> orders = [];
  String name = 'Duane Carlson', email = 'kira.sporer@hotmail.com';
  String address =
      'Duane Carlson\n221B Baker Street\nLondon, NW1 6XE\nUnited Kingdom';
  bool signedIn = false, notifications = true;
  int shipping = 1;
  String cardLast4 = '8654';
  static const shippingNames = [
    'Free Shipping',
    'Standard Shipping',
    'Premium Shipping',
  ];
  static const shippingPrices = [0, 520, 1000];
  int get subtotal => bag.fold(
    0,
    (n, item) => n + productById(item.productId).price * item.quantity,
  );
  int get total => subtotal + shippingPrices[shipping];
  int get count => bag.fold(0, (n, item) => n + item.quantity);
  bool isFavorite(String id) => favorites.contains(id);

  void restore() {
    final raw = _preferences.getString('bright.state.v1');
    if (raw == null) return;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      favorites
        ..clear()
        ..addAll(
          (j['favorites'] as List).cast<String>().where(
            (id) => products.any((p) => p.id == id),
          ),
        );
      bag.addAll(
        (j['bag'] as List)
            .map((e) => BagItem.fromJson(Map<String, dynamic>.from(e)))
            .where(
              (i) =>
                  products.any((p) => p.id == i.productId) &&
                  i.quantity > 0 &&
                  i.quantity <= 99,
            ),
      );
      orders.addAll(
        (j['orders'] as List).map(
          (e) => Order.fromJson(Map<String, dynamic>.from(e)),
        ),
      );
      name = j['name'] as String;
      email = j['email'] as String;
      address = j['address'] as String;
      signedIn = j['signedIn'] == true;
      notifications = j['notifications'] != false;
      cardLast4 = j['cardLast4'] as String;
    } catch (_) {
      bag.clear();
      orders.clear();
      // Invalid local demo data is discarded; the catalog remains usable.
    }
  }

  Future<void> save() async {
    notifyListeners();
    await _preferences.setString(
      'bright.state.v1',
      jsonEncode({
        'favorites': favorites.toList(),
        'bag': bag.map((e) => e.toJson()).toList(),
        'orders': orders.map((e) => e.toJson()).toList(),
        'name': name,
        'email': email,
        'address': address,
        'signedIn': signedIn,
        'notifications': notifications,
        'cardLast4': cardLast4,
      }),
    );
  }

  void toggleFavorite(String id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    save();
  }

  void add(Product p, {String size = '8', String? color}) {
    final item = BagItem(p.id, size, color ?? p.image);
    final existing = bag.where((i) => i.key == item.key).firstOrNull;
    if (existing == null) {
      bag.add(item);
    } else if (existing.quantity < 99) {
      existing.quantity++;
    }
    save();
  }

  void changeQuantity(BagItem item, int delta) {
    item.quantity = (item.quantity + delta).clamp(0, 99);
    if (item.quantity == 0) bag.remove(item);
    save();
  }

  void chooseShipping(int value) {
    shipping = value;
    notifyListeners();
  }

  Order placeOrder() {
    if (bag.isEmpty) throw StateError('Your bag is empty.');
    final now = DateTime.now();
    final order = Order(
      'BR-${now.millisecondsSinceEpoch.toString().substring(5)}',
      now.toIso8601String(),
      total,
      bag
          .map((i) => BagItem(i.productId, i.size, i.color, i.quantity))
          .toList(),
      address,
    );
    orders.insert(0, order);
    bag.clear();
    save();
    return order;
  }
}
