import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/product.dart';
import '../../models/stock.dart';
import '../../usecases/product_usecase.dart';
import '../pages/product_form_page.dart';

class ProductListPage extends StatefulWidget {
  final ProductUsecase usecase;
  const ProductListPage({required this.usecase, Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> _products = [];
  String _search = '';
  bool _sortByName = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await widget.usecase.loadProducts();
    setState(() => _products = data.where((p) => p.status == ProductStatus.active).toList());
  }

  void _openAdd() async {
    final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => ProductFormPage(usecase: widget.usecase)));
    if (res == true) await _load();
  }

  void _edit(Product p) async {
    final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => ProductFormPage(usecase: widget.usecase, product: p)));
    if (res == true) await _load();
  }

  void _delete(Product p) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('Confirm delete'),
      content: Text('Delete ${p.name}?'),
      actions: [TextButton(onPressed: ()=>Navigator.pop(context,false), child: const Text('No')), TextButton(onPressed: ()=>Navigator.pop(context,true), child: const Text('Yes'))],
    ));
    if (ok == true) {
      await widget.usecase.removeProduct(p.id);
      await _load();
    }
  }

  int _totalByGtin(String gtin) {
    try {
      final box = Hive.box<Stock>('stocks');
      return box.values.where((s) => s.gtin == gtin).fold<int>(0, (a,b)=>a+b.quantity);
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var list = _products.where((p) => _search.isEmpty || p.gtin.contains(_search) || p.name.toLowerCase().contains(_search.toLowerCase())).toList();
    if (_sortByName) list.sort((a,b)=>a.name.toLowerCase().compareTo(b.name.toLowerCase())); else list.sort((a,b)=>b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(title: const Text('Products'), actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: _openAdd),
      ]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [Expanded(child: TextField(decoration: const InputDecoration(labelText: 'Search by GTIN or name'), onChanged: (v)=>setState(()=>_search=v))), IconButton(icon: Icon(_sortByName ? Icons.sort_by_alpha : Icons.calendar_today), onPressed: ()=>setState(()=>_sortByName=!_sortByName))])),
        Expanded(child: list.isEmpty ? const Center(child: Text('No products')) : ListView.builder(itemCount: list.length, itemBuilder: (_,i){
          final p = list[i];
          final totalQty = _totalByGtin(p.gtin);
          return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: ListTile(
            title: Row(children:[Expanded(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600))), const SizedBox(width:8), Chip(label: Text(p.status.toString().split('.').last))]),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text('Price: ${p.price.toStringAsFixed(2)} • GTIN: ${p.gtin}'), const SizedBox(height:4), Text('Created: ${p.createdAt.toLocal()}'), const SizedBox(height:4), Text('Total: $totalQty')]),
            isThreeLine: true,
            trailing: Row(mainAxisSize: MainAxisSize.min, children:[IconButton(icon: const Icon(Icons.edit), onPressed: ()=>_edit(p)), IconButton(icon: const Icon(Icons.delete), onPressed: ()=>_delete(p))]),
          ));
        })),
      ]),
    );
  }
}
