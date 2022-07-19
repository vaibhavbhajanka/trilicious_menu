import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';
import 'package:trilicious_menu/api/food_item_api.dart';
import 'package:trilicious_menu/api/profile_api.dart';
import 'package:trilicious_menu/item_detail_screen.dart';
import 'package:trilicious_menu/models/food_item.dart';
import 'package:trilicious_menu/models/order.dart';
// import 'package:trilicious_menu/models/restaurant.dart';
import 'package:trilicious_menu/notifiers/food_item_notifier.dart';
import 'package:trilicious_menu/notifiers/cart_notifier.dart';
import 'package:trilicious_menu/notifiers/order_notifier.dart';
import 'package:trilicious_menu/notifiers/profile_notifier.dart';
import 'package:trilicious_menu/widgets/glass_card.dart';
import 'package:trilicious_menu/widgets/gradient_text.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Order? _currentOrder;
  @override
  void initState() {
    super.initState();
    FoodItemNotifier foodItemNotifier =
        Provider.of<FoodItemNotifier>(context, listen: false);
    ProfileNotifier profileNotifier =
        Provider.of<ProfileNotifier>(context, listen: false);
    getProfile(profileNotifier);
    getCategories(foodItemNotifier).then((value) {
      getFoodItems(foodItemNotifier);
      foodItemNotifier.currentCategory = foodItemNotifier.categoryList[0];
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    FoodItemNotifier foodItemNotifier =
        Provider.of<FoodItemNotifier>(context, listen: false);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    foodItemNotifier.allFoodItemList = Provider.of<List<FoodItem>>(context);
    orderNotifier.allOrderList = Provider.of<List<Order>>(context);
    print(foodItemNotifier.allFoodItemList);
    super.didChangeDependencies();
  }

  List<String> orderTypes = ['Take-away', 'Dine-in'];
  String? selectedType = 'Dine-in';

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FoodItemNotifier foodItemNotifier = Provider.of<FoodItemNotifier>(context);
    // OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);

    Future<void> _refreshList() async {
      getCategories(foodItemNotifier).then((value) {
        getFoodItems(foodItemNotifier);
        // foodItemNotifier.currentCategory=foodItemNotifier.categoryList[0];
      });
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        // extendBody: true,
        extendBodyBehindAppBar: true,
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
        body: Stack(children: [
          Column(children: [
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
                              aspectRatio: 5 / 3,
                              child: Image.network(
                                snapshot.data?['coverImage'] ??
                                    'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 80),
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
            // Row(
            //   children: [
            //     const Expanded(
            //       flex: 5,
            //       child: Card(
            //         child: ListTile(
            //           leading: Icon(Icons.search),
            //           title: TextField(
            //             decoration: InputDecoration(
            //               hintText: 'Search',
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       flex: 2,
            //           child: Card(
            // child: DropdownButtonFormField<String>(
            //   value: selectedType,
            //   items: orderTypes
            //       .map(
            //         (item) => DropdownMenuItem<String>(
            //           value: item,
            //           child: Text(item),
            //         ),
            //       )
            //       .toList(),
            //   onChanged: (item) =>
            //       setState(() => selectedType = item),
            // ),
            //           ),
            //         ),
            //   ],
            // ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('menu')
                    .doc('category')
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  List<String> _categories =
                      snapshot.data?['categories'].cast<String>();
                  return snapshot.hasData
                      ? Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xffffa800),
                                      Color(0xffffc700),
                                    ]),
                              ),
                              child: Row(
                                children: [
                                  // CategoryButton(category: 'all', onPressed: onPressed, isSelected: isSelected
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: _categories.length,
                                        // reverse: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return CategoryButton(
                                            category: _categories[index],
                                            onPressed: () {
                                              foodItemNotifier.currentCategory =
                                                  _categories[index];
                                              foodItemNotifier.foodItemList =
                                                  foodItemNotifier.foodItemMap[
                                                          foodItemNotifier
                                                              .currentCategory
                                                              .toString()] ??
                                                      [];
                                              print(foodItemNotifier
                                                  .foodItemList);
                                            },
                                            isSelected: foodItemNotifier
                                                    .currentCategory ==
                                                _categories[index],
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container();
                }),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('menu')
                    .doc(foodItemNotifier.currentCategory)
                    .collection('menuItems')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  print(snapshot.data?.docs);
                  // List<FoodItem> _items =
                  //       FoodItem.fromMap(snapshot.data?.docs) as List<FoodItem>;
                  // print(_items);
                  return snapshot.hasData
                      ? Flexible(
                          flex: 7,
                          child: ListView.builder(
                            // shrinkWrap: true,
                            // reverse: true,
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              FoodItem foodItem =
                                  FoodItem.fromMap(snapshot.data!.docs[index]);

                              return foodItem.isAvailable ?? false
                                  ? ItemCard(
                                      image: foodItem.image.toString(),
                                      itemName: foodItem.itemName.toString(),
                                      description:
                                          foodItem.description.toString(),
                                      price:
                                          int.parse(foodItem.price.toString()),
                                      quantity: cartNotifier
                                              .quantity[foodItem.itemName] ??
                                          0,
                                      onTap: () {
                                        foodItemNotifier.currentFoodItem =
                                            FoodItem.fromMap(
                                                snapshot.data?.docs[index]);
                                        cartNotifier.addItem(
                                            foodItemNotifier.currentFoodItem);
                                      },
                                      onDecrement: () {
                                        foodItemNotifier.currentFoodItem =
                                            FoodItem.fromMap(
                                                snapshot.data?.docs[index]);
                                        cartNotifier.decrementQuantity(
                                            foodItemNotifier.currentFoodItem);
                                      },
                                      onIncrement: () {
                                        foodItemNotifier.currentFoodItem =
                                            FoodItem.fromMap(
                                                snapshot.data?.docs[index]);
                                        cartNotifier.incrementQuantity(
                                            foodItemNotifier.currentFoodItem);
                                      },
                                      onCardPressed: () {
                                        foodItemNotifier.currentFoodItem =
                                            FoodItem.fromMap(
                                                snapshot.data?.docs[index]);
                                        showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) =>
                                                const ItemDetailScreen());
                                      })
                                  : DisabledCard(
                                      image: foodItem.image.toString(),
                                      itemName: foodItem.itemName.toString(),
                                      description:
                                          foodItem.description.toString(),
                                      price: foodItem.price ?? 0,
                                      onCardPressed: () {
                                        foodItemNotifier.currentFoodItem =
                                            FoodItem.fromMap(
                                                snapshot.data?.docs[index]);
                                        showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) =>
                                                const ItemDetailScreen());
                                      });
                            },
                          ),
                        )
                      : const Flexible(
                          flex: 7,
                          child: Center(
                            child: Text('No Items in this category'),
                          ));
                }),
            cartNotifier.itemList.isEmpty
                ? Container()
                : GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/cart_screen'),
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
                                  '${cartNotifier.totalQuantity} Item Added',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Total: \u{20B9}${cartNotifier.bill}',
                                  style: const TextStyle(
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
        ]));
  }
}
// Flexible(
//               child: ScrollableListTabView(
//                 tabs: [
//                   for(String category in foodItemNotifier.foodItemMap.keys)
//                     ScrollableListTab(
//                       tab: ListTab(
//                         label: Text(category,
//                         style: TextStyle(fontSize: 20),),
//                         activeBackgroundColor: Colors.orange,
//                       ),
//                       body: ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: foodItemNotifier.foodItemMap[category]?.length,
//                         itemBuilder: (BuildContext context,int index){
//                           FoodItem foodItem = foodItemNotifier.foodItemMap[category]![index];
//                                     // FoodItem.fromMap(snapshot.data!.docs[index]);

//                                 return foodItem.isAvailable ?? false
//                                     ? ItemCard(
//                                         image: foodItem.image.toString(),
//                                         itemName: foodItem.itemName.toString(),
//                                         description:
//                                             foodItem.description.toString(),
//                                         price:
//                                             int.parse(foodItem.price.toString()),
//                                         quantity: cartNotifier
//                                                 .quantity[foodItem.itemName] ??
//                                             0,
//                                         onTap: () {
//                                           // foodItemNotifier.currentFoodItem =
//                                           //     FoodItem.fromMap(
//                                           //         snapshot.data?.docs[index]);
//                                           cartNotifier.addItem(
//                                               foodItemNotifier.currentFoodItem);
//                                         },
//                                         onDecrement: () {
//                                           // foodItemNotifier.currentFoodItem =
//                                           //     FoodItem.fromMap(
//                                           //         snapshot.data?.docs[index]);
//                                           cartNotifier.decrementQuantity(
//                                               foodItemNotifier.currentFoodItem);
//                                         },
//                                         onIncrement: () {
//                                           // foodItemNotifier.currentFoodItem =
//                                           //     FoodItem.fromMap(
//                                           //         snapshot.data?.docs[index]);
//                                           cartNotifier.incrementQuantity(
//                                               foodItemNotifier.currentFoodItem);
//                                         },
//                                         onCardPressed: () {
//                                           // foodItemNotifier.currentFoodItem =
//                                           //     FoodItem.fromMap(
//                                           //         snapshot.data?.docs[index]);
//                                           showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (context) =>
//                                                   const ItemDetailScreen());
//                                         })
//                                     : DisabledCard(
//                                         image: foodItem.image.toString(),
//                                         itemName: foodItem.itemName.toString(),
//                                         description:
//                                             foodItem.description.toString(),
//                                         price: foodItem.price ?? 0,
//                                         onCardPressed: () {
//                                           // foodItemNotifier.currentFoodItem =
//                                           //     FoodItem.fromMap(
//                                           //         snapshot.data?.docs[index]);
//                                           showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (context) =>
//                                                   const ItemDetailScreen());
//                                         });
//                         },
//                       )
//                     )

//                 ],
//               ),
//             )
//           ],
//         ),

class CategoryButton extends StatelessWidget {
  final String category;
  final VoidCallback onPressed;
  final bool isSelected;
  const CategoryButton(
      {Key? key,
      required this.category,
      required this.onPressed,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(category),
        style: OutlinedButton.styleFrom(
          // backgroundColor: Colors.white,
          primary: isSelected ? Colors.black : Colors.white,
          backgroundColor: isSelected ? Colors.white : Colors.transparent,
          side: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
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
  final void Function() onCardPressed;
  final void Function() onTap;
  // final foodItem? currentfoodItem;
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
    required this.onCardPressed,
    required this.onTap,
    required this.onDecrement,
    required this.onIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onCardPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
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
                    image ?? 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                         Color(0xffffc700),
                                         Color(0xffff8a00),
                                      ]),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                              )
                            : OutlineGradientButton(
                                strokeWidth: 2,
                                radius: const Radius.circular(20),
                                gradient: const LinearGradient(colors: [
                                  Color(0xffffc700),
                                  Color(0xffff8a00),
                                ]),
                                onTap: onTap,
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
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisabledCard extends StatelessWidget {
  final String image;
  final String itemName;
  final String description;
  final int price;
  final void Function() onCardPressed;

  const DisabledCard({
    Key? key,
    required this.image,
    required this.itemName,
    required this.description,
    required this.price,
    required this.onCardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        Colors.grey,
        BlendMode.saturation,
      ),
      child: GestureDetector(
        onTap: onCardPressed,
        child: Card(
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
                    image ?? 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
