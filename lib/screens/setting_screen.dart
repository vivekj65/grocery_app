import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/main.dart';
import 'package:grocery_apk/screens/about_screen.dart';
import 'package:grocery_apk/screens/address_screen.dart';
import 'package:grocery_apk/screens/auth/auth_screen.dart';
import 'package:grocery_apk/models/grocery_user.dart';
import 'package:grocery_apk/themes/theme_colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> userStream;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HashColorCodes.green,
        title: Text(
          "Settings",
          style: TextStyle(
            fontFamily: 'Sarala',
            color: HashColorCodes.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: HashColorCodes.white,
            ),
          ),
        ],
      ),
      backgroundColor: HashColorCodes.screenGrey,
      body: Center(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: APIs.getSelfInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final user = GroceryUser(
                id: widget.userId,
                name: userData['name'] ?? '',
                email: userData['email'] ?? '',
              );

              return Column(
                children: [
                  Container(
                    width: screenWidth,
                    height: mq.height * .33,
                    decoration: BoxDecoration(
                      color: HashColorCodes.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person,
                              color: HashColorCodes.white,
                              size: 110,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            user.name,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10),
                          Text(
                            user.email,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddressScreen(
                                  isNavigatedFromCartScreen: false,
                                  totalprice: null,
                                  jsonitem: null)));
                    },
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth,
                          height: mq.height * .07,
                          color: HashColorCodes.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.location_on),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Address"),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AboutScreen()));
                    },
                    child: Container(
                      width: screenWidth,
                      height: mq.height * .07,
                      color: HashColorCodes.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(
                              width: 10,
                            ),
                            Text("About Us"),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.arrow_forward)
                          ],
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await APIs.auth.signOut();
                        await GoogleSignIn().signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AuthCheakScreen()));
                      } catch (e) {
                        print("Sign out error: $e");
                      }
                    },
                    child: Text("Sign Out"),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("Error fetching user data: ${snapshot.error}");
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
