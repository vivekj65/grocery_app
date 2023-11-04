import 'package:flutter/material.dart';
import 'package:grocery_apk/screens/home_screen.dart';
import 'package:grocery_apk/themes/theme_colors.dart';

class OrderplacedScreen extends StatefulWidget {
  const OrderplacedScreen({super.key});

  @override
  State<OrderplacedScreen> createState() => _OrderplacedScreenState();
}

class _OrderplacedScreenState extends State<OrderplacedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HashColorCodes.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/verified-account.png'),
              height: 150,
            ),
            Text(
              "Congratulations",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sarala',
                  color: HashColorCodes.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Your order has been placed",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Sarala',
                  color: HashColorCodes.white),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Track Order >",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sarala',
                  color: HashColorCodes.white),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStatePropertyAll(3),
                    shape: MaterialStatePropertyAll(BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))))),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    ),
                    (route) => false, 
                  );
                },
                child: Text(
                  "Continue Shopping",
                  style: TextStyle(color: HashColorCodes.black, fontSize: 15),
                ))
          ],
        ),
      ),
    );
  }
}
