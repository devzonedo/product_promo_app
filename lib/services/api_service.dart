import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.2:3000';
  // For Android emulator: static const String baseUrl = 'http://10.0.2.2:3000';

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final url = Uri.parse('$baseUrl/token');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      // Only status code 200 is considered successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Login response data: $data'); // Debugging log
        // Validate that token exists in response
        if (data.containsKey('token') &&
            data['token'] != null &&
            data['token'].toString().isNotEmpty) {
          return {'success': true, 'token': data['token']};
        } else {
          return {'success': false, 'error': 'Server response missing token'};
        }
      } else {
        // Handle different error status codes
        String errorMessage = _handleErrorResponse(response);
        return {'success': false, 'error': errorMessage};
      }
    } catch (e) {
      return {
        'success': false,
        'error':
            'Unable to connect to server. Please check your internet connection.',
      };
    }
  }

  String _handleErrorResponse(http.Response response) {
    // Try to parse error message from response body
    try {
      final Map<String, dynamic> errorData = jsonDecode(response.body);

      // Common error field names in APIs
      if (errorData.containsKey('message')) {
        return errorData['message'];
      }
      if (errorData.containsKey('error')) {
        return errorData['error'];
      }
      if (errorData.containsKey('detail')) {
        return errorData['detail'];
      }
    } catch (e) {
      // Response body is not JSON or doesn't contain error field
    }

    // Default error messages based on status code
    switch (response.statusCode) {
      case 400:
        return 'Invalid request. Please check your credentials.';
      case 401:
        return 'Invalid username or password. Please try again.';
      case 403:
        return 'Access denied. Please contact support.';
      case 404:
        return 'Authentication service not found.';
      case 429:
        return 'Too many attempts. Please try again later.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Server error. Please try again later.';
      default:
        return 'Login failed. Please try again. (Error: ${response.statusCode})';
    }
  }
}
