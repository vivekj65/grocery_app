import 'package:flutter/material.dart';
import 'package:grocery_apk/models/shipping_address.dart';
import 'package:grocery_apk/themes/theme_colors.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key, required this.address});
  final ShippingAddress address;
  @override
  Widget build(BuildContext ontext) {
    return Container(
      decoration: BoxDecoration(
          color: HashColorCodes.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.name,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold),
              ),
              Text(
                address.streetAddress,
                style: TextStyle(fontSize: 15),
              ),
              Row(
                children: [
                  Text(
                    address.city,
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    width: 13,
                  ),
                  Text(
                    address.postalCode,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Text(
                address.state,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "+91 ${address.phoneNo}",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
