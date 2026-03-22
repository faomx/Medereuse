class UserModel {
  final String userId;
  final String name;
  final String email;
  final String password;
  final int age;
  final List<String> roles;

  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.age,
    required this.roles,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      userId: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      age: map['age'] is int ? map['age'] : int.tryParse(map['age'].toString()) ?? 0,
      roles: List<String>.from(map['roles'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'age': age,
      'roles': roles,
    };
  }

  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? password,
    int? age,
    List<String>? roles,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      age: age ?? this.age,
      roles: roles ?? this.roles,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserModel &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              name == other.name &&
              email == other.email &&
              password == other.password &&
              age == other.age &&
              roles.toSet().containsAll(other.roles);

  @override
  int get hashCode =>
      userId.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      age.hashCode ^
      roles.hashCode;
}
