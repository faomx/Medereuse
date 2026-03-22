// lib/models/admin_model.dart

class AdminModel {
  final String id;
  final String name;
  final String email;
  final String password; // In real apps this should be encrypted!

  AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  // From JSON
  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
