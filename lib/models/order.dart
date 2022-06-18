import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trilicious_menu/models/menu_item.dart';

class Order{
  String? id;
  List<MenuItem>? items;
  Map<MenuItem,int>? quantities;
  double bill=0;
  double discount=0;
  double totalBill=0;
  Timestamp? orderedAt;

  Order({this.id,this.items,this.quantities,required this.bill,required this.discount,required this.totalBill,this.orderedAt});

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'items':items,
      'quantities':quantities,
      'bill':bill,
      'discount':discount,
      'totalBill':totalBill,
      'orderedAt':orderedAt
    };
  }
}