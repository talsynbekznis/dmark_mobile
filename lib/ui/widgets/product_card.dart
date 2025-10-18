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
      appBar: AppBar(title: Text(isEdit ? 'Өңдеу' : 'Жаңа тауар қосу')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameC,
                decoration: const InputDecoration(labelText: 'Атауы'),
                validator: (v) => v == null || v.isEmpty ? 'Атауын енгіз' : null,
              ),
              TextFormField(
                controller: _gtinC,
                decoration: const InputDecoration(labelText: 'GTIN (13 цифр)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'GTIN енгіз';
                  if (!isValidGtin(v)) return 'GTIN 13 цифрдан тұруы керек';
                  return null;
                },
              ),
              TextFormField(
                controller: _priceC,
                decoration: const InputDecoration(labelText: 'Бағасы'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Бағасын енгіз' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? 'Сақтау' : 'Қосу'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
