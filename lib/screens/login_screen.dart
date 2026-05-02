import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'home_screen.dart';
import '../utils/jwt_helper.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await _authenticateUser(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );

        if (mounted) {
          if (result['success'] == true) {
            final String token = result['token'];
            print('Received token: $token'); // Debugging log
            // Decode JWT token to get user details
            final UserDetailModel? userDetail = JwtHelper.decodeToken(token);

            if (userDetail != null) {
              // Store both token and user details
              AppState.setToken(token, userDetail: userDetail);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Welcome ${userDetail.username}!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to decode user information'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['error']),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<Map<String, dynamic>> _authenticateUser(
    String username,
    String password,
  ) async {
    try {
      final url = Uri.parse('http://192.168.1.2:3000/token');

      // For Android emulator, use:
      // final url = Uri.parse('http://10.0.2.2:3000/token');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Connection timeout. Please try again.');
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('token') &&
            responseData['token'] != null) {
          return {'success': true, 'token': responseData['token']};
        } else {
          return {
            'success': false,
            'error': 'Invalid response from server: Token not found',
          };
        }
      } else {
        String errorMessage = _getErrorMessage(
          response.statusCode,
          response.body,
        );
        return {'success': false, 'error': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'error': 'Connection failed: ${e.toString()}'};
    }
  }

  String _getErrorMessage(int statusCode, String responseBody) {
    try {
      final Map<String, dynamic> errorData = jsonDecode(responseBody);
      if (errorData.containsKey('message')) {
        return errorData['message'];
      }
      if (errorData.containsKey('error')) {
        return errorData['error'];
      }
    } catch (e) {
      // If response body is not JSON, use default messages
    }

    switch (statusCode) {
      case 400:
        return 'Bad request: Please check your input';
      case 401:
        return 'Invalid username or password';
      case 403:
        return 'Access denied';
      case 404:
        return 'Service not found';
      case 500:
        return 'Server error. Please try again later';
      default:
        return 'Login failed. Please try again. (Status code: $statusCode)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.purple.shade300],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_offer,
                        size: 80,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'PromoApp',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Enter your credentials to continue',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
