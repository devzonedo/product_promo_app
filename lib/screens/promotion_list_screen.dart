import 'package:flutter/material.dart';
import '../models/promotion.dart';
import '../widgets/promotion_card.dart';

class PromotionListScreen extends StatelessWidget {
  const PromotionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Promotion> promotions = Promotion.getPromotions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotion List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promotions.length,
        itemBuilder: (context, index) {
          return PromotionCard(
            promotion: promotions[index],
            onTap: () {
              _showPromotionDetails(context, promotions[index]);
            },
          );
        },
      ),
    );
  }

  void _showPromotionDetails(BuildContext context, Promotion promotion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: promotion.color,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(promotion.icon, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  promotion.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: promotion.discount.contains('OFF')
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    promotion.discount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: promotion.discount.contains('OFF')
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  promotion.description,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
