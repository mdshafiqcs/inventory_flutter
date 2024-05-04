class Inventory {
  final int id;
  final int userId;
  final String name;
  final String description;
  final String createdAt;
  Inventory({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  //

  Inventory copyWith({
    int? id,
    int? userId,
    String? name,
    String? description,
    bool? isDeleted,
    String? createdAt,
  }) {
    return Inventory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Inventory.fromMap(Map<String, dynamic> map) {
    return Inventory(
      id: map['id'] != null ? int.parse(map['id'].toString()) : 0,
      userId: map['user_id'] != null ? int.parse(map['user_id'].toString()) : 0,
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      createdAt: map['created_at'] ?? "",
    );
  }

  @override
  String toString() {
    return 'Inventory(id: $id, userId: $userId, name: $name, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Inventory other) {
    if (identical(this, other)) return true;

    return other.id == id && other.userId == userId && other.name == name && other.description == description && other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ name.hashCode ^ description.hashCode ^ createdAt.hashCode;
  }
}
