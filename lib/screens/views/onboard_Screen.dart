import 'package:grocery_apk/main.dart';
import 'package:grocery_apk/screens/auth/auth_screen.dart';
import 'package:grocery_apk/themes/theme_colors.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/onbord-image-1.png'),
              fit: BoxFit.cover, 
            ),
          ),
        ),
        titleWidget: const Text(
          'Discover the Joy of Hassle-Free Shopping',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
        bodyWidget: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Welcome to FreshCart - Where Grocery Shopping Meets Convenience.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              'Explore a world of high-quality products, personalized recommendations, and doorstep delivery. Experience hassle-free shopping and exclusive deals as you embark on a new way to shop with us!',
              style: TextStyle(
                fontSize: 16.0,
                color: HashColorCodes.grey,
              ),
            ),
          ],
        ),
      ),
      PageViewModel(
        image: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/onbord-image-2.png'),
              fit: BoxFit.cover, 
            ),
          ),
        ),
        titleWidget: const Text(
          'Easy Ordering',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
        bodyWidget: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Shop in Minutes',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              'Add items to your cart with a tap. Customize your orders, set preferences, and easily schedule deliveries or pickups.',
              style: TextStyle(
                fontSize: 16.0,
                color: HashColorCodes.grey,
              ),
            ),
          ],
        ),
      ),
      PageViewModel(
        image: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/onbord-image-3.png'),
              fit: BoxFit.cover, 
            ),
          ),
        ),
        titleWidget: const Text(
          'Happy Shopping!',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
        bodyWidget: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              ' Your Grocery Shopping, Simplified',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              'Join thousands of satisfied customers who trust us for their grocery needs. Let us start shopping!',
              style: TextStyle(
                fontSize: 16.0,
                color: HashColorCodes.grey,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return IntroductionScreen(
      done: const Text("Done"),
      onDone: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AuthCheakScreen()));
      },
      pages: getPages(),
      showNextButton: true,
      next: const Text("Next"),
    );
  }
}
