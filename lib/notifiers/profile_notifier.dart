// import 'dart:io';
// import 'package:trilicious_menu/models/menu_item.dart';
import 'package:flutter/cupertino.dart';
// import 'package:trilicious_dashboard/models/restaurant.dart';
import 'package:trilicious_menu/models/restaurant.dart';


class ProfileNotifier with ChangeNotifier {
  Restaurant? _currentRestaurant;
  String? _currentId;

  Restaurant? get currentRestaurant => _currentRestaurant;
  String? get currentId => _currentId;
  // File? get coverImageFile => _coverImageFile;
  // File? get profileImageFile => _profileImageFile; 

  set currentRestaurant(Restaurant? restaurant) {
    _currentRestaurant = restaurant;
    notifyListeners();
  }

  set currentId(String? id) {
    _currentId = id;
    notifyListeners();
  }

  // set coverImageFile(File? coverFile){
  //   _coverImageFile=coverFile;
  //   notifyListeners();
  // }
  // set profileImageFile(File? profileFile){
  //   _profileImageFile=profileFile;
  //   notifyListeners();
  // }

  // addOrder(Order order) {
  //   _orderList.insert(0, order);
  //   notifyListeners();
  // }
}