import 'package:flutter/material.dart';

class Promotion {
  final String title;
  final String description;
  final String discount;
  final IconData icon;
  final Color color;

  Promotion({
    required this.title,
    required this.description,
    required this.discount,
    required this.icon,
    required this.color,
  });

  // Sample data
  static List<Promotion> getPromotions() {
    return [
      Promotion(
        title: 'Summer Sale',
        description: 'Get up to 50% off on summer collections',
        discount: '50% OFF',
        icon: Icons.wb_sunny,
        color: Colors.orange,
      ),
      Promotion(
        title: 'Weekend Flash',
        description: 'Limited time offer on electronics',
        discount: '30% OFF',
        icon: Icons.flash_on,
        color: Colors.red,
      ),
      Promotion(
        title: 'New User Bonus',
        description: 'Special discount for new customers',
        discount: '20% OFF',
        icon: Icons.emoji_events,
        color: Colors.amber,
      ),
      Promotion(
        title: 'Free Shipping',
        description: 'Free delivery on orders above \$50',
        discount: 'FREE',
        icon: Icons.local_shipping,
        color: Colors.green,
      ),
      Promotion(
        title: 'Birthday Special',
        description: 'Exclusive offers for your birthday month',
        discount: '25% OFF',
        icon: Icons.cake,
        color: Colors.purple,
      ),
    ];
  }
}
