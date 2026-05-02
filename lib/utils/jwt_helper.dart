import 'dart:convert';
import '../models/user_model.dart';

class JwtHelper {
  // Decode JWT token and extract claims
  static UserDetailModel? decodeToken(String token) {
    try {
      // Split the JWT token
      final parts = token.split('.');
      if (parts.length != 3) {
        print('Invalid JWT token format');
        return null;
      }

      // Decode the payload (second part)
      String payload = parts[1];

      // Add padding if necessary
      while (payload.length % 4 != 0) {
        payload += '=';
      }

      // Decode base64 URL to string
      final String normalized = payload
          .replaceAll('-', '+')
          .replaceAll('_', '/');
      final String decodedPayload = utf8.decode(base64.decode(normalized));

      // Parse JSON
      final Map<String, dynamic> claims = jsonDecode(decodedPayload);

      // Create UserDetailModel from claims
      return UserDetailModel.fromJson(claims);
    } catch (e) {
      print('Error decoding JWT token: $e');
      return null;
    }
  }

  // Extract specific claim from token
  static String? getClaim(String token, String claimName) {
    try {
      final userDetail = decodeToken(token);
      switch (claimName.toLowerCase()) {
        case 'username':
          return userDetail?.username;
        case 'rolecode':
          return userDetail?.roleCode;
        case 'email':
          return userDetail?.email;
        case 'userid':
          return userDetail?.userId;
        default:
          return null;
      }
    } catch (e) {
      print('Error extracting claim: $e');
      return null;
    }
  }

  // Get username from token
  static String? getUsername(String token) {
    return getClaim(token, 'username');
  }

  // Get role code from token
  static String? getRoleCode(String token) {
    return getClaim(token, 'rolecode');
  }
}
