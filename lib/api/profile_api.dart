import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trilicious_menu/models/restaurant.dart';
import 'package:trilicious_menu/notifiers/profile_notifier.dart';

getProfile(ProfileNotifier profileNotifier) async {
  // User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('restaurants').doc('abc@gmail.com').get();
  print(snapshot.data());
  if (snapshot.exists) {
    Restaurant restaurant = Restaurant.fromMap(snapshot.data());
    profileNotifier.currentRestaurant = restaurant;
  }
  print(profileNotifier.currentRestaurant);
}