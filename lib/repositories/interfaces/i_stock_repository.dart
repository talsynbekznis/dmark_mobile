import '../../models/stock.dart';

abstract class IStockRepository {
  Future<void> init();
  Future<List<Stock>> getAll();
  Future<void> addOrIncrease(Stock s);
  Future<void> decrease(String warehouse, String gtin, int amount);
  Future<List<Stock>> filterByWarehouse(String warehouse);
}
