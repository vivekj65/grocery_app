import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/screens/cart_screen.dart';
import 'package:grocery_apk/screens/home_screen_bottomnavigation.dart';
import 'package:grocery_apk/screens/orders_screen.dart';
import 'package:grocery_apk/screens/setting_screen.dart';
import 'package:grocery_apk/screens/wishlist_screen.dart';
import 'package:grocery_apk/themes/theme_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreenBottomNavigation(),
    WishListScreen(),
    CartScreen(),
    OrdersScreen(),
    SettingScreen(
      userId: APIs.auth.currentUser!.uid,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HashColorCodes.green,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: HashColorCodes.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Wishlist',
              backgroundColor: HashColorCodes.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
              backgroundColor: HashColorCodes.green),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: HashColorCodes.green),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
