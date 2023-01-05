// import 'package:trilicious_dashboard/model/user_model.dart';
// import 'package:trilicious_menu/models/menu_item.dart';
// import 'package:trilicious_menu/notifiers/menu_item_notifier.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
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
// getorders(orderNotifier orderNotifier) async {
//   // User? user = FirebaseAuth.instance.currentUser;
//   QuerySnapshot snapshot = await FirebaseFirestore.instance
//       .collection('menu')
//       // .doc(user!.uid)
//       // .collection('properties')
//       // .orderBy("date", descending: true)
//       .where('isAvailable',isEqualTo: true)
//       .get();

//   List<order> _orderList = [];

//   for (var document in snapshot.docs) {
//     print(document.data());
//     order order = order.fromMap(document.data());
//     _orderList.add(order);
//   }

//   orderNotifier.orderList = _orderList;
// }

// uploadorderAndImage(order order, bool isUpdating, File localFile, Function orderUploaded) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = const Uuid().v4();

//     final firebaseStorageRef =
//         FirebaseStorage.instance.ref().child('menu/images/$uuid$fileExtension');

//     await firebaseStorageRef.putFile(localFile).whenComplete(() => null).catchError((onError) {
//       print(onError);
//       // return false;
//     });

//     String url = await firebaseStorageRef.getDownloadURL();
//     print("download url: $url");
//     _uploadorder(order, isUpdating, orderUploaded, imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadorder(order, isUpdating, orderUploaded);
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_menu/models/order.dart';
import 'package:trilicious_menu/notifiers/order_notifier.dart';
import 'package:trilicious_menu/notifiers/profile_notifier.dart';

// _uploadOrder(Order order, Function orderUploaded) async {
//   CollectionReference orderRef = FirebaseFirestore.instance.collection('orders');
//     order.orderedAt = Timestamp.now();

//     DocumentReference documentRef = await orderRef.add(order.toMap());

//     order.id = documentRef.id;

//     print('uploaded order successfully: ${order.toString()}');

//     await documentRef.set(order.toMap());

//     orderUploaded(order);
// }

uploadOrder(Order order,Function orderUploaded, OrderNotifier orderNotifier,ProfileNotifier profileNotifier,BuildContext context) async {
  // OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context,listen:false);
  // orderNotifier.allOrderList = Provider.of<List<Order>>(context,listen: false);
  // print(orderNotifier.allOrderList);
  final orderId = await countOrders(profileNotifier);
  print(orderId);
  var orderDate = DateFormat('dd-M-y').format(DateTime.now());
  CollectionReference orderRef =
      FirebaseFirestore.instance.collection('order').doc(profileNotifier.currentId).collection('date').doc(orderDate).collection('orders');
  order.orderedAt = Timestamp.now();

  // DocumentReference documentRef = await orderRef.add(order.toMap());

  order.id = orderId.toString();
  await orderRef.doc(orderId.toString()).set(order.toMap());

  print('uploaded order successfully: ${order.toString()}');
  orderUploaded(order);
}

Future<int> countOrders(ProfileNotifier profileNotifier)async{
  // ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context,);
  var orderDate = DateFormat('dd-M-y').format(DateTime.now());
    QuerySnapshot snap =  await FirebaseFirestore.instance
        .collection('order')
        .doc(profileNotifier.currentId)
        .collection('date')
        .doc(orderDate)
        .collection('orders')
        .get();
        return snap.size+1;
        // .snapshots()
        // .map((QuerySnapshot snapshot) =>
        //     snapshot.docs.map((doc) => Order.fromMap(doc.data())).toList());
  }

// deleteorder(order order, Function orderDeleted) async {
//   if (order.image != null) {
//     StorageReference storageReference =
//         await FirebaseStorage.instance.getReferenceFromUrl(order.image);

//     print(storageReference.path);

//     await storageReference.delete();

//     print('image deleted');
//   }

//   await Firestore.instance.collection('orders').document(order.id).delete();
//   orderDeleted(order);
// }