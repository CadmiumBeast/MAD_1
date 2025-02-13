import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuisineconnect/Widget/themController.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../Providers/location_provider.dart';
import 'Resturants/resturantitem.dart';

class HomeCustomer extends StatefulWidget {
  const HomeCustomer({super.key});

  @override
  State<HomeCustomer> createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {
  bool isOffline = false;
  List<dynamic> restaurantData = [];

  @override
  void initState() {
    super.initState();
    checkInternetAndFetchData();
  }

  Future<void> checkInternetAndFetchData() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isOffline = true;
      });
      loadLocalData();
    } else {
      fetchAndSaveRestaurants();
    }
  }

  Future<void> fetchAndSaveRestaurants() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('restaurants').get();
      List<Map<String, dynamic>> restaurants = querySnapshot.docs
          .map((doc) => {
        "name": doc["name"],
        "address": doc["address"],
        "latitude": doc["latitude"],
        "longitude": doc["longitude"],
        "imageUrl": doc["imageUrl"]
      })
          .toList();

      setState(() {
        restaurantData = restaurants;
      });

      saveDataLocally(restaurants);
    } catch (e) {
      print("Error fetching restaurant data: $e");
    }
  }

  Future<void> saveDataLocally(List<Map<String, dynamic>> data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/restaurants.json');
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print("Error saving data locally: $e");
    }
  }

  Future<void> loadLocalData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/restaurants.json');

      if (await file.exists()) {
        String jsonData = await file.readAsString();
        setState(() {
          restaurantData = jsonDecode(jsonData);
        });
      }
    } catch (e) {
      print("Error loading local data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModifier>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Current Location",
              style: TextStyle(fontSize: 14),
            ),
            Text(
              locationProvider.address,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: themeNotifier.toggleTheme,
            icon: Icon(themeNotifier.isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),

      body: isOffline && restaurantData.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text("No Internet Connection"),
            Text("Please check your connection and try again."),
          ],
        ),
      )
          : ListView.builder(
        itemCount: restaurantData.length,
        itemBuilder: (context, index) {
          final restaurant = restaurantData[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: restaurant['imageUrl'] != null
                  ? Image.network(
                restaurant['imageUrl'],
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.restaurant),
              title: Text(
                restaurant['name'] ?? 'No Name',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                restaurant['address'] ?? "Fetching address...",
                style: Theme.of(context).textTheme.bodySmall,
              ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResturantItems(resturantid: restaurant['id']), // Navigate to restaurant items screen
                    ),
                  );
                }
            ),
          );
        },
      ),

      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/customer/home');
              },
              icon: Icon(Icons.home),
              color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/customer/cart');
              },
              icon: Icon(Icons.shopping_cart),
              color: themeNotifier.isDarkMode ? Colors.amber : Colors.amber,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/orderList');
              },
              icon: Icon(Icons.list),
              color: themeNotifier.isDarkMode ? Colors.amber : Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
