import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/main.dart';
import 'package:grocery_apk/models/shipping_address.dart';
import 'package:grocery_apk/screens/add_address_screen.dart';
import 'package:grocery_apk/screens/cart_screen.dart';
import 'package:grocery_apk/screens/confirmorder_screen.dart';
import 'package:grocery_apk/themes/theme_colors.dart';
import 'package:grocery_apk/widget/address_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class AddressScreen extends StatefulWidget {
  const AddressScreen({
    Key? key,
    required this.isNavigatedFromCartScreen,
    required this.totalprice,
    required this.jsonitem,
  }) : super(key: key);
  final bool isNavigatedFromCartScreen;
  final totalprice;
  final jsonitem;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  double screenWidth = 0;
  final String userId = APIs.auth.currentUser!.uid;
  ShippingAddress? selectedAddress;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
            icon: Icon(CupertinoIcons.cart),
          ),
        ],
        backgroundColor: HashColorCodes.green,
        title: Text(
          "Select Address",
          style: TextStyle(
            fontFamily: 'Sarala',
            color: HashColorCodes.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: HashColorCodes.screenGrey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddAddressScreen()),
              );
            },
            child: Container(
              decoration: BoxDecoration(color: HashColorCodes.white),
              height: mq.height * .07,
              width: screenWidth,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "+ Add a new address",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    color: HashColorCodes.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('shipping_address')
                .doc(userId)
                .collection('address')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              final addresses = snapshot.data!.docs
                  .map((doc) => ShippingAddress(
                        name: doc['name'],
                        id: doc['id'],
                        city: doc['city'],
                        state: doc['state'],
                        streetAddress: doc['streetAddress'],
                        postalCode: doc['postalCode'],
                        phoneNo: doc['phoneNo'],
                      ))
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${addresses.length} ${addresses.length == 1 ? 'ADDRESS' : 'ADDRESSES'} SAVED",
                  style: TextStyle(color: HashColorCodes.fontGrey),
                ),
              );
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('shipping_address')
                .doc(userId)
                .collection('address')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              final addresses = snapshot.data!.docs
                  .map((doc) => ShippingAddress(
                        name: doc['name'],
                        id: doc['id'],
                        city: doc['city'],
                        state: doc['state'],
                        streetAddress: doc['streetAddress'],
                        postalCode: doc['postalCode'],
                        phoneNo: doc['phoneNo'],
                      ))
                  .toList();

              return Column(
                children: addresses.map((address) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedAddress = address;
                      });
                      log("${selectedAddress!.phoneNo}");
                      // final item = CartItem(
                      //   cartItemId: '',
                      //   imgurl: '',
                      //   productName: 'Dhiraj',
                      //   quantity: 0,
                      //   price: 0,
                      // );
                      if (widget.isNavigatedFromCartScreen) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConfirmOrderScreen(
                              selectedAddress: selectedAddress,
                              cartItems: widget.jsonitem,
                              totalPrice: widget.totalprice,
                            ),
                          ),
                        );
                      }
                    },
                    onLongPress: () {
                      APIs.deleteAddress(address.id);
                    },
                    child: AddressCard(address: address),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
