import 'package:flutter/material.dart';
import 'package:grocery_apk/themes/theme_colors.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(
              color: HashColorCodes.white,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: HashColorCodes.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text(
          //   "About Us",
          //   style: TextStyle(
          //       color: HashColorCodes.black,
          //       fontWeight: FontWeight.w600,
          //       fontSize: 18),
          // ),
          Text(
            "Welcome to Grocery App..!",
            style: TextStyle(
                color: HashColorCodes.black,
                fontWeight: FontWeight.w600,
                fontSize: 18),
          ),
          Text(
            "At [Your Grocery App Name], we are passionate about making your grocery shopping experience convenient, enjoyable, and hassle-free. Our journey began with a simple idea: to create a platform that brings the freshest ingredients, pantry essentials, and household items right to your doorstep.",
            style: TextStyle(
                color: HashColorCodes.black,
                // fontWeight: FontWeight.w600,
                fontSize: 18),
          ),
        ],
      ),
    );
  }
}
