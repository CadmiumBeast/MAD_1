import 'package:cuisineconnect/Screen/Resturants/resturantitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/location_provider.dart';
import '../../Widget/themController.dart';
import 'AddItem.dart';

class Homeresturant extends StatefulWidget {
  final String resturantid;
  const Homeresturant({super.key, required this.resturantid});

  @override
  State<Homeresturant> createState() => _HomeresturantState();
}

class _HomeresturantState extends State<Homeresturant> {

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModifier>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Orders'),
        actions: [Row(
          children: [
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
      body: const Center(
        child: Text('Restaurant Orders'),
      ),
      bottomNavigationBar: buildBottomNavigationBar(themeNotifier),
    );
  }

  // Bottom Navigation Bar With 3 Tabs (Order, Items, Add Items)
  Widget buildBottomNavigationBar(ThemeModifier themeNotifier) {
    return Container(
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
              Colors.white : Colors.black,),
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
              Colors.amber : Colors.amber)),
            ),
          ],

        ),
    );

  }
}