import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_menu/api/menu_item_api.dart';
import 'package:trilicious_menu/models/menu_item.dart';
import 'package:trilicious_menu/models/order.dart';
import 'package:trilicious_menu/notifiers/menu_item_notifier.dart';
import 'package:trilicious_menu/notifiers/order_notifier.dart';

class QsrMenuScreen extends StatefulWidget {
  const QsrMenuScreen({Key? key}) : super(key: key);

  @override
  State<QsrMenuScreen> createState() => _QsrMenuScreenState();
}

class _QsrMenuScreenState extends State<QsrMenuScreen> {
  Order? _currentOrder;
  @override
  void initState() {
    super.initState();
    MenuItemNotifier menuItemNotifier =
        Provider.of<MenuItemNotifier>(context, listen: false);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    getMenuItems(menuItemNotifier);
    if (orderNotifier.currentOrder != null) {
      _currentOrder = orderNotifier.currentOrder;
    } else {
      _currentOrder = Order();
    }
    // print(orderNotifier.orderList);
  }

  @override
  Widget build(BuildContext context) {
    MenuItemNotifier menuItemNotifier = Provider.of<MenuItemNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

    Future<void> _refreshList() async {
      getMenuItems(menuItemNotifier);
    }

    _addToCart(MenuItem? menuItem) {
      OrderNotifier orderNotifier =
          Provider.of<OrderNotifier>(context, listen: false);
      // if (menuItem.updatedAt == null) {
      // orderNotifier.addMenuItem(menuItem);
      // }
      // Navigator.pop(context);
    }

    // _calculateTotal(List<MenuItem?> Order)

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
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
      body: Stack(children: [
        Column(
          children: [
            // SizedBox(height: size.height * 0.075),
            // const Image(
            //   image: AssetImage('images/cover.png'),
            // ),
            // SizedBox(height: size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: size.height * 0.62,
                    child: ListView.separated(
                      // shrinkWrap: true,
                      // reverse: true,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 0,
                          height: 0,
                        );
                      },
                      itemCount: menuItemNotifier.menuItemList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ItemCard(
                          image: menuItemNotifier.menuItemList[index].image
                              .toString(),
                          itemName: menuItemNotifier
                              .menuItemList[index].itemName
                              .toString(),
                          description: menuItemNotifier
                              .menuItemList[index].description
                              .toString(),
                          price: int.parse(menuItemNotifier
                              .menuItemList[index].price
                              .toString()),
                          quantity: orderNotifier.currentOrder?.quantities?[
                                  menuItemNotifier.menuItemList[index]] ??
                              0,
                          onTap: () {
                            menuItemNotifier.currentMenuItem =
                                menuItemNotifier.menuItemList[index];
                            // print(menuItemNotifier.currentMenuItem?.itemName);
                            _currentOrder?.items?.add(menuItemNotifier.currentMenuItem??MenuItem());
                            _currentOrder?.quantities?[menuItemNotifier.currentMenuItem??MenuItem()]=1;
                            _currentOrder?.bill+=menuItemNotifier.currentMenuItem?.price?.toDouble()??0;
                            _currentOrder?.discount=(0.15).toDouble()*(_currentOrder?.bill??0);
                            _currentOrder?.totalBill=(_currentOrder?.bill??0)-(_currentOrder?.discount??0);
                            // _addToCart(menuItemNotifier.currentMenuItem);
                          },
                          // currentMenuItem: menuItemNotifier.currentMenuItem
                          onDecrement: () {
                            menuItemNotifier.currentMenuItem =
                                menuItemNotifier.menuItemList[index];
                            setState(() {
                              
                            });
                          },
                          // onIncrement: () {
                          //   menuItemNotifier.currentMenuItem =
                          //       menuItemNotifier.menuItemList[index];
                          //   setState(() {
                          //     orderNotifier.incrementQuantity(
                          //         menuItemNotifier.currentMenuItem);
                          //   });
                          // },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        orderNotifier.orderList.length == 0
            ? Container()
            : GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'cart_screen'),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.orange,
                        height: size.height * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${orderNotifier.orderList.length} Item Added',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Total: \u{20B9}${orderNotifier.totalBill}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ),
      ]),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String image;
  final String itemName;
  final String description;
  final int price;
  final int quantity;
  // final bool isAdded;
  final void Function() onTap;
  // final MenuItem? currentMenuItem;
  final void Function() onIncrement;
  final void Function() onDecrement;
  const ItemCard({
    Key? key,
    required this.image,
    required this.itemName,
    required this.description,
    required this.price,
    required this.quantity,
    // required this.isAdded,
    required this.onTap,
    required this.onDecrement,
    required this.onIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.125,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image != null
                    ? image
                    : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    '\u{20B9}$price',
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: quantity > 0
                        ? Container(
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
                          )
                        : OutlineGradientButton(
                            strokeWidth: 2,
                            radius: const Radius.circular(20),
                            gradient: const LinearGradient(colors: [
                              Color(0xffffc700),
                              Color(0xffff8a00),
                            ]),
                            child: const Center(
                              child: GradientText(
                                text: 'Add',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                gradient: LinearGradient(colors: [
                                  Color(0xffff8a00),
                                  Color(0xffffc700),
                                ]),
                              ),
                            ),
                            onTap: onTap,
                          ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
      {Key? key, required this.text, this.style, required this.gradient})
      : super(key: key);

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
