import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../data/hive_boxes.dart';
import '../../models/stock.dart';
import '../interfaces/i_stock_repository.dart';

class StockHiveRepo implements IStockRepository {
  late Box<Stock> _box;

  @override
  Future<void> init() async {
    _box = Hive.box<Stock>(Boxes.stocks);
  }

  @override
  Future<List<Stock>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> addOrIncrease(Stock s) async {
    // Use composite key: warehouse_gtin -> but we store by id and search
    try {
      final existing = _box.values.firstWhere(
        (x) => x.warehouse == s.warehouse && x.gtin == s.gtin,
      );
      final updated = existing.copyWith(quantity: existing.quantity + s.quantity);
      await _box.put(existing.id, updated);
    } catch (e) {
      // not found -> put new
      final id = s.id.isNotEmpty ? s.id : const Uuid().v4();
      await _box.put(id, s.copyWith(id: id));
    }
  }

  @override
  Future<void> decrease(String warehouse, String gtin, int amount) async {
    try {
      final existing = _box.values.firstWhere(
        (x) => x.warehouse == warehouse && x.gtin == gtin,
      );
      final newQty = existing.quantity - amount;
      if (newQty > 0) {
        await _box.put(existing.id, existing.copyWith(quantity: newQty));
      } else {
        await _box.delete(existing.id);
      }
    } catch (e) {
      // nothing
    }
  }

  @override
  Future<List<Stock>> filterByWarehouse(String warehouse) async {
    return _box.values.where((s) => s.warehouse == warehouse).toList();
  }
}
