import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.3:3000';
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
        // String errorMessage = _getErrorMessage(
        //   response.statusCode,
        //   response.body,
        // );
        return {'success': false, 'error': 'Error login'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Connection failed: ${e.toString()}'};
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

  Future<Map<String, dynamic>> addProduct({
    required String barcode,
    required String name,
    required double price,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "barcode": barcode,
        "name": name,
        "price": price,
      };

      print('Adding product with data: $requestBody'); // Debugging log
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else {
        // Try to get error message from response
        String errorMessage =
            'Server returned status code: ${response.statusCode}';
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          } else if (errorData.containsKey('error')) {
            errorMessage = errorData['error'];
          }
        } catch (e) {
          // If response body is not JSON
          errorMessage = response.body.isNotEmpty
              ? response.body
              : errorMessage;
        }

        return {
          'success': false,
          'error': errorMessage,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Product> products = body
            .map((dynamic item) => Product.fromJson(item))
            .toList();
        return products;
      } else {
        throw Exception(
          'Failed to load products. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // GET /products/:productId - Fetch single product by barcode
  Future<Product> getProductByBarcode(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$barcode'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Product not found with barcode: $barcode');
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT /products/:productId - Update product
  Future<Product> updateProduct(String barcode, Product updatedProduct) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/$barcode'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedProduct.toJson()),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
