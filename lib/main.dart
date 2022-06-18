import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trilicious_menu/menu.dart';
import 'package:trilicious_menu/home.dart';
import 'package:trilicious_menu/notifiers/menu_item_notifier.dart';
import 'package:trilicious_menu/notifiers/order_notifier.dart';
import 'package:trilicious_menu/qsr_menu.dart';
import 'package:trilicious_menu/cart.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuItemNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderNotifier(),
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
      initialRoute: 'home_screen',
      routes: {
        'home_screen': (context) => const HomeScreen(),
        'menu_screen': (context) => const MenuScreen(),
        'qsr_menu_screen': (context) => const QsrMenuScreen(),
        'cart_screen': (context) => const CartScreen(),
      },
    );
  }
}
