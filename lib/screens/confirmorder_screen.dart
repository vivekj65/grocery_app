import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/main.dart';
import 'package:grocery_apk/models/cart_items.dart';
import 'package:grocery_apk/models/shipping_address.dart';
import 'package:grocery_apk/models/order.dart';
import 'package:grocery_apk/screens/order_placed_screen.dart';
import 'package:grocery_apk/themes/theme_colors.dart';
import 'package:grocery_apk/widget/confirm_order_card.dart';
import 'package:uuid/uuid.dart';

class ConfirmOrderScreen extends StatefulWidget {
  ConfirmOrderScreen({
    required this.selectedAddress,
    required this.cartItems,
    required this.totalPrice,
  });

  final ShippingAddress? selectedAddress;
  final List<CartItem> cartItems;
  final totalPrice;

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  Future<void> createAndSaveOrder() async {
    DateTime orderDate = DateTime.now();
    final uid = APIs.auth.currentUser!.uid;
    var uuid = Uuid();
    Orders newOrder = Orders(
      userId: uid,
      items: widget.cartItems,
      shippingAddress: ShippingAddress(
        name: widget.selectedAddress!.name,
        id: widget.selectedAddress!.id,
        streetAddress: widget.selectedAddress!.streetAddress,
        city: widget.selectedAddress!.city,
        state: widget.selectedAddress!.state,
        postalCode: widget.selectedAddress!.postalCode,
        phoneNo: widget.selectedAddress!.phoneNo,
      ),
      orderDate: orderDate,
      totalPrice: widget.totalPrice,
      is_delivered: false,
      orderId: uuid.v4(),
    );
    log('widget.cartItems: ${widget.cartItems}');
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(uid)
        .collection('user_orders')
        .doc()
        .set(newOrder.toMap());

    await FirebaseFirestore.instance
        .collection('carts')
        .doc(uid)
        .collection('cartItems')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Order',
          style: TextStyle(
            fontFamily: 'Sarala',
            color: HashColorCodes.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: HashColorCodes.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('carts')
                  .doc(APIs.auth.currentUser!.uid)
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
                  return Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final cartItem = items[index];
                        return ConfirmOrderCard(
                          item: cartItem,
                        );
                      },
                    ),
                  );
                }
              },
            ),
            InkWell(
              onTap: () {
                createAndSaveOrder().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) {
                        return OrderplacedScreen();
                      },
                    ),
                    (route) => false, // This condition will always return false
                  );
                });
              },
              child: Container(
                height: mq.height * .07,
                width: screenWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: HashColorCodes.green),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Confirm Order",
                    style: TextStyle(
                      color: HashColorCodes.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
