import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widget/themController.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    //profile page
    final themeNotifier = Provider.of<ThemeModifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Image(image: AssetImage(themeNotifier.isDarkMode
            ? 'asset/images/dark_logo.png'
            : 'asset/images/logo.png'),
          width: 110, height: 80,
        ),
        actions: [
          IconButton(onPressed: () {
            themeNotifier.toggleTheme();
          },
              icon: Icon(themeNotifier.isDarkMode ? Icons.light_mode : Icons
                  .dark_mode)),
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/profile'),

            child: const Padding(padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('asset/images/avatar.png'),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            ListTile(
              title: Text('Profile',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineLarge),
              subtitle: Text('Shakeel Ahamed Shajahan',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
              trailing: Text('Edit',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall),
            ),
            const Divider(),
            ListTile(
              title: Text('Email',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
              subtitle: Text('ShakeelShajahan212@gmail.com',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall),
              trailing: Text('Edit',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall),
            ),
            const Divider(),
            ListTile(
              title: Text('Phone Number',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
              subtitle: Text('0771234567',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall),
              trailing: Text('Edit',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall),
            ),
            const Divider(),
            ListTile(
              title: Text('Address',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
              subtitle: Text('Colombo-07',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall),
              trailing: Text('Edit',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: IconButton(onPressed: () {
                Navigator.pushReplacementNamed(context, '/customer/home');
              }, icon: Icon(Icons.home), color: themeNotifier.isDarkMode
                  ? Colors.white
                  : Colors.black,),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: IconButton(onPressed: () {
                Navigator.pushReplacementNamed(context, '/customer/cart');
              }, icon: Icon(Icons.shopping_cart, color: themeNotifier.isDarkMode
                  ? Colors.amber
                  : Colors.amber)),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: IconButton(onPressed: () {
                Navigator.pushReplacementNamed(context, '/orderList');
              }, icon: Icon(Icons.list, color: themeNotifier.isDarkMode
                  ? Colors.amber
                  : Colors.amber)),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: IconButton(onPressed: () {
                Navigator.pushReplacementNamed(context, '/profile');
              }, icon: Icon(Icons.person, color: themeNotifier.isDarkMode
                  ? Colors.amber
                  : Colors.amber)),
            ),
          ],
        ),
      ),
    );
  }
}
