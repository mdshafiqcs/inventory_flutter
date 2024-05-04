class Item {
  final int id;
  final int inventoryId;
  final String name;
  final String description;
  final String image;
  final int qty;
  final String createdAt;
  Item({
    required this.id,
    required this.inventoryId,
    required this.name,
    required this.description,
    required this.image,
    required this.qty,
    required this.createdAt,
  });

  Item copyWith({
    int? id,
    int? inventoryId,
    String? name,
    String? description,
    String? image,
    int? qty,
    double? price,
    int? minStock,
    bool? isDeleted,
    String? createdAt,
  }) {
    return Item(
      id: id ?? this.id,
      inventoryId: inventoryId ?? this.inventoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      qty: qty ?? this.qty,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] != null ? int.parse(map['id'].toString()) : 0,
      inventoryId: map['inventory_id'] != null ? int.parse(map['inventory_id'].toString()) : 0,
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      image: map['image'] ?? "",
      qty: map['qty'] != null ? int.parse(map['qty'].toString()) : 0,
      createdAt: map['createdAt'] ?? "",
    );
  }

  @override
  String toString() {
    return 'Item(id: $id, inventoryId: $inventoryId, name: $name, description: $description, image: $image, qty: $qty, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.id == id && other.inventoryId == inventoryId && other.name == name && other.description == description && other.image == image && other.qty == qty && other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ inventoryId.hashCode ^ name.hashCode ^ description.hashCode ^ image.hashCode ^ qty.hashCode ^ createdAt.hashCode;
  }
}
