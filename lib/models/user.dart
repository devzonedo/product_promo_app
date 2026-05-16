class User {
  final int userId;
  final String username;
  final String firstName;
  final String lastName;
  final String roleCode;
  final String status;
  final String createdDateTime;

  User({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.roleCode,
    required this.status,
    required this.createdDateTime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as int,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      roleCode: json['roleCode'] as String,
      status: json['status'] as String,
      createdDateTime: json['createdDateTime'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'roleCode': roleCode,
      'createdDateTime': createdDateTime,
      'status': status,
    };
  }
}

/**
 * 
// Parse JSON array response from API
final List<dynamic> jsonArray = await fetchUsersFromApi();
final List<User> users = jsonArray
    .map((json) => User.fromJson(json))
    .toList();

 */
