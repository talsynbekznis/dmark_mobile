import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/stock.dart';
import '../../usecases/stock_usecase.dart';

class StockPage extends StatefulWidget {
  final StockUsecase usecase;
  const StockPage({required this.usecase, Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<Stock> _stocks = [];
  final _warehouseC = TextEditingController();
  final _gtinC = TextEditingController();
  final _qtyC = TextEditingController(text: '1');
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await widget.usecase.loadStocks();
    setState(()=>_stocks = s);
  }

  Future<void> _add() async {
    final st = Stock(id: const Uuid().v4(), warehouse: _warehouseC.text.trim(), gtin: _gtinC.text.trim(), quantity: int.tryParse(_qtyC.text) ?? 1);
    await widget.usecase.addStock(st);
    _warehouseC.clear();
    _gtinC.clear();
    _qtyC.text = '1';
    await _load();
  }

  Future<void> _decrease(Stock s) async {
    final amount = await showDialog<int>(context: context, builder: (_){
      final c = TextEditingController(text: '1');
      return AlertDialog(
        title: const Text('Decrease quantity'),
        content: TextField(controller: c, keyboardType: TextInputType.number),
        actions: [TextButton(onPressed: ()=>Navigator.pop(context,0), child: const Text('Cancel')), TextButton(onPressed: ()=>Navigator.pop(context,int.tryParse(c.text) ?? 0), child: const Text('OK'))],
      );
    });
    if (amount != null && amount > 0) {
      try {
        await widget.usecase.decreaseStock(s.warehouse, s.gtin, amount);
        await _load();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _deleteStock(Stock s) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('Confirm delete'),
      content: Text('Delete ${s.gtin} @ ${s.warehouse}?'),
      actions: [TextButton(onPressed: ()=>Navigator.pop(context,false), child: const Text('Cancel')), TextButton(onPressed: ()=>Navigator.pop(context,true), child: const Text('OK'))],
    ));
    if (ok == true) {
      await s.delete();
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    var list = _stocks.where((s) => _filter.isEmpty || s.warehouse.toLowerCase().contains(_filter.toLowerCase())).toList();
    final total = _stocks.fold<int>(0, (p,c)=>p+c.quantity);

    return Scaffold(
      appBar: AppBar(title: const Text('Stocks')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Row(children: [Expanded(child: TextField(controller: _warehouseC, decoration: const InputDecoration(labelText: 'Warehouse'))), const SizedBox(width:8), Expanded(child: TextField(controller: _gtinC, decoration: const InputDecoration(labelText: 'GTIN'))), const SizedBox(width:8), Container(width:80, child: TextField(controller: _qtyC, decoration: const InputDecoration(labelText: 'Qty'), keyboardType: TextInputType.number)), const SizedBox(width:8), ElevatedButton(onPressed: _add, child: const Text('Add'))]),
          const SizedBox(height:8),
          Row(children: [Expanded(child: TextField(decoration: const InputDecoration(labelText: 'Filter by warehouse'), onChanged: (v)=>setState(()=>_filter=v))), const SizedBox(width:8), Text('Total: $total')]),
          const SizedBox(height:8),
          Expanded(child: list.isEmpty ? const Center(child: Text('No stocks')) : ListView.builder(itemCount: list.length, itemBuilder: (_,i){
            final s = list[i];
            return Card(child: ListTile(title: Text('${s.gtin} — ${s.warehouse}'), subtitle: Text('Qty: ${s.quantity}'), trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(icon: const Icon(Icons.remove), onPressed: ()=>_decrease(s)), IconButton(icon: const Icon(Icons.delete), onPressed: ()=>_deleteStock(s))])));
          }))
        ]),
      ),
    );
  }
}
