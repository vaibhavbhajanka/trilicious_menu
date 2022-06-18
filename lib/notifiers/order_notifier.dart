import 'dart:collection';
import 'package:trilicious_menu/models/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:trilicious_menu/models/order.dart';

class OrderNotifier with ChangeNotifier {
  List<Order> _orderList = [];
  // Map<MenuItem?,int> _quantities = {};
  Order? _currentOrder;
  // int _totalBill=0;

  UnmodifiableListView<Order> get orderList => UnmodifiableListView(_orderList);
  // UnmodifiableMapView<int> get quantities => UnmodifiableListView(_quantities);
  // Map<MenuItem?,int> get quantities => _quantities;
  // int get totalBill => _totalBill;
  // MenuItem? get currentMenuItem => _currentMenuItem;
  Order? get currentOrder => _currentOrder;

  set orderList(List<Order> orderList) {
    _orderList = orderList;
    notifyListeners();
  }

  set currentOrder(Order? order) {
    _currentOrder = order;
    notifyListeners();
  }

  // set quantities(Map<MenuItem?,int> quantities) {
  //   _quantities = quantities;
  //   notifyListeners();
  // }

  // set totalBill(int totalBill)
  // {
  //   _totalBill = totalBill;
  // }

  // set currentMenuItem(MenuItem? menuItem) {
  //   _currentMenuItem = menuItem;
  //   notifyListeners();
  // }

  // addMenuItem(MenuItem? menuItem) {
  //   _orderList.insert(0, menuItem);
  //   _quantities[menuItem]=1;
  //   _totalBill += menuItem?.price?.toInt()??0;
  //   notifyListeners();
  // }

  // incrementQuantity(MenuItem? menuItem) {
  //   // _orderList.insert(0, menuItem);
  //   if (_quantities[menuItem]!=null) {
  //     _quantities[menuItem] = _quantities[menuItem]! + 1;
  //     _totalBill += menuItem?.price?.toInt()??0;
  //   }
  //   notifyListeners();
  // }

  // decrementQuantity(MenuItem? menuItem) {
  //   // _orderList.insert(0, menuItem);
  //   if (_quantities[menuItem]!=null) {
  //     _quantities[menuItem] = _quantities[menuItem]! - 1;
  //     _totalBill -= menuItem?.price?.toInt()??0;
  //   }
  //   if(quantities[menuItem]==0){
  //     _orderList.remove(menuItem);
  //   }
  //   notifyListeners();
  // }

  // deleteMenuItem(MenuItem menuItem) {
  //   _orderList.removeWhere((_menuItem) => _menuItem.id == menuItem.id);
  //   notifyListeners();
  // }
}