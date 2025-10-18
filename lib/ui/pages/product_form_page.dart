import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/product.dart';
import '../../usecases/product_usecase.dart';
import '../utils/validators.dart';

class ProductFormPage extends StatefulWidget {
  final ProductUsecase usecase;
  final Product? product;
  const ProductFormPage({required this.usecase, this.product, Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _gtinC = TextEditingController();
  final _priceC = TextEditingController();

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _nameC.text = widget.product!.name;
      _gtinC.text = widget.product!.gtin;
      _priceC.text = widget.product!.price.toString();
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final id = isEdit ? widget.product!.id : const Uuid().v4();
    final p = Product(
      id: id,
      name: _nameC.text.trim(),
      gtin: _gtinC.text.trim(),
      price: double.tryParse(_priceC.text.trim()) ?? 0,
      status: widget.product?.status ?? ProductStatus.active,
      createdAt: widget.product?.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: widget.product?.deletedAt,
    );

    if (isEdit) {
      await widget.usecase.editProduct(p);
    } else {
      await widget.usecase.createProduct(p);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Product' : 'Add New Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameC,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter product name' : null,
              ),
              TextFormField(
                controller: _gtinC,
                decoration: const InputDecoration(labelText: 'GTIN (13 digits)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter GTIN';
                  if (!isValidGtin(v)) return 'GTIN must be 13 digits long';
                  return null;
                },
              ),
              TextFormField(
                controller: _priceC,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? 'Save' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
