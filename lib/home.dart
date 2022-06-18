import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: (){
              Navigator.pushNamed(context, 'qsr_menu_screen');
            },
            child: const Text('Unorganized Menu'),
          ),
          // TextButton(
          //   onPressed: (){
          //     Navigator.pushNamed(context, 'menu_screen');
          //   },
          //   child: const Text('Organized Menu'),
          // ),
          TextButton(
            onPressed: (){
              Navigator.pushNamed(context, 'cart_screen');
            },
            child: const Text('CART'),
          ),
        ],
      ),
    );
  }
}
