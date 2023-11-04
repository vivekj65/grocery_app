import 'package:flutter/material.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/main.dart';
import 'package:grocery_apk/models/cart_items.dart';
import 'package:grocery_apk/screens/address_screen.dart';
import 'package:grocery_apk/themes/theme_colors.dart';
import 'package:grocery_apk/widget/cart_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final String userId = APIs.auth.currentUser!.uid;

  void increaseItemCount(CartItem item) {
    setState(() {
      item.quantity++;
      FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection('cartItems')
          .doc(item.cartItemId)
          .update({'quantity': item.quantity});
    });
  }

  void decreaseItemCount(CartItem item) {
    setState(() {
      if (item.quantity > 0) {
        item.quantity--;

        FirebaseFirestore.instance
            .collection('carts')
            .doc(userId)
            .collection('cartItems')
            .doc(item.cartItemId)
            .update({'quantity': item.quantity});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HashColorCodes.screenGrey,
      appBar: AppBar(
        backgroundColor: HashColorCodes.green,
        title: Text(
          "My Cart ",
          style: TextStyle(
            fontFamily: 'Sarala',
            color: HashColorCodes.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.bell_fill,
              color: HashColorCodes.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('carts')
            .doc(userId)
            .collection('cartItems')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items in the cart.'));
          } else {
            final items = snapshot.data!.docs.map((document) {
              final itemData = document.data() as Map<String, dynamic>;
              return CartItem.fromMap(itemData);
            }).toList();

            double totalPrice = 0.0;
            for (final item in items) {
              totalPrice += item.price * item.quantity;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return CartCard(
                        item: item,
                        onIncrease: () {
                          increaseItemCount(item);
                        },
                        onDecrease: () {
                          decreaseItemCount(item);
                        },
                      );
                    },
                  ),
                ),
                Container(
                  color: HashColorCodes.white,
                  height: mq.height * .12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Price",
                          style: TextStyle(
                            color: HashColorCodes.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rs $totalPrice",
                              style: TextStyle(
                                color: HashColorCodes.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AddressScreen(
                                            isNavigatedFromCartScreen: true,
                                            totalprice: totalPrice,
                                            jsonitem: items)));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HashColorCodes.green,
                              ),
                              child: Text(
                                "Buy Now",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: HashColorCodes.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
