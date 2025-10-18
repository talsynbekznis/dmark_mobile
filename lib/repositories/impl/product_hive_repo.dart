import 'package:hive/hive.dart';
import '../../data/hive_boxes.dart';
import '../../models/product.dart';
import '../interfaces/i_product_repository.dart';

class ProductHiveRepo implements IProductRepository {
  late Box<Product> _box;

  @override
  Future<void> init() async {
    _box = Hive.box<Product>(Boxes.products);
  }

  @override
  Future<void> add(Product p) async {
    await _box.put(p.id, p);
  }

  @override
  Future<void> delete(String id) async {
    final p = _box.get(id);
    if (p != null) {
      // mark as deleted to keep history
      p.status = ProductStatus.deleted;
      p.deletedAt = DateTime.now();
      await p.save();
    }
  }

  @override
  Future<List<Product>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> update(Product p) async {
    await _box.put(p.id, p);
  }

  @override
  Future<Product?> findByGtin(String gtin) async {
    try {
      return _box.values.firstWhere((x) => x.gtin == gtin);
    } catch (e) {
      return null;
    }
  }
}
