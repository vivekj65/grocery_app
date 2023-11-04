import 'package:flutter/material.dart';
import 'package:grocery_apk/themes/theme_colors.dart';

class CatagoriScreen extends StatefulWidget {
  const CatagoriScreen({super.key});

  @override
  State<CatagoriScreen> createState() => _CatagoriScreenState();
}

class _CatagoriScreenState extends State<CatagoriScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Categories",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: HashColorCodes.white,
              fontFamily: 'Urbanist'),
        ),
        centerTitle: false,
        backgroundColor: HashColorCodes.green,
      ),
      body: Column(children: [
        Text("Catagories")
      ]),
    );
  }
}
