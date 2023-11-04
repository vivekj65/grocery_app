import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/screens/home_screen.dart';
import 'package:grocery_apk/screens/views/onboard_Screen.dart';

import 'package:grocery_apk/themes/theme_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (APIs.auth.currentUser != null) {
        // For printing user detail
        log('User: ${FirebaseAuth.instance.currentUser!.uid}');

        //navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        //navigate to login screen
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Media query for sizing
    // final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        // Set the background color of the body
        color: HashColorCodes.green, // Replace with your desired color
        child: const Center(
          child: Image(
            image: AssetImage('images/logo.png'),
            height: 150,
          ),
        ),
      ),
    );
  }
}
