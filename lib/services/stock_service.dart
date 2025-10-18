import '../models/stock.dart';
import '../repositories/interfaces/i_stock_repository.dart';

class StockService {
  final IStockRepository repo;
  StockService(this.repo);

  Future<void> init() => repo.init();
  Future<List<Stock>> getAll() => repo.getAll();
  Future<void> addOrIncrease(Stock s) => repo.addOrIncrease(s);
  Future<void> decrease(String warehouse, String gtin, int amount) => repo.decrease(warehouse, gtin, amount);
  Future<List<Stock>> filterByWarehouse(String warehouse) => repo.filterByWarehouse(warehouse);
}
