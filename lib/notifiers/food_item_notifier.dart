import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trilicious_menu/models/food_item.dart';
import 'package:flutter/cupertino.dart';

class FoodItemNotifier with ChangeNotifier {
  List<String> _categoryList = [];
  String? _currentCategory;

  Map<String, List<FoodItem>> _foodItemMap = {};

  List<FoodItem> _foodItemList = [];
  List<FoodItem> _allFoodItemList = [];
  late FoodItem _currentFoodItem;
  UnmodifiableListView<String> get categoryList =>
      UnmodifiableListView(_categoryList);
  UnmodifiableListView<FoodItem> get foodItemList =>
      UnmodifiableListView(_foodItemList);
  UnmodifiableListView<FoodItem> get allFoodItemList =>
      UnmodifiableListView(_allFoodItemList);
  UnmodifiableMapView<String, List<FoodItem>> get foodItemMap =>
      UnmodifiableMapView(_foodItemMap);
  FoodItem get currentFoodItem => _currentFoodItem;

  // void updateAllFoodItem(callback) {
  //   FirebaseFirestore.instance
  //       .collectionGroup('menuItems')
  //       .snapshots()
  //       .map((QuerySnapshot snapshot) =>
  //           snapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList())
  //       .listen((event){
  //         // setState(){}
  //     callback(event) ;
  //     // print(_allFoodItemList);
  //     // foodItemNotifier.allFoodItemList=l;
  //   });
  //   notifyListeners();
  // }

  set foodItemList(List<FoodItem> foodItemList) {
    _foodItemList = foodItemList;
    notifyListeners();
  }

  set allFoodItemList(List<FoodItem> allFoodItemList) {
    _allFoodItemList = allFoodItemList;
    notifyListeners();
  }

  set foodItemMap(Map<String, List<FoodItem>> foodItemMap) {
    _foodItemMap = foodItemMap;
    notifyListeners();
  }

  set currentFoodItem(FoodItem foodItem) {
    _currentFoodItem = foodItem;
    notifyListeners();
  }

  addFoodItem(FoodItem foodItem) {
    _foodItemList.insert(0, foodItem);
    notifyListeners();
  }

  deleteFoodItem(FoodItem foodItem) {
    // _foodItemList.removeWhere((_foodItem) => _foodItem.id == foodItem.id);
    notifyListeners();
  }

  findFoodItem(String foodItem, FoodItemNotifier foodItemNotifier) {
    FoodItem food = foodItemNotifier.allFoodItemList.singleWhere((_foodItem) => _foodItem.itemName==foodItem);
    return food;
  }
  String? get currentCategory => _currentCategory;

  set categoryList(List<String> categoryList) {
    _categoryList = categoryList;
    notifyListeners();
  }

  set currentCategory(String? category) {
    _currentCategory = category;
    notifyListeners();
  }

  // addCategory(String category) {
  //   _categoryList.insert(0, category);
  //   notifyListeners();
  // }

  // deleteCategory(String category) {
  //   _categoryList.remove(category);
  //   notifyListeners();
  // }
}
