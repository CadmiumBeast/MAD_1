import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'Resturants/homeResturant.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc['role'] as String?;
      }
    } catch (e) {
      print("Error fetching user role: $e");
    }
    return null;
  }

  Future<void> saveRestaurantsToJson() async {
    try {
      // Fetch restaurant data from Firestore
      QuerySnapshot restaurantSnapshot =
      await FirebaseFirestore.instance.collection('restaurants').get();

      List<Map<String, dynamic>> restaurantList = restaurantSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'address': doc['address'],
          'latitude': doc['latitude'],
          'longitude': doc['longitude'],
          'imageUrl': doc['imageUrl'],
          'ownerId': doc['ownerId'],
        };
      }).toList();

      String jsonData = jsonEncode(restaurantList);

      // Get application support directory (persists data)
      Directory appDir = await getApplicationSupportDirectory();
      File file = File('${appDir.path}/restaurants.json');

      // Write JSON data to the file
      await file.writeAsString(jsonData);

      print("Restaurant data saved to: ${file.path}");
    } catch (e) {
      print("Error saving restaurant data: $e");
    }
  }

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Wait for Firebase authentication state to update
      await Future.delayed(const Duration(seconds: 2));

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("DEBUG: FirebaseAuth.instance.currentUser is NULL after login!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication error! Try again.")),
        );
        return;
      }

      print("DEBUG: Logged-in User UID: ${user.uid}");

      // Fetch user role from Firestore
      String? role = await getUserRole(user.uid);

      if (role != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful!")),
        );

        // Navigate to the appropriate page based on the user's role
        if (role == 'customer') {
          Navigator.pushReplacementNamed(context, '/customer/home');
        } else if (role == 'restaurant') {
          if (role == 'restaurant') {
            String userId = userCredential.user!.uid;

            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('restaurants')
                .where('ownerId', isEqualTo: userId) // Find the restaurant that belongs to this owner
                .limit(1)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              String restaurantId = querySnapshot.docs.first.id; // Get the correct restaurant ID
              print("DEBUG: Correct restaurantId for user: $restaurantId");

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Homeresturant(resturantid: restaurantId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("You are not associated with any restaurant")),
              );
            }
          }

        } else if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Unknown user role!")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch user role!")),
        );
      }
    } catch (e) {
      print("DEBUG: Login error - $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }


  // Google Sign-In Function
  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User cancelled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential);
      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Failed: $e");
      return null;
    }
  }


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
                    child: Text('Email'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextField( 
                    controller: _emailController,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    obscureText: true, // Hide password input
                    controller: _passwordController,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: const Text('New Here? Register'),
                ),
                ElevatedButton(
                  onPressed: signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('asset/images/google_logo.png', height: 24),
                      const SizedBox(width: 10),
                      const Text("Sign in with Google", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
