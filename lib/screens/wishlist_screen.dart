import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_apk/models/wishlist.dart';
import 'package:grocery_apk/themes/theme_colors.dart';
import 'package:grocery_apk/widget/wishlist_card.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:flutter/cupertino.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  final String userId = APIs.auth.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HashColorCodes.green,
        title: Text(
          "Wishlist",
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
        stream: APIs.getWishlist(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items in the wishlist.'));
          } else {
            final items = snapshot.data!.docs.map((document) {
              final itemData = document.data() as Map<String, dynamic>;
              return WishlistItem.fromJson(itemData);
            }).toList();

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return WishlistCard(
                  item: item,
                );
              },
            );
          }
        },
      ),
    );
  }
}
