import 'package:flutter/material.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/common/dialogs.dart';
import 'package:grocery_apk/models/shipping_address.dart';
import 'package:grocery_apk/themes/theme_colors.dart';
import 'package:uuid/uuid.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  TextEditingController _streetAddressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _streetAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HashColorCodes.green,
        title: Text(
          'Add Shipping Address',
          style: TextStyle(
            fontFamily: 'Sarala',
            color: HashColorCodes.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _streetAddressController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HashColorCodes.borderGrey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HashColorCodes.borderGrey,
                    ),
                  ),
                  hintText: 'ex. Kasaba Bawada, Near D Y Patil Collage',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'City',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HashColorCodes.borderGrey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HashColorCodes.borderGrey,
                    ),
                  ),
                  hintText: 'ex Kolhapur',
                ),
                controller: _cityController,
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HashColorCodes.borderGrey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HashColorCodes.borderGrey,
                    ),
                  ),
                  hintText: 'ex Maharastra',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'Postal Code',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HashColorCodes.borderGrey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HashColorCodes.borderGrey,
                    ),
                  ),
                  hintText: 'ex-416006',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'PhoneNo',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HashColorCodes.borderGrey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HashColorCodes.borderGrey,
                    ),
                  ),
                  hintText: '1234567890',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  backgroundColor: HashColorCodes.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                ),
                onPressed: () {
                  final streetAddress = _streetAddressController.text;
                  final city = _cityController.text;
                  final state = _stateController.text;
                  final postalCode = _postalCodeController.text;
                  final phoneNo = _phoneController.text;
                  var uuid = Uuid();
                  final name = APIs.auth.currentUser!.displayName;

                  ShippingAddress address = ShippingAddress(
                      id: uuid.v4(),
                      streetAddress: streetAddress,
                      city: city,
                      state: state,
                      postalCode: postalCode,
                      phoneNo: phoneNo,
                      name: name.toString());
                  APIs.addAddress(address).then((value) {
                    Dialogs.showSnackbar(context, "Address Saved Successfully");
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Save Address',
                  style: TextStyle(color: HashColorCodes.white, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
