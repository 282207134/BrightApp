class Product {
  const Product(
    this.id,
    this.name,
    this.price,
    this.image, {
    this.brand = 'Nike',
    this.category = 'sneakers',
    this.label = 'NEW',
    this.color = 0xff567ee4,
  });
  final String id, name, image, brand, label, category;
  final int price, color;
}

class BagItem {
  BagItem(this.productId, this.size, this.color, [this.quantity = 1]);
  final String productId, size, color;
  int quantity;
  String get key => '$productId/$size/$color';
  Map<String, dynamic> toJson() => {
    'productId': productId,
    'size': size,
    'color': color,
    'quantity': quantity,
  };
  factory BagItem.fromJson(Map<String, dynamic> j) => BagItem(
    j['productId'] as String,
    j['size'] as String,
    j['color'] as String,
    j['quantity'] as int,
  );
}

class Order {
  const Order(this.id, this.date, this.total, this.items, this.address);
  final String id, date, address;
  final int total;
  final List<BagItem> items;
  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'total': total,
    'address': address,
    'items': items.map((e) => e.toJson()).toList(),
  };
  factory Order.fromJson(Map<String, dynamic> j) => Order(
    j['id'] as String,
    j['date'] as String,
    j['total'] as int,
    (j['items'] as List)
        .map((e) => BagItem.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    j['address'] as String,
  );
}

String money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';
