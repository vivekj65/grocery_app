import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_apk/main.dart';
import 'package:grocery_apk/models/cart_items.dart';

class ConfirmOrderCard extends StatelessWidget {
  const ConfirmOrderCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * .15,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: mq.height * .135,
                width: mq.width * .35,
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
                    item.productName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    item.productName.toLowerCase().contains("banana")
                        ? "Unit Price : ${item.price}/dez"
                        : "Unit Price : ${item.price}/kg",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    child: Text(
                      item.productName.toLowerCase().contains("banana")
                          ? "${item.quantity.toString()} dez"
                          : "${item.quantity.toString()} kg",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
