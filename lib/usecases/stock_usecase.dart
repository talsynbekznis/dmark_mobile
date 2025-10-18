import '../models/stock.dart';
import '../services/stock_service.dart';

class StockUsecase {
  final StockService service;
  StockUsecase(this.service);

  Future<List<Stock>> loadStocks() => service.getAll();
  Future<void> addStock(Stock s) => service.addOrIncrease(s);
  Future<void> decreaseStock(String warehouse, String gtin, int amount) => service.decrease(warehouse, gtin, amount);
  Future<List<Stock>> filterByWarehouse(String warehouse) => service.filterByWarehouse(warehouse);
}
