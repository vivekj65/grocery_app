import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/common/dialogs.dart';
import 'package:grocery_apk/main.dart';
import 'package:grocery_apk/models/cart_items.dart';
import 'package:grocery_apk/models/product.dart';
import 'package:grocery_apk/themes/theme_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartItem newItem = CartItem(
      cartItemId: product.id,
      productName: product.name,
      quantity: 1,
      price: product.price,
      imgurl: product.imgurl,
    );
    return Container(
      decoration: BoxDecoration(
        color: HashColorCodes.productGrey,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: HashColorCodes.borderGrey,
          width: .2,
        ),
      ),
      child: Column(children: [
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         "${product.discount} off",
        //         style: TextStyle(
        //             fontSize: 15,
        //             fontWeight: FontWeight.bold,
        //             fontFamily: 'Urbanist'),
        //       ),
        //       IconButton(
        //           onPressed: () {},
        //           icon: Icon(
        //             CupertinoIcons.heart_fill,
        //             color: HashColorCodes.grey,
        //           ))
        //     ],
        //   ),
        // ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: mq.height * .1,
              width: mq.width * .54,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: product.imgurl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                    color: HashColorCodes.green,
                  )),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist'),
                ),
                ElevatedButton(
                  onPressed: () {
                    APIs.addToCart(newItem).then((value) {
                      Dialogs.showSnackbar(context, "Item Added To Cart..");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HashColorCodes.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: HashColorCodes.white,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              product.description.split(' ').take(3).join(' ') + '...',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rs. ${product.price.toString()}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist',
                      color: HashColorCodes.green),
                ),
                Text(
                  "${product.discount}% off",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist'),
                ),
              ],
            ),
          ]),
        ),
      ]),
    );
  }
}
