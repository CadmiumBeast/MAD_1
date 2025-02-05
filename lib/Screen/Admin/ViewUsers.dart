import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widget/themController.dart';


class AdminAllUsers extends StatefulWidget {
  const AdminAllUsers({super.key});

  @override
  State<AdminAllUsers> createState() => _AdminAllUsersState();
}

class _AdminAllUsersState extends State<AdminAllUsers> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [Row(
          children: [
            IconButton(
              onPressed: themeNotifier.toggleTheme,
              icon: Icon(themeNotifier.isDarkMode ? Icons.light_mode : Icons.dark_mode),
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


      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'customer')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Log the error for debugging
            print("Error: ${snapshot.error}");
            return Center(
              child: Text('Error fetching customers: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No customers found'),
            );
          }

          final customers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(
                  customer['username'] ?? 'No Username',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  "Email: ${customer['email'] ?? 'No Email'}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                //number
                trailing: Text(
                  "Phone: ${customer['mobile'] ?? 'No Phone'}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),

              );
            },
          );
        },
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
                color: themeNotifier.isDarkMode ? Colors.amber : Colors.amber,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/admin/customer/list');
              },
              icon: Icon(
                Icons.supervised_user_circle_sharp,
                color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
