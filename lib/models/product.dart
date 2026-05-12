class Product {
  final String barcode;
  final String name;
  final double price;
  final String status;

  Product({
    required this.barcode,
    required this.name,
    required this.price,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barcode: json['barcode'] ?? '',
      name: json['name'],
      price: json['price'].toDouble(),
      status: json['status'] ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {'barcode': barcode, 'name': name, 'price': price, 'status': status};
  }

  bool get isActive => status == 'ACTIVE';
}
