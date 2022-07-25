import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:trilicious_menu/models/food_item.dart';

class CartNotifier with ChangeNotifier {
  List<FoodItem> _itemList = [];
  Map<String, int> _price = {};
  Map<String, int> _quantity = {};
  int _totalQuantity = 0;
  double _bill = 0;
  double _discount = 0;
  double _totalBill = 0;

  UnmodifiableListView<FoodItem> get itemList => UnmodifiableListView(_itemList);
  // Map<String,Map<String,int>> get itemList => _itemList;
  Map<String, int> get price => _price;
  Map<String, int> get quantity => _quantity;
  int get totalQuantity => _totalQuantity;
  double get bill => _bill;
  double get discount => _discount;
  double get totalBill => _totalBill;

  set itemList(List<FoodItem> itemList) {
    _itemList = itemList;
    notifyListeners();
  }

  updateBill(FoodItem foodItem, bool isIncremented) {
    if (isIncremented) {
      _bill += foodItem.price ?? 0;
    } else {
      _bill -= foodItem.price ?? 0;
    }
    _discount = (_bill * 0.15);
    _totalBill = (_bill - _discount);
  }

  addItem(FoodItem foodItem) {
    _itemList.add(foodItem);
    _quantity[foodItem.itemName.toString()] = 1;
    _price[foodItem.itemName.toString()] = foodItem.price ?? 0;
    _totalQuantity += 1;
    updateBill(foodItem, true);
    notifyListeners();
  }

  incrementQuantity(FoodItem foodItem) {
    if (_quantity[foodItem.itemName.toString()] != null) {
      _quantity[foodItem.itemName.toString()] =
          (_quantity[foodItem.itemName.toString()])! + 1;
      _totalQuantity += 1;
      updateBill(foodItem, true);
    }
  }

  decrementQuantity(FoodItem foodItem) {
    if (_quantity[foodItem.itemName.toString()] != null) {
      _quantity[foodItem.itemName.toString()] =
          (_quantity[foodItem.itemName.toString()])! - 1;
      _totalQuantity -= 1;
      if (_quantity[foodItem.itemName.toString()] == 0) {
        _itemList.remove(foodItem);
        print(_itemList);
        _quantity.remove(foodItem.itemName);
        _price.remove(foodItem.itemName);
      }
      updateBill(foodItem, false);
    }
    // if(_quantity[foodItem]!=null){
    //   _quantity[foodItem]=_quantity[foodItem]!-1;
    //   _totalQuantity-=1;
    //   if(_quantity[foodItem]==0){
    //     _itemList.remove(foodItem);
    //   }
    //   updateBill(foodItem,false);
    // }
  }

  findFoodItem(FoodItem foodItem,CartNotifier cartNotifier) {
    FoodItem food = cartNotifier.itemList.singleWhere((f) => f.itemName==foodItem.itemName);
    return food;
  }

  emptyCart() {
    _itemList.clear();
    _price.clear();
    _quantity.clear();
    _totalQuantity = 0;
    _bill = 0;
    _discount = 0;
    _totalBill = 0;
    notifyListeners();
  }
  // deleteCart(Cart Cart) {
  // _itemList.removeWhere((_Cart) => _Cart.id == Cart.id);
  //   notifyListeners();
  // }
}
