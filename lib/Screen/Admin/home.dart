import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Widget/themController.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
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
    // Access the ThemeModifier provider here
    final themeNotifier = Provider.of<ThemeModifier>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Home'),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: themeNotifier.toggleTheme,
                  icon: Icon(themeNotifier.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/logout');
                  },
                  icon: const Icon(Icons.logout),
                )
              ],
            )
          ],
        ),
        body: _mainTemp(themeNotifier),
        bottomNavigationBar: _bottomnavgation(themeNotifier));
  }

  Widget _mainTemp(ThemeModifier themeNotifier) {
    return StreamBuilder<QuerySnapshot>(
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
    );
  }

  Widget _bottomnavgation(ThemeModifier themeNotifier) {
    return Container(
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
              color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/admin/restaurant/add');
            },
            icon: Icon(
              Icons.add,
              color: themeNotifier.isDarkMode ? Colors.amber : Colors.amber,
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
    );
  }
}
