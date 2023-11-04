import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_apk/main.dart';
import 'package:grocery_apk/models/order.dart';
import 'package:grocery_apk/themes/theme_colors.dart';

class MyOrdersCard extends StatelessWidget {
  const MyOrdersCard({super.key, required this.orders});
  final Orders orders;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: mq.height * .15,
        child: ListView.builder(
          itemCount: orders.items.length,
          itemBuilder: (context, index) {
            final item = orders.items[index];

            return ListTile(
              leading: SizedBox(
                width: 100,
                child: CachedNetworkImage(
                  imageUrl: item.imgurl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: HashColorCodes.green,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              title: Text(
                item.productName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orders.is_delivered ? 'Delivered' : 'Not Delivered',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                      'Total Price: \$${orders.totalPrice.toStringAsFixed(2)}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
