import 'package:flutter/material.dart';
import '../main.dart';
import 'login_screen.dart';
import 'promotion_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) {
    AppState.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userDetail = AppState.userDetail;
    final username = userDetail?.username ?? 'User';
    final roleCode = userDetail?.roleCode ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('PromoApp'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.purple.shade700],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: Colors.blue),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (roleCode.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          roleCode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('List Promotion'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PromotionListScreen(),
                  ),
                );
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () => _logout(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80, color: Colors.blue.shade300),
            const SizedBox(height: 16),
            const Text(
              'Welcome to PromoApp!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Logged in as: $username',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            if (roleCode.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Role: $roleCode',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
