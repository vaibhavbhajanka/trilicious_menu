// import 'package:trilicious_dashboard/model/user_model.dart';

// import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
import 'package:trilicious_menu/models/food_item.dart';
import 'package:trilicious_menu/notifiers/food_item_notifier.dart';

// login(User user, AuthNotifier authNotifier) async {
//   AuthResult authResult = await FirebaseAuth.instance
//       .signInWithEmailAndPassword(email: user.email, password: user.password)
//       .catchError((error) => print(error.code));

//   if (authResult != null) {
//     FirebaseUser firebaseUser = authResult.user;

//     if (firebaseUser != null) {
//       print("Log In: $firebaseUser");
//       authNotifier.setUser(firebaseUser);
//     }
//   }
// }

// signup(User user, AuthNotifier authNotifier) async {
//   AuthResult authResult = await FirebaseAuth.instance
//       .createUserWithEmailAndPassword(email: user.email, password: user.password)
//       .catchError((error) => print(error.code));

//   if (authResult != null) {
//     UserUpdateInfo updateInfo = UserUpdateInfo();
//     updateInfo.displayName = user.displayName;

//     FirebaseUser firebaseUser = authResult.user;

//     if (firebaseUser != null) {
//       await firebaseUser.updateProfile(updateInfo);

//       await firebaseUser.reload();

//       print("Sign up: $firebaseUser");

//       FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
//       authNotifier.setUser(currentUser);
//     }
//   }
// }

// signout(AuthNotifier authNotifier) async {
//   await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

//   authNotifier.setUser(null);
// }

// initializeCurrentUser(AuthNotifier authNotifier) async {
//   FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

//   if (firebaseUser != null) {
//     print(firebaseUser);
//     authNotifier.setUser(firebaseUser);
//   }
// }

// searchByName(String searchField) {
//     return FirebaseFirestore.instance
//         .collection("users")
//         .where('name', isEqualTo: searchField)
//         .get();
// }

// addChatRoom(chatRoom, chatRoomId) async {
//     await FirebaseFirestore.instance
//         .collection("chatRoom")
//         .doc(chatRoomId)
//         .set(chatRoom)
//         .catchError((e) {
//       print(e);
//     });
//   }

// getChats(String chatRoomId) async{
//     return FirebaseFirestore.instance
//         .collection("chatRoom")
//         .doc(chatRoomId)
//         .collection("chats")
//         .orderBy('time')
//         .snapshots();
//   }

//   addMessage2(String chatRoomId, chatMessageData)async{

//     await FirebaseFirestore.instance.collection("chatRoom")
//         .doc(chatRoomId)
//         .collection("chats")
//         .add(chatMessageData).catchError((e){
//           print(e.toString());
//     });
//   }

//   getUserChats(String itIsMyName)async {
//     return FirebaseFirestore.instance
//         .collection("chatRoom")
//         .where('users', arrayContains: itIsMyName)
//         .snapshots();
//   }
getCategories(FoodItemNotifier foodItemNotifier) async {
  // User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('menu').doc('category').get();
  print(snapshot.data());
  if (snapshot.exists) {
    List<String> categories;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    categories = data['categories'].cast<String>();
    foodItemNotifier.categoryList = categories;
  }
  print(foodItemNotifier.categoryList);
}

getFoodItems(FoodItemNotifier foodItemNotifier) async {
  // User? user = FirebaseAuth.instance.currentUser;
  // getCategories(foodItemNotifier);
  List<String> categories = foodItemNotifier.categoryList;
  Map<String, List<FoodItem>> foodItemMap = {};

  for (int i = 0; i < categories.length; i++) {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('menu')
        .doc(categories[i])
        .collection('menuItems')
        .get();
    List<FoodItem> items = [];
    for (var document in snapshot.docs) {
      // print(document.data());
      FoodItem foodItem = FoodItem.fromMap(document.data());
      // print(foodItem.itemName);
      items.add(foodItem);
    }
    foodItemMap[categories[i]] = items;
    // print(_foodItemMap[categories[i]]);
  }
  foodItemNotifier.foodItemMap = foodItemMap;
}
Stream<List<FoodItem>> get allFoodItems{
    return FirebaseFirestore.instance
        .collectionGroup('menuItems')
        .snapshots()
        .map((QuerySnapshot snapshot) =>
            snapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList());
  }

getAllFoodItems(FoodItemNotifier foodItemNotifier) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collectionGroup('menuItems').get();
  List<FoodItem> items = [];
  for (var document in snapshot.docs) {
    // print(foodItem.itemName);
    items.add(FoodItem.fromMap(document.data()));
  }
  print(items);
  // print(_foodItemMap[categories[i]]);
}
// Stream<List<String>> getCats(){
//   return FirebaseFirestore.instance.collection('menu').doc('category').snapshots()
//   .map((doc) => doc.data()?['categories'].toList());
// }

// getFoodItems(FoodItemNotifier foodItemNotifier) async {
//   // User? user = FirebaseAuth.instance.currentUser;
//   QuerySnapshot snapshot = await FirebaseFirestore.instance
//       .collection('menu')
//       // .doc(user!.uid)
//       // .collection('properties')
//       // .orderBy("date", descending: true)
//       .get();

//   List<FoodItem> _foodItemList = [];

//   for (var document in snapshot.docs) {
//     // print(document.data());
//     FoodItem foodItem = FoodItem.fromMap(document.data());
//     _foodItemList.add(foodItem);
//   }

//   foodItemNotifier.foodItemList = _foodItemList;
// }

// uploadfoodItemAndImage(foodItem foodItem, bool isUpdating, File localFile, Function foodItemUploaded) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = const Uuid().v4();

//     final firebaseStorageRef =
//         FirebaseStorage.instance.ref().child('food/images/$uuid$fileExtension');

//     await firebaseStorageRef.putFile(localFile).whenComplete(() => null).catchError((onError) {
//       print(onError);
//       // return false;
//     });

//     String url = await firebaseStorageRef.getDownloadURL();
//     print("download url: $url");
//     _uploadfoodItem(foodItem, isUpdating, foodItemUploaded, imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadfoodItem(foodItem, isUpdating, foodItemUploaded);
//   }
// }

// _uploadfoodItem(foodItem foodItem, bool isUpdating, Function foodItemUploaded, {String? imageUrl}) async {
//   CollectionReference foodItemRef = FirebaseFirestore.instance.collection('food');

//   if (imageUrl != null) {
//     foodItem.image = imageUrl;
//   }

//   if (isUpdating) {
//     foodItem.updatedAt = Timestamp.now();
//     print('updating:${foodItem.id}');
//     await foodItemRef.doc(foodItem.id.toString()).update(foodItem.toMap());

//     foodItemUploaded(foodItem);
//     print('updated foodItem with id: ${foodItem.id}');
//   } else {
//     foodItem.isAvailable = true;
//     foodItem.createdAt = Timestamp.now();

//     DocumentReference documentRef = await foodItemRef.add(foodItem.toMap());

//     foodItem.id = documentRef.id;

//     print('uploaded foodItem successfully: ${foodItem.toString()}');

//     await documentRef.set(foodItem.toMap());

//     foodItemUploaded(foodItem);
//   }
// }

// deletefoodItem(foodItem foodItem, Function foodItemDeleted) async {
//   if (foodItem.image != null) {
//     StorageReference storageReference =
//         await FirebaseStorage.instance.getReferenceFromUrl(foodItem.image);

//     print(storageReference.path);

//     await storageReference.delete();

//     print('image deleted');
//   }

//   await Firestore.instance.collection('foodItems').document(foodItem.id).delete();
//   foodItemDeleted(foodItem);
// }