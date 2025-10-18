
import 'package:hive/hive.dart';

import '../models/stock.dart';
import '../data/hive_boxes.dart';
import 'interfaces/i_stock_repository.dart';


class StockRepository implements IStockRepository {
Box<Stock>? _box;


@override
Future<void> init() async {
_box = await Hive.openBox<Stock>(Boxes.stocks);
}


@override
Future<void> addOrIncrease(Stock s) async {
final existing = _box!.values.firstWhere(
(st) => st.gtin == s.gtin && st.warehouse == s.warehouse,
orElse: () => null as Stock);
if (existing != null) {
existing.quantity += s.quantity;
await existing.save();
} else {
await _box!.put(s.id, s);
}
}


@override
Future<List<Stock>> getAll() async => _box!.values.toList();


@override
Future<void> decrease(String warehouse, String gtin, int amount) async {
final existing = _box!.values.firstWhere(
(st) => st.gtin == gtin && st.warehouse == warehouse,
orElse: () => null as Stock);
if (existing == null) throw Exception('Not found');
if (existing.quantity < amount) throw Exception('Not enough quantity');
existing.quantity -= amount;
await existing.save();
}


@override
Future<List<Stock>> filterByWarehouse(String warehouse) async {
return _box!.values.where((s) => s.warehouse == warehouse).toList();
}
}