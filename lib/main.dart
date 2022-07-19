import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trilicious_menu/api/food_item_api.dart';
import 'package:trilicious_menu/api/order_api.dart';
import 'package:trilicious_menu/fmenu.dart';
import 'package:trilicious_menu/login.dart';
import 'package:trilicious_menu/models/food_item.dart';
import 'package:trilicious_menu/models/order.dart';
import 'package:trilicious_menu/notifiers/cart_notifier.dart';
import 'package:trilicious_menu/notifiers/food_item_notifier.dart';
import 'package:trilicious_menu/notifiers/order_notifier.dart';
import 'package:trilicious_menu/menu.dart';
import 'package:trilicious_menu/cart.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_menu/notifiers/profile_notifier.dart';
import 'package:trilicious_menu/upi.dart';
import 'package:trilicious_menu/upi2.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyDdGzjVuU2JwQoxgl_NqyxxcSR5ma6kKMM',
        appId: '1:1082364642390:android:0a6a99ddd145d2950b27f7',
        messagingSenderId: '1082364642390',
        projectId: 'trilicious-a9b87'),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProfileNotifier(),
        ),
        StreamProvider<List<FoodItem>>.value(value: allFoodItems, initialData: const [],),
        StreamProvider<List<Order>>.value(value: allOrderList, initialData: const [],),
        // StreamProvider(create: create, initialData: initialData),
        ChangeNotifierProvider(
          create: (context) => FoodItemNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartNotifier(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/menu_screen',
      routes: {
        '/menu_screen': (context) => const MenuScreen(),
        '/fmenu':(ctx) => FMenu(),
        '/cart_screen': (context) => const CartScreen(),
        '/login': (ctx) => const LoginScreen(),
        '/upi':(ctx) => const UpiPayment(),
      },
    );
  }
}
