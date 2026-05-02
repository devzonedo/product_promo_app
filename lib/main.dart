import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'models/user_model.dart';

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

// Global state management for token, user details, and login state
class AppState {
  static String? _token;
  static UserDetailModel? _userDetail;
  static bool _isLoggedIn = false;

  static String? get token => _token;
  static UserDetailModel? get userDetail => _userDetail;
  static bool get isLoggedIn => _isLoggedIn;

  static void setToken(String token, {UserDetailModel? userDetail}) {
    _token = token;
    _userDetail = userDetail;
    _isLoggedIn = true;

    // You can optionally save to SharedPreferences here for persistence
    // _saveToPreferences();
  }

  static void setUserDetail(UserDetailModel userDetail) {
    _userDetail = userDetail;
  }

  static void logout() {
    _token = null;
    _userDetail = null;
    _isLoggedIn = false;

    // Clear SharedPreferences if used
    // _clearPreferences();
  }
}
