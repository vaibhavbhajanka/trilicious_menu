import 'dart:math';

import 'package:flutter/material.dart';

class FMenu extends StatefulWidget {
  @override
  _FMenuState createState() => _FMenuState();
}

class _FMenuState extends State<FMenu> {
  final Map<String, List<String>> _categories = <String, List<String>>{};
  final List<int> _categoryOffsets = <int>[];

  final ScrollController _categoriesController = ScrollController();
  final ScrollController _productsController = ScrollController();

  final int _categoryItemExtent = 150;
  final int _productItemExtent = 100;

  int _categoryIdx = 0;

  @override
  void initState() {
    super.initState();
    _productsController.addListener(_onProductsScroll);

    for (int i = 1; i <= 10; i++) {
      int productCnt = Random().nextInt(10);
      productCnt = productCnt == 0 ? 1 : productCnt;

      _categories['Category $i'] =
          List.generate(productCnt, (int j) => 'Product ${i * 10 + j}');

      final int prevOffset = i == 1 ? 0 : _categoryOffsets[i - 2];
      _categoryOffsets.add(prevOffset + (_productItemExtent * productCnt));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> allProducts = _categories.entries.fold<List<String>>(
      <String>[],
      (previousValue, element) {
        previousValue.addAll(element.value);
        return previousValue;
      },
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView.builder(
              controller: _categoriesController,
              scrollDirection: Axis.horizontal,
              itemExtent: _categoryItemExtent.toDouble(),
              itemCount: _categories.length,
              itemBuilder: (_, int i) => Card(
                color: _categoryIdx == i ? Colors.green : null,
                child: Text(_categories.keys.elementAt(i)),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              controller: _productsController,
              itemExtent: _productItemExtent.toDouble(),
              itemCount: allProducts.length,
              itemBuilder: (_, int i) {
                return Card(
                  child: Text(allProducts[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onProductsScroll() {
    final double offset = _productsController.offset;

    for (int i = 0; i < _categoryOffsets.length; i++) {
      if (offset <= _categoryOffsets[i]) {
        if (_categoryIdx != i) {
          print('Scroll to category $i');
          _categoriesController.animateTo(
            (i * _categoryItemExtent).toDouble(),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );

          setState(() => _categoryIdx = i);
        }
        break;
      }
    }
  }

  @override
  void dispose() {
    _categoriesController.dispose();
    _productsController.removeListener(_onProductsScroll);
    _productsController.dispose();
    super.dispose();
  }
}