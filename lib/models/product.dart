class Product {
  final int id;
  final String barcode;
  final String name;
  final double price;
  final String status;

  Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.price,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      barcode: json['barcode'] ?? '',
      name: json['name'],
      price: json['price'].toDouble(),
      status: json['status'] ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'price': price,
      'status': status,
    };
  }

  bool get isActive => status == 'ACTIVE';
}
