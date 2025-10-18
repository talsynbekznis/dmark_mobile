import 'package:hive/hive.dart';
import '../models/product.dart';
import '../data/hive_boxes.dart';
import 'interfaces/i_product_repository.dart';

class ProductRepository implements IProductRepository {
  Box<Product>? _box;

  @override
  Future<void> init() async {
    _box = await Hive.openBox<Product>(Boxes.products);
  }

  @override
  Future<void> add(Product p) async {
    await _box!.put(p.id, p);
  }

  @override
  Future<void> delete(String id) async {
    final p = _box!.get(id);
    if (p != null) {
      // 🔥 теперь используем поле status, а не isActive
      p.status = ProductStatus.deleted;
      p.deletedAt = DateTime.now();
      await p.save();
    }
  }

  @override
  Future<List<Product>> getAll() async {
    // фильтруем по статусу
    return _box!.values
        .where((p) => p.status == ProductStatus.active)
        .toList();
  }

  @override
  Future<Product?> findByGtin(String gtin) async {
    try {
      return _box!.values.firstWhere(
        (p) => p.gtin == gtin && p.status == ProductStatus.active,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> update(Product p) async {
    p.updatedAt = DateTime.now();
    await p.save();
  }
}
