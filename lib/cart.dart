import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_menu/api/order_api.dart';
import 'package:trilicious_menu/models/food_item.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:trilicious_menu/models/food_item.dart';
import 'package:trilicious_menu/models/order.dart';
import 'package:trilicious_menu/notifiers/cart_notifier.dart';
import 'package:trilicious_menu/notifiers/food_item_notifier.dart';
// import 'package:trilicious_food/notifiers/order_notifier.dart';
// import 'package:trilicious_menu/api/order_api.dart';
import 'package:trilicious_menu/notifiers/order_notifier.dart';
// import 'package:trilicious_menu/payment.dart';
import 'package:trilicious_menu/widgets/glass_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // late Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleErrorFailure);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _razorpay.clear();
  // }

  // void openCheckout(CartNotifier cartNotifier, String OrderId) {
  //   var options = {
  //     'key': 'rzp_test_3CN6aDtmrAAsyR',
  //     'amount': (cartNotifier.totalBill * 100)
  //         .toString(), //in the smallest currency sub-unit.
  //     'name': 'Pizza Central',
  //     'order_id': OrderId,
  //     // 'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
  //     'description': 'Demo',
  //     'timeout': 300, // in seconds
  //     'prefill': {'contact': '9365097092', 'email': 'vaibhavbhajanka@gmail.com'}
  //   };
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  _onOrderUploaded(Order order) {
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    orderNotifier.currentOrder = order;
    // if (foodItem.updatedAt == null) {
    //   foodItemNotifier.addfoodItem(foodItem);
    // }
    cartNotifier.emptyCart();
    Navigator.pop(context);
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   print('Success Response: $response');

  // }

  // void _handleErrorFailure(PaymentFailureResponse response) {
  //   print('Error Response: $response');
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   print('External SDK Response: $response');
  // }

  @override
  Widget build(BuildContext context) {
    FoodItemNotifier foodItemNotifier = Provider.of<FoodItemNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
          color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Image(
          image: AssetImage("images/logo2.png"),
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
            SizedBox(height: size.height * 0.04),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("restaurants")
                    .doc('abc@gmail.com')
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  return snapshot.hasData
                      ? Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 5 / 2,
                              child: Image.network(
                                snapshot.data?['coverImage'] ??
                                    'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: size.height*0.03),
                              child: Center(
                                child: GlassCard(
                                  image: snapshot.data?['profileImage'],
                                  restaurantName: snapshot.data?['name'] ?? '',
                                  restaurantAddress:
                                      snapshot.data?['address'] ?? '',
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container();
                  // Restaurant _restaurant = Restaurant.fromMap(snapshot);
                  // profileNotifier.currentRestaurant = _restaurant;
                }),
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
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: cartNotifier.itemList.length,
              itemBuilder: (BuildContext context, int index) {
                FoodItem foodItem = cartNotifier.itemList[index];
                return CartItem(
                  itemName: foodItem.itemName ?? '',
                  price: int.parse(
                      cartNotifier.price[foodItem.itemName].toString()),
                  quantity: int.parse(
                      cartNotifier.quantity[foodItem.itemName].toString()),
                  onDecrement: () {
                    foodItemNotifier.currentFoodItem = foodItem;
                    // foodItemNotifier
                    //     .findFoodItem(foodItem, foodItemNotifier);
                    // setState(() {
                    cartNotifier
                        .decrementQuantity(foodItemNotifier.currentFoodItem);
                    // });
                  },
                  onIncrement: () {
                    foodItemNotifier.currentFoodItem = foodItem;
                    // setState(() {
                    cartNotifier
                        .incrementQuantity(foodItemNotifier.currentFoodItem);
                    // });
                  },
                );
              },
            ),
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
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        '\u{20B9}${cartNotifier.bill}',
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
                        '-\u{20B9}${cartNotifier.discount}',
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
                        '\u{20B9}${cartNotifier.totalBill}',
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        CartNotifier cartNotifier =
                            Provider.of<CartNotifier>(context, listen: false);
                        OrderNotifier orderNotifier =
                            Provider.of<OrderNotifier>(context, listen: false);
                        Order _currentOrder = Order(
                            bill: 0,
                            discount: 0,
                            totalBill: 0,
                            totalQuantity: 0,
                            items: [],
                            price: {},
                            quantity: {},
                            isCompleted: false);
                        _currentOrder.items = cartNotifier.itemList
                            .map((e) => e.itemName as String)
                            .toList();
                        _currentOrder.quantity = cartNotifier.quantity;
                        _currentOrder.price = cartNotifier.price;
                        _currentOrder.bill = cartNotifier.bill;
                        _currentOrder.discount = cartNotifier.discount;
                        _currentOrder.totalBill = cartNotifier.totalBill;
                        _currentOrder.totalQuantity =
                            cartNotifier.totalQuantity;
                        // print(_currentOrder);
                        uploadOrder(_currentOrder, _onOrderUploaded,
                            orderNotifier, context);
                        // generateOrderId(
                        //         'rzp_test_3CN6aDtmrAAsyR',
                        //         'zADZBfnX3azVS8e2y3xFftKi',
                        //         int.parse((cartNotifier.totalBill.floor() * 100)
                        //             .toString()))
                        //     .then((value) {
                        //   openCheckout(cartNotifier, value);
                        // });
                        // Navigator.pushNamed(context, '/upi');
                        // Navigator.pop(context);
                      },
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
              flex: 3,
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
              flex: 2,
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
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
                child: Container(
                  // margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: onDecrement,
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: onIncrement,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
