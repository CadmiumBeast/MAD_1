import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Ensures the container takes the full width
        height: double.infinity, // Ensures the container takes the full height
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/images/home_bg.png'),
            fit: BoxFit.cover, // Ensures the background image covers the full area
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50), // Add some spacing from the top
                const Image(
                  image: AssetImage('asset/images/logo.png'),
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Username'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextField( 
                    
                  ),
                
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Password'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    obscureText: true, // Hide password input
                  
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/resturant/home');

                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: const Text('New Here? Register'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
