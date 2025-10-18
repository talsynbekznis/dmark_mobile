import 'package:d_intern/services/product_service.dart';


import '../models/product.dart';


class ProductUsecase {
  final ProductService service;
  ProductUsecase(this.service);

  Future<List<Product>> loadProducts() => service.getAll();
  Future<void> createProduct(Product p) => service.add(p);
  Future<void> editProduct(Product p) => service.update(p);
  Future<void> removeProduct(String id) => service.delete(id);
  Future<Product?> findByGtin(String gtin) => service.findByGtin(gtin);
}
