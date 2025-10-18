import '../../models/product.dart';

abstract class IProductRepository {
  Future<void> init();
  Future<void> add(Product p);
  Future<void> update(Product p);
  Future<void> delete(String id);
  Future<List<Product>> getAll();
  Future<Product?> findByGtin(String gtin);
}
