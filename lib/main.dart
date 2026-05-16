import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'models/user_model.dart';
import 'package:product_promo_app/screens/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PromoApp',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const CheckLoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CheckLoginScreen extends StatelessWidget {
  const CheckLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in (has valid token)
    bool isLoggedIn = AppState.isLoggedIn && AppState.token != null;

    // Check if token is expired
    if (isLoggedIn &&
        AppState.userDetail != null &&
        AppState.userDetail!.isExpired) {
      AppState.logout();
      isLoggedIn = false;
    }

    if (isLoggedIn) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
