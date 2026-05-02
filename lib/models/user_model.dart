import 'dart:convert';

class UserDetailModel {
  final String username;
  final String roleCode;
  final String? email;
  final String? userId;
  final DateTime? expiryDate;

  UserDetailModel({
    required this.username,
    required this.roleCode,
    this.email,
    this.userId,
    this.expiryDate,
  });

  // Factory method to create UserDetailModel from JSON
  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      username:
          json['username'] ?? json['user_name'] ?? json['sub'] ?? 'Unknown',
      roleCode: json['roleCode'] ?? json['role_code'] ?? json['role'] ?? 'USER',
      email: json['email'],
      userId: json['userId'] ?? json['user_id'] ?? json['id'],
      expiryDate: json['exp'] != null
          ? DateTime.fromMillisecondsSinceEpoch((json['exp'] as int) * 1000)
          : null,
    );
  }

  // Method to check if token is expired
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  @override
  String toString() {
    return 'UserDetailModel(username: $username, roleCode: $roleCode, email: $email, userId: $userId)';
  }
}
