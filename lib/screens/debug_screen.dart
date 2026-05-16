import 'package:flutter/material.dart';
import 'package:product_promo_app/screens/app_state.dart';
import '../main.dart';
import '../utils/jwt_helper.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final token = AppState.token;
    final userDetail = AppState.userDetail;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Info'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoCard('Username', userDetail?.username ?? 'N/A'),
            _buildInfoCard('Role Code', userDetail?.roleCode ?? 'N/A'),
            _buildInfoCard('Email', userDetail?.email ?? 'N/A'),
            _buildInfoCard('User ID', userDetail?.userId ?? 'N/A'),
            _buildInfoCard(
              'Token Expired',
              userDetail?.isExpired.toString() ?? 'N/A',
            ),
            const SizedBox(height: 24),
            const Text(
              'Raw Token (first 100 chars):',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                token != null && token.length > 100
                    ? '${token.substring(0, 100)}...'
                    : token ?? 'No token',
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
