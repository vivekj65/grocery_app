import 'package:flutter/material.dart';
import 'package:grocery_apk/firebase_options.dart';
import 'package:grocery_apk/screens/product_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grocery_apk/screens/splash_screen.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebaseApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => WishlistNotifier(),
      child: MyApp(),
    ),
  );
}

late Size mq;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

_initializeFirebaseApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
