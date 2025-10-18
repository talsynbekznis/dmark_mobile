import 'package:hive_flutter/hive_flutter.dart';
import '../../models/stock.dart';
import '../interfaces/i_stock_repository.dart';

class StockHiveRepository implements IStockRepository {
  late Box<Stock> box;

  @override
  Future<void> init() async {
    box = Hive.box<Stock>('stocks');
  }

  @override
  Future<List<Stock>> getAll() async {
    return box.values.toList();
  }

  @override
  Future<void> addOrIncrease(Stock s) async {
    try {
      final existing = box.values.firstWhere(
        (x) => x.warehouse == s.warehouse && x.gtin == s.gtin,
      );

      // ✅ copyWith бар екеніне көз жеткізу
      final updated = existing.copyWith(quantity: existing.quantity + s.quantity);
      await box.put(existing.id, updated);
    } catch (e) {
      await box.put(s.id, s);
    }
  }

  @override
  Future<void> decrease(String warehouse, String gtin, int amount) async {
    try {
      final existing = box.values.firstWhere(
        (x) => x.warehouse == warehouse && x.gtin == gtin,
      );

      final updated = existing.copyWith(quantity: existing.quantity - amount);
      await box.put(existing.id, updated);
    } catch (e) {
      // егер табылмаса — ештеңе жасамау
    }
  }

  @override
  Future<List<Stock>> filterByWarehouse(String warehouse) async {
    return box.values.where((s) => s.warehouse == warehouse).toList();
  }
}
