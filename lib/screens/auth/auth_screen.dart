import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/common/dialogs.dart';
import 'package:grocery_apk/main.dart';
import 'package:grocery_apk/screens/auth/login_screen.dart';
import 'package:grocery_apk/screens/home_screen.dart';
import 'package:grocery_apk/themes/theme_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCheakScreen extends StatefulWidget {
  const AuthCheakScreen({super.key});

  @override
  State<AuthCheakScreen> createState() => _AuthCheakScreenState();
}

class _AuthCheakScreenState extends State<AuthCheakScreen> {
  HandleGoogleBtnClick() {
    //showing loder

    Dialogs.showLoader(context);
    signInWithGoogle().then((user) async {
      //hiding Loder
      Navigator.pop(context);
      if (user != null) {
        //printing user detail
        log('User : ${user.user}');
        log('User Additional Info : ${user.additionalUserInfo}');

        if (await (APIs.userExist())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('signInWithGoogle: $e');
      Dialogs.showSnackbar(
          context, "Something Went Wrong Check Your Internet Connection..!");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
        child: Column(children: [
          Center(
              child: Image(
            image: const AssetImage('images/login-banner.png'),
            height: mq.height * .30,
          )),
          const Text(
            "Welcome To  Grocery",
            style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w900,
                fontFamily: 'Urbanist'),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "shop everything you need without the trip to the supermarket",
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Sarala'),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HashColorCodes.green,
              elevation: mq.height * 0.01,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Login with Phone',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Sarala',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {
              HandleGoogleBtnClick();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HashColorCodes.white,
              elevation: mq.height * 0.01,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the text horizontally
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/google-logo.png'),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Login with Google',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sarala',
                    color: HashColorCodes.grey,
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
