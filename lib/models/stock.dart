import 'package:hive/hive.dart';

part 'stock.g.dart';

@HiveType(typeId: 1)
class Stock extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String warehouse;

  @HiveField(2)
  String gtin;

  @HiveField(3)
  int quantity;

  Stock({
    required this.id,
    required this.warehouse,
    required this.gtin,
    required this.quantity,
  });

  Stock copyWith({
    String? id,
    String? warehouse,
    String? gtin,
    int? quantity,
  }) {
    return Stock(
      id: id ?? this.id,
      warehouse: warehouse ?? this.warehouse,
      gtin: gtin ?? this.gtin,
      quantity: quantity ?? this.quantity,
    );
  }
}
