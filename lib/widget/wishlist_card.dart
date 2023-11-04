import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/common/dialogs.dart';
import 'package:grocery_apk/main.dart';
import 'package:grocery_apk/models/cart_items.dart';
import 'package:grocery_apk/models/wishlist.dart';
import 'package:grocery_apk/themes/theme_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class WishlistCard extends StatelessWidget {
  const WishlistCard({super.key, required this.item});
  final WishlistItem item;

  Future<void> removeFromFirestore(String productId, String userId) async {
    CollectionReference wishlistCollection =
        FirebaseFirestore.instance.collection('wishlist');
    QuerySnapshot querySnapshot = await wishlistCollection
        .where('productId', isEqualTo: productId)
        .where('userId', isEqualTo: userId)
        .get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await wishlistCollection.doc(doc.id).delete();
    }
    log('Item with productId $productId removed from wishlist in Fire store.');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * .15,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Container(
              height: mq.height * .135,
              width: mq.width * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: item.imgurl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Urbanist'),
                ),
                Text(
                  item.name.toLowerCase().contains("banana")
                      ? "Unit Price : ${item.price}/dez"
                      : "Unit Price : ${item.price}/kg",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Urbanist',
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final CartItem addItem = CartItem(
                          cartItemId: item.id,
                          productName: item.name,
                          quantity: 1,
                          price: item.price,
                          imgurl: item.imgurl,
                        );

                        APIs.addToCart(addItem).then((value) {
                          Dialogs.showSnackbar(context, "Item Added To Cart..");
                        });
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(124, 30)),
                        backgroundColor:
                            MaterialStateProperty.all(HashColorCodes.green),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(
                        "Add To Cart",
                        style: TextStyle(color: HashColorCodes.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        removeFromFirestore(item.productId, item.userId);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: HashColorCodes.red,
                      ),
                      iconSize: 30,
                    ),
                  ],
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
