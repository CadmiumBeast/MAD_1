import 'package:cuisineconnect/Screen/login.dart';
import 'package:flutter/material.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();

  // Custom page route with fade animation
  Route _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Loginpage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

class _StartingPageState extends State<StartingPage> {
  @override
  void initState() {
    super.initState();
    
    // Wait for 4 seconds before navigating to the LoginPage
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(widget._createFadeRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/images/home_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Image(image: AssetImage('asset/images/logo.png')),
        ),
      ),
    );
  }
}
