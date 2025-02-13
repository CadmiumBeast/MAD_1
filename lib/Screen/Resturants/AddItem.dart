import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuisineconnect/Screen/Resturants/resturantitem.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Widget/themController.dart';
import 'homeResturant.dart';

class Additem extends StatefulWidget {
  final String resturantid;
  const Additem({super.key, required this.resturantid});


  @override
  State<Additem> createState() => _AdditemState();
}

class _AdditemState extends State<Additem> {




  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _cuisineTypeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Image Saving
  File? _selectedImage;
  bool _isUploading = false;

  // Image Picker Function
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Upload Image to Firebase Storage
  Future<String> _uploadImageToStorage(String itemId) async {
    if (_selectedImage == null) {
      throw Exception("No image selected");
    }

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('restaurant_items/${widget.resturantid}')
          .child('$itemId.jpg');
      await ref.putFile(_selectedImage!);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  // Add Item to Firestore
  Future<void> _addItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Print Debug Information
      print("DEBUG: Passed Restaurant ID: ${widget.resturantid}");

      // Fetch restaurant details to confirm ownership
      DocumentSnapshot restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.resturantid)
          .get();

      if (!restaurantDoc.exists) {
        print("DEBUG: Restaurant document does NOT exist in Firestore.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Restaurant does not exist.")),
        );
        return;
      }

      print("DEBUG: Restaurant document found!");

      String ownerId = restaurantDoc['ownerId'];
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("DEBUG: No authenticated user.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must be logged in to add an item")),
        );
        return;
      }

      print("DEBUG: Logged-in User UID: ${user.uid}");
      print("DEBUG: Restaurant Owner UID: $ownerId");

      if (ownerId != user.uid) {
        print("DEBUG: User is NOT the owner of this restaurant.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You are not authorized to add items to this restaurant")),
        );
        return;
      }

      print("DEBUG: User is authorized. Proceeding to add item...");

      String itemName = _itemNameController.text.trim();
      String cuisineType = _cuisineTypeController.text.trim();

      // Generate a unique ID for the item
      DocumentReference itemRef = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.resturantid)
          .collection('items')
          .doc();

      String imageUrl = await _uploadImageToStorage(itemRef.id);

      await itemRef.set({
        'itemName': itemName,
        'cuisineType': cuisineType,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'restaurantId': widget.resturantid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully!')),
      );

      // Clear form fields
      _itemNameController.clear();
      _cuisineTypeController.clear();
      setState(() {
        _selectedImage = null;
      });

    } catch (e) {
      print("DEBUG: Failed to add item - $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModifier>(context);
    final isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/logout');
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: isLandScape ? _buildLandscapeLayout() : _buildPortraitLayout(),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Homeresturant(resturantid: this.widget.resturantid),
                ),);
              }, icon: Icon(Icons.list), color: themeNotifier.isDarkMode ?
              Colors.amber : Colors.amber,),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ResturantItems(resturantid: this.widget.resturantid),
                ));
              }, icon:  Icon(Icons.restaurant_menu, color: themeNotifier.isDarkMode ?
              Colors.amber : Colors.amber)),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Additem(resturantid: this.widget.resturantid),
                ));
              }, icon:Icon(Icons.add, color: themeNotifier.isDarkMode ?
              Colors.white : Colors.black)),
            ),
          ],

        ),
      ),
    );
  }

  // Portrait Layout
  Widget _buildPortraitLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            controller: _itemNameController,
            decoration: const InputDecoration(
              labelText: 'Item Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an item name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cuisineTypeController,
            decoration: const InputDecoration(
              labelText: 'Cuisine Type',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter cuisine type';
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
                  style: Theme.of(context).elevatedButtonTheme.style,
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
            onPressed: _addItem,
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildPortraitLayout(),
        ),
        Expanded(
          flex: 2,
          child: _selectedImage != null
              ? Image.file(
            _selectedImage!,
            height: 200,
          )
              : const Center(
            child: Text("No image selected"),
          ),
        ),
      ],
    );
  }
}
