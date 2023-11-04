import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/common/dialogs.dart';
import 'package:grocery_apk/main.dart';
import 'package:grocery_apk/models/cart_items.dart';
import 'package:grocery_apk/models/wishlist.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_apk/models/product.dart';
import 'package:grocery_apk/themes/theme_colors.dart';

class WishlistNotifier extends ChangeNotifier {
  List<String> _wishlistItems = [];

  List<String> get wishlistItems => _wishlistItems;

  void toggleWishlistItem(String productId, {bool remove = false}) {
    if (remove) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.add(productId);
    }
    notifyListeners();
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedQuantity = 1;
  int totalPrice = 0;
  int originalPrice = 0;
  bool isWishlist = false;

  @override
  void initState() {
    super.initState();
    originalPrice = widget.product.price;
    totalPrice = originalPrice;
    checkWishlist();
  }

  void toggleWishlist() {
    final wishlistNotifier =
        Provider.of<WishlistNotifier>(context, listen: false);
    final productId = widget.product.id;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      if (wishlistNotifier.wishlistItems.contains(productId)) {
        wishlistNotifier.toggleWishlistItem(productId, remove: true);
        removeFromFirestore(productId, userId);
      } else {
        wishlistNotifier.toggleWishlistItem(productId, remove: false);
        addToWishList(userId, productId);
      }
      setState(() {
        isWishlist = !isWishlist;
      });
    }
  }

  Future<void> checkWishlist() async {
    final productId = widget.product.id;

    final user = FirebaseAuth.instance.currentUser;

    CollectionReference wishlistCollection =
        FirebaseFirestore.instance.collection('wishlist');

    QuerySnapshot querySnapshot = await wishlistCollection
        .where('productId', isEqualTo: productId)
        .where('userId', isEqualTo: user!.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        isWishlist = true;
      });
    } else {
      setState(() {
        isWishlist = false;
      });
    }
  }

  Future<void> addToWishList(String userId, String productId) async {
    final newItem = WishlistItem(
      userId: userId,
      productId: productId,
      id: productId,
      imgurl: widget.product.imgurl,
      name: widget.product.name,
      price: widget.product.price,
    );

    try {
      await FirebaseFirestore.instance
          .collection('wishlist')
          .add(newItem.toJson());
    } catch (e) {
      print('Error adding item to wishlist in Firestore: $e');
    }
  }

  Future<void> removeFromFirestore(String productId, String userId) async {
    try {
      CollectionReference wishlistCollection =
          FirebaseFirestore.instance.collection('wishlist');

      QuerySnapshot querySnapshot = await wishlistCollection
          .where('productId', isEqualTo: productId)
          .where('userId', isEqualTo: userId)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await wishlistCollection.doc(doc.id).delete();
      }

      log('Item with productId $productId removed from wishlist in Firestore.');
    } catch (e) {
      log('Error removing item from wishlist in Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: TextStyle(
            fontFamily: 'Sarala',
            color: HashColorCodes.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      backgroundColor: HashColorCodes.screenGrey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: widget.product.imgurl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: IconButton(
                    icon: Icon(
                      isWishlist ? Icons.favorite : Icons.favorite_border,
                      color: isWishlist ? Colors.red : Colors.grey,
                      size: 30.0,
                    ),
                    onPressed: () {
                      toggleWishlist();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: HashColorCodes.green),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Disc : ${widget.product.discount}%",
                            style: TextStyle(color: HashColorCodes.green),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.product.name.toLowerCase().contains("banana")
                            ? "Unit Price : ${widget.product.price}/dez"
                            : "Unit Price : ${widget.product.price}/kg",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Select Quantity :",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      SizedBox(
                        width: mq.width * .1,
                      ),
                      DropdownButton<int>(
                        value: selectedQuantity,
                        items: List.generate(10, (index) => index + 1)
                            .map((int value) {
                          final unit = widget.product.name
                                  .toLowerCase()
                                  .contains("banana")
                              ? "dez"
                              : "kg";
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value $unit'),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedQuantity = newValue!;
                            totalPrice = selectedQuantity * originalPrice;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
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
                        "Price",
                        style: TextStyle(
                          color: HashColorCodes.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Price: Rs ${selectedQuantity > 1 ? totalPrice : originalPrice}",
                            style: TextStyle(
                              color: HashColorCodes.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final CartItem addItem = CartItem(
                                cartItemId: widget.product.id,
                                productName: widget.product.name,
                                quantity: 1,
                                price: widget.product.price,
                                imgurl: widget.product.imgurl,
                              );
                              APIs.addToCart(addItem).then((value) {
                                Dialogs.showSnackbar(
                                    context, "Item Added To Cart..");
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HashColorCodes.green,
                            ),
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 18,
                                color: HashColorCodes.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ]),
              )),
        ],
      ),
    );
  }
}
