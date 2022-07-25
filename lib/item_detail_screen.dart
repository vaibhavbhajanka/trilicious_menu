import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_menu/models/food_item.dart';
import 'package:trilicious_menu/notifiers/cart_notifier.dart';
import 'package:trilicious_menu/notifiers/food_item_notifier.dart';
import 'package:trilicious_menu/notifiers/profile_notifier.dart';
import 'package:trilicious_menu/widgets/gradient_text.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({Key? key}) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    FoodItemNotifier foodItemNotifier = Provider.of<FoodItemNotifier>(context);
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    FoodItem currentItem = foodItemNotifier.currentFoodItem;
    int quantity = cartNotifier.quantity[currentItem.itemName] ?? 0;
    List<String> itemOptions = ['Options', 'Coming Soon'];
    String? selectedOption = 'Options';
    List<String> itemAddOns = ['Add-Ons', 'Coming Soon'];
    String? selectedAddOn = 'Add-Ons';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Column(
            children: [
              Expanded(
                // flex: 3,
                child: AspectRatio(
                  aspectRatio: 7 / 8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        currentItem.image ??
                            'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                // flex:2,
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                currentItem.itemName ?? '',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            currentItem.isAvailable==true?
                            Expanded(
                              flex: 1,
                              child: quantity > 0
                                  ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: IconButton(
                                              onPressed: () {
                                                foodItemNotifier.currentFoodItem =
                                                    cartNotifier.findFoodItem(currentItem,cartNotifier);
                                                cartNotifier.decrementQuantity(
                                                    foodItemNotifier.currentFoodItem);
                                              },
                                              icon: const Icon(Icons.remove,
                                              color: Colors.white,),
                                            ),
                                          ),
                                          Text(quantity.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),),
                                          Expanded(
                                            child: IconButton(
                                              onPressed: () {
                                                foodItemNotifier.currentFoodItem =
                                                    cartNotifier.findFoodItem(currentItem,cartNotifier);
                                                cartNotifier.incrementQuantity(
                                                    foodItemNotifier.currentFoodItem);
                                              },
                                              icon: const Icon(Icons.add,
                                              color: Colors.white,),
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
                                      onTap: () {
                                        cartNotifier.addItem(foodItemNotifier.currentFoodItem);
                                      },
                                    ),
                            ):Container(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xffffc700),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: DropdownButton<String>(
                                    underline: Container(),
                                    value: selectedOption,
                                    items: itemOptions
                                        .map(
                                          (item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(item),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (item) =>
                                        setState(() => selectedOption = item),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xffffc700),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: DropdownButton<String>(
                                    underline: Container(),
                                    value: selectedAddOn,
                                    items: itemAddOns
                                        .map(
                                          (item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(item),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (item) =>
                                        setState(() => selectedAddOn = item),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffd9d9d9),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: const Text(
                                'Description',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle:
                                  Text(currentItem.description.toString()),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(60, 40, 60, 0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xffffc700),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children:const [
                                    Text(
                                      'Rating',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom:15.0),
                                      child: Text(
                                        'Coming',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 2,
                                  child: Container(color: Colors.white54),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: const[
                                    Text(
                                      'kCal',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom:15.0),
                                      child: Text(
                                        'Soon',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
