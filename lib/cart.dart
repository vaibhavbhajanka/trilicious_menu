import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_menu/notifiers/menu_item_notifier.dart';
import 'package:trilicious_menu/notifiers/order_notifier.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    MenuItemNotifier menuItemNotifier =
        Provider.of<MenuItemNotifier>(context, listen: false);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    // getMenuItems(menuItemNotifier);
    super.initState();
    // print(orderNotifier.orderList);
  }

  @override
  Widget build(BuildContext context) {
    MenuItemNotifier menuItemNotifier = Provider.of<MenuItemNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Center(
            child: Image(
              image: AssetImage("images/logo.png"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.075),
            const Image(
              image: AssetImage('images/cover.png'),
            ),
            SizedBox(height: size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  'Items',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 17,
                  ),
                ),
                Text(
                  'Price',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 17,
                  ),
                ),
                Text(
                  'Quantity',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              // reverse: true,
              // separatorBuilder: (BuildContext context, int index) {
              //   return const SizedBox(
              //     width: 0,
              //     height: 0,
              //   );
              // },
              itemCount: orderNotifier.currentOrder?.items?.length,
              itemBuilder: (BuildContext context, int index) {
                return CartItem(
                  itemName:
                      orderNotifier.currentOrder?.items?[index].itemName.toString() ?? '',
                  price: int.parse(
                      orderNotifier.currentOrder?.items?[index].price.toString() ?? '0'),
                  quantity: ,
                  onDecrement: () {
                    menuItemNotifier.currentMenuItem =
                        menuItemNotifier.menuItemList[index];
                    setState(() {
                      orderNotifier
                          .decrementQuantity(menuItemNotifier.currentMenuItem);
                    });
                  },
                  onIncrement: () {
                    menuItemNotifier.currentMenuItem =
                        menuItemNotifier.menuItemList[index];
                    setState(() {
                      orderNotifier
                          .incrementQuantity(menuItemNotifier.currentMenuItem);
                    });
                  },
                );
              },
            ),
            // CartItem(
            //       itemName:
            //           orderNotifier.orderList[0]?.itemName.toString()??'',
            //       price: int.parse(orderNotifier.orderList[0]?.price.toString()??'0'),
            //       quantity: int.parse(orderNotifier.quantities[orderNotifier.orderList[0]].toString()),
            //     ),
            // CartItem(
            //       itemName:
            //           orderNotifier.orderList[1]?.itemName.toString()??'',
            //       price: int.parse(orderNotifier.orderList[1]?.price.toString()??'0'),
            //       quantity: int.parse(orderNotifier.quantities[orderNotifier.orderList[1]].toString()),
            //     ),
            // const CartItem(),
            // const CartItem(),
            // const CartItem(),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order:',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        '\u{20B9}${orderNotifier.totalBill}',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Discount:',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        '-\u{20B9}${0.15 * orderNotifier.totalBill}',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Order:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        '\u{20B9}${orderNotifier.totalBill - 0.15 * orderNotifier.totalBill}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Continue to Checkout',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String itemName;
  final int price;
  final int quantity;
  final void Function() onIncrement;
  final void Function() onDecrement;
  const CartItem({
    Key? key,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Card(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            // const SizedBox(
            //   width: 14,
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '\u{20B9}$price',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            // const SizedBox(
            //   width: 60,
            // ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 2),
                  child: Container(
                    color: Colors.orange,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: onDecrement,
                          icon: const Icon(Icons.remove),
                        ),
                        Text(quantity.toString()),
                        IconButton(
                          onPressed: onIncrement,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color(0xffffc700),
//                       Color(0xffff8a00),
//                     ],
//                   ),
//                 ),
//                 child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12.0, vertical: 2),
//                     child: Container(
//                       color: Colors.orange,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             onPressed: onDecrement,
//                             icon: const Icon(Icons.remove),
//                           ),
//                           Text(quantity.toString()),
//                           IconButton(
//                             onPressed: onIncrement,
//                             icon: const Icon(Icons.add),
//                           ),
//                         ],
//                       ),
//                     )),
//               ),
//             ),