import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Widget/themController.dart';


class AdminAddRestaurant extends StatefulWidget {
  const AdminAddRestaurant({super.key});

  @override
  State<AdminAddRestaurant> createState() => _AdminAddRestaurantState();
}

class _AdminAddRestaurantState extends State<AdminAddRestaurant> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Image for the restaurant
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  Future<String> _uploadImageToStorage(String restaurantId) async {
    if (_selectedImage == null) {
      throw Exception("No image selected");
    }

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('restaurant_images')
          .child('$restaurantId.jpg');
      await ref.putFile(_selectedImage!);
      return await ref.getDownloadURL(); // Return the download URL
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  //Add the restaurant to the Authentication then to the Restaurant Collection then the image to the Storage

  Future<void> _addRestaurant() async{
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String name = _nameController.text.trim();
    String address = _addressController.text.trim();
    double? latitude = double.tryParse(_latitudeController.text.trim());
    double? longitude = double.tryParse(_longitudeController.text.trim());
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid latitude or longitude')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try{

      // Create Firebase Authentication user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String ownerId = userCredential.user!.uid;

      // Upload Image
      String imageUrl = await _uploadImageToStorage(ownerId);

      // Add restaurant to Firestore
      await FirebaseFirestore.instance.collection('restaurants').add({
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'ownerId': ownerId,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Add user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(ownerId).set({
        'email': email,
        'role': 'restaurant',
        'restaurantId': ownerId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restaurant and user created successfully!')),
      );

      // Clear form fields
      _nameController.clear();
      _addressController.clear();
      _latitudeController.clear();
      _longitudeController.clear();
      _emailController.clear();
      _passwordController.clear();
      setState(() {
        _selectedImage = null;
      });


    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add restaurant: $e')),
      );
    }
    finally {
      setState(() {
        _isUploading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            onPressed: themeNotifier.toggleTheme,
            icon: Icon(themeNotifier.isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Restaurant Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a restaurant name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Restaurant Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a restaurant address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _latitudeController,
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || double.tryParse(value) == null) {
                      return 'Please enter a valid latitude';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _longitudeController,
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || double.tryParse(value) == null) {
                      return 'Please enter a valid longitude';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Select Image'),
                      ),
                    ),
                  ],
                ),
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      _selectedImage!,
                      height: 150,
                    ),
                  ),
                const SizedBox(height: 20),
                _isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _addRestaurant,
                  child: const Text('Add Restaurant'),
                ),
              ],
            ),
          ),
        ),
      ),


      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/admin/home');
              },
              icon: Icon(
                Icons.home,
                color: themeNotifier.isDarkMode ? Colors.amber : Colors.amber,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/admin/restaurant/add');
              },
              icon: Icon(
                Icons.add,
                color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/admin/customer/list');
              },
              icon: Icon(
                Icons.supervised_user_circle_sharp,
                color: themeNotifier.isDarkMode ? Colors.amber : Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
