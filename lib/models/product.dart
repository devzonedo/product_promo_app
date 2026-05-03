class Product {
  final int id;
  final String barcode;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      barcode: json['barcode'] ?? '',
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'barcode': barcode, 'name': name, 'price': price};
  }
}
