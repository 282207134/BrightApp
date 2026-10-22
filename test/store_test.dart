import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bright_app/core/store.dart';
import 'package:bright_app/data/catalog.dart';
import 'package:bright_app/data/models.dart';

void main() {
  late ShopStore store;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = ShopStore(await SharedPreferences.getInstance());
  });
  test('merges identical variants but keeps sizes and colors separate', () {
    store.add(products[1], size: '8');
    store.add(products[1], size: '8');
    store.add(products[1], size: '9.5');
    store.add(products[1], size: '8', color: 'air_max_blue');
    expect(store.bag.length, 3);
    expect(store.count, 4);
    expect(store.subtotal, 60000);
  });
  test('uses integer cents and removes a zero quantity line', () {
    store.add(products[5]);
    store.changeQuantity(store.bag.first, 2);
    expect(store.subtotal, 39060);
    store.chooseShipping(2);
    expect(store.total, 40060);
    store.changeQuantity(store.bag.first, -3);
    expect(store.count, 0);
  });
  test('snapshots orders, clears bag and restores local state', () async {
    store.add(products[1], size: '8.5', color: 'air_max_blue');
    store.chooseShipping(1);
    final order = store.placeOrder();
    await store.save();
    expect(order.total, 15520);
    expect(order.items.single.color, 'air_max_blue');
    expect(store.bag, isEmpty);
    final restored = ShopStore(await SharedPreferences.getInstance())
      ..restore();
    expect(restored.orders.single.total, 15520);
    expect(restored.orders.single.items.single.size, '8.5');
    store.add(products[0]);
    expect(order.items.single.productId, 'max');
  });
  test('favorites survive a restart', () async {
    store.toggleFavorite('max');
    await store.save();
    final restored = ShopStore(await SharedPreferences.getInstance())
      ..restore();
    expect(restored.isFavorite('max'), isTrue);
  });
  test('rejects empty orders and caps line quantities', () {
    expect(store.placeOrder, throwsStateError);
    store.add(products[0]);
    store.changeQuantity(store.bag.single, 200);
    expect(store.count, 99);
  });
  test('invalid saved data does not crash startup', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bright.state.v1', '{broken');
    expect(() => (ShopStore(prefs)..restore()), returnsNormally);
  });
  test('formats cents without floating point accumulation', () {
    expect(money(51040), '\$510.40');
    expect(money(0), '\$0.00');
  });
}
