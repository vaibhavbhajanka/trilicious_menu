import 'package:cloud_firestore/cloud_firestore.dart';

class Order{
  String? id;
  // String? orderType;
  List<String>items;
  bool? isCompleted;
  Map<String,int> price;
  Map<String,int> quantity;
  double bill=0;
  double discount=0;
  double totalBill=0;
  int totalQuantity=0;
  Timestamp? orderedAt;

  Order({this.id,required this.items,required this.price,required this.isCompleted,required this.quantity,required this.bill,required this.discount,required this.totalBill,required this.totalQuantity,this.orderedAt});
  factory Order.fromMap(map){
    return Order(
      id:map['id'],
      items:map['items'].cast<String>(),
      quantity:map['quantity'].cast<String,int>(),
      price:map['price'].cast<String,int>(),
      isCompleted: map['isCompleted'],
      bill:double.parse(map['bill'].toString()),
      discount: double.parse(map['discount'].toString()),
      totalBill: double.parse(map['totalBill'].toString()),
      totalQuantity:map['totalQuantity'],
      orderedAt: map['orderedAt'] as Timestamp
    );
  }
  Map<String,dynamic> toMap(){
    return{
      'id':id,
      // 'orderType':orderType,
      'items':items,
      'quantity':quantity,
      'isCompleted':isCompleted,
      'price':price,
      'bill':bill,
      'discount':discount,
      'totalBill':totalBill,
      'totalQuantity':totalQuantity,
      'orderedAt':orderedAt
    };
  }
}