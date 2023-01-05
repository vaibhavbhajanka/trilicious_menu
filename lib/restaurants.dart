import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_menu/models/restaurant.dart';
import 'package:trilicious_menu/notifiers/profile_notifier.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.zero,
          child: Center(
            child: Image(
              image: AssetImage("images/logo2.png"),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),
        flexibleSpace: Container(
          // height: 10,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFCBC18), Color(0xFFFF971E)],
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('restaurants').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Restaurant restaurant =
                        Restaurant.fromMap(snapshot.data!.docs[index]);
                    return GestureDetector(
                      onTap: () {
                        profileNotifier.currentId = restaurant.id;
                        Navigator.pushNamed(context, '/menu_screen');
                      },
                      child: (Padding(
                        padding: EdgeInsets.all(8),
                        child: (Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            leading: Image.network(
                                restaurant.profileImage.toString()),
                            title: Text(restaurant.name.toString()),
                            subtitle: Text(
                              restaurant.address.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        )),
                      )),
                    );
                  },
                )
              : Center(
                  child: Text('No Restaurants'),
                );
        },
      ),
    );
  }
}
