import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
enum ProductStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  deleted,
}

@HiveType(typeId: 2)
class Product extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String gtin; // 13 цифр

  @HiveField(3)
  double price;

  @HiveField(4)
  ProductStatus status;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime? updatedAt;

  @HiveField(7)
  DateTime? deletedAt;

  Product({
    required this.id,
    required this.name,
    required this.gtin,
    required this.price,
    this.status = ProductStatus.active,
    DateTime? createdAt,
    this.updatedAt,
    this.deletedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Product copyWith({
    String? id,
    String? name,
    String? gtin,
    double? price,
    ProductStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      gtin: gtin ?? this.gtin,
      price: price ?? this.price,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
