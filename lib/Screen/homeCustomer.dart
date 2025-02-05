import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuisineconnect/Widget/themController.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

import '../Providers/location_provider.dart';

class HomeCustomer extends StatefulWidget {
  const HomeCustomer({super.key});


  @override
  State<HomeCustomer> createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<LocationProvider>(context, listen: false).fetchCurrentLocation();
    });
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.country}";
      }
      return "Address not found.";
    } catch (e) {
      return "Error fetching address.";
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
              locationProvider.address, // Show the fetched address
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

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('restaurants').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching restaurant details'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No restaurants available'),
            );
          }

          final restaurants = snapshot.data!.docs;

          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant =
              restaurants[index].data() as Map<String, dynamic>;

              return FutureBuilder<String>(
                future: getAddressFromCoordinates(
                  restaurant['latitude'] ?? 0.0,
                  restaurant['longitude'] ?? 0.0,
                ),
                builder: (context, addressSnapshot) {
                  final address = addressSnapshot.data ?? "Fetching address...";

                  return Card(
                    margin:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: themeNotifier.isDarkMode
                              ? Colors.red
                              : Colors.redAccent,
                        ),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('restaurants')
                              .doc(restaurants[index].id)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Restaurant deleted')),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),



      bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: IconButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/customer/home');
                }, icon: Icon(Icons.home), color: themeNotifier.isDarkMode ?
                Colors.white : Colors.black,),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: IconButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/customer/cart');
                }, icon:  Icon(Icons.shopping_cart, color: themeNotifier.isDarkMode ?
                Colors.amber : Colors.amber)),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: IconButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/orderList');
                }, icon:Icon(Icons.list, color: themeNotifier.isDarkMode ?
                Colors.amber : Colors.amber)),
              ),
            ],

          )

      ),
    );
  }
}