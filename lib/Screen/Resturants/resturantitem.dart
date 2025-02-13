import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widget/themController.dart';
import 'AddItem.dart';
import 'homeResturant.dart';

class ResturantItems extends StatefulWidget {
  final String resturantid;
  const ResturantItems({super.key, required this.resturantid});

  @override
  State<ResturantItems> createState() => _ResturantItemsState();
}

class _ResturantItemsState extends State<ResturantItems> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Items'),
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Restaurant Menu',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),

            // Fetch Items from Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(widget.resturantid)
                    .collection('items')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Error fetching restaurant items"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("No items found for this restaurant"));
                  }

                  final items = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index].data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: item['imageUrl'] != null
                              ? Image.network(
                            item['imageUrl'],
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                              : const Icon(Icons.fastfood),
                          title: Text(
                            item['itemName'] ?? 'Unnamed Item',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            item['cuisineType'] ?? 'Unknown Cuisine',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('restaurants')
                                  .doc(widget.resturantid)
                                  .collection('items')
                                  .doc(items[index].id)
                                  .delete();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Item deleted successfully')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Homeresturant(resturantid: widget.resturantid),
                  ),
                );
              },
              icon: Icon(Icons.list,
                  color: themeNotifier.isDarkMode
                      ? Colors.amber
                      : Colors.amber),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResturantItems(resturantid: widget.resturantid),
                  ),
                );
              },
              icon: Icon(Icons.restaurant_menu,
                  color: themeNotifier.isDarkMode
                      ? Colors.white
                      : Colors.black),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Additem(resturantid: widget.resturantid),
                  ),
                );
              },
              icon: Icon(Icons.add,
                  color: themeNotifier.isDarkMode
                      ? Colors.amber
                      : Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
