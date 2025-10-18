import 'package:flutter/material.dart';
import '../../usecases/product_usecase.dart';
import '../../usecases/stock_usecase.dart';
import 'product_list_page.dart';
import 'stock_page.dart';

class HomePage extends StatefulWidget {
  final ProductUsecase productUsecase;
  final StockUsecase stockUsecase;
  const HomePage({required this.productUsecase, required this.stockUsecase, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ProductListPage(usecase: widget.productUsecase),
      StockPage(usecase: widget.stockUsecase),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Warehouse Inventory')),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Stocks'),
        ],
      ),
    );
  }
}
