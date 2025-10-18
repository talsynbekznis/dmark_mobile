import '../models/product.dart';
import '../repositories/interfaces/i_product_repository.dart';

class ProductService {
  final IProductRepository repo;
  ProductService(this.repo);

  Future<void> init() => repo.init();
  Future<List<Product>> getAll() => repo.getAll();
  Future<void> add(Product p) => repo.add(p);
  Future<void> update(Product p) => repo.update(p);
  Future<void> delete(String id) => repo.delete(id);
  Future<Product?> findByGtin(String gtin) => repo.findByGtin(gtin);
}
