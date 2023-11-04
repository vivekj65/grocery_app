import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/models/order.dart';
import 'package:grocery_apk/themes/theme_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_apk/widget/my_order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Stream<QuerySnapshot> getOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .doc(APIs.auth.currentUser!.uid)
        .collection('user_orders')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HashColorCodes.green,
        title: Text(
          "My Orders",
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
          stream: getOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No Orders Placed yet'));
            } else {
              final items = snapshot.data!.docs.map((document) {
                final itemData = document.data() as Map<String, dynamic>;
                return Orders.fromMap(itemData);
              }).toList();

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return MyOrdersCard(orders: item);
                },
              );
            }
          },
        ),
    );
  }
}
