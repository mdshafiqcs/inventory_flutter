class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool isEmailVerified;
  String? createdAt;
  String? token;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isEmailVerified,
    this.createdAt,
    this.token,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    bool? isEmailVerified,
    String? createdAt,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? int.parse(map['id'].toString()) : 0,
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      role: map['role'] ?? "",
      isEmailVerified: map['is_email_verified'] != null ? bool.parse(map['is_email_verified'].toString()) : false,
      createdAt: map['created_at'] != null ? map['created_at'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role, isEmailVerified: $isEmailVerified, createdAt: $createdAt, token: $token)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.email == email && other.role == role && other.isEmailVerified == isEmailVerified && other.createdAt == createdAt && other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ role.hashCode ^ isEmailVerified.hashCode ^ createdAt.hashCode ^ token.hashCode;
  }
}
