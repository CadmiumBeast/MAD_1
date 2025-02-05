import 'package:flutter/material.dart';
import 'package:cuisineconnect/main.dart';
import 'package:provider/provider.dart';

import '../../Widget/themController.dart';

class ResturantItems extends StatefulWidget {
  const ResturantItems({super.key});

  @override
  State<ResturantItems> createState() => _ResturantItemsState();
}
//cart item remove button , couupons to add
class _ResturantItemsState extends State<ResturantItems> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModifier>(context);
    return Scaffold(
      appBar: AppBar(
       title: Image(image: AssetImage(themeNotifier.isDarkMode ?'asset/images/dark_logo.png' : 'asset/images/logo.png'),
        width: 110, height: 80,
        ),
        actions: [
          IconButton(onPressed: (){
            themeNotifier.toggleTheme();},
              icon: Icon(themeNotifier.isDarkMode ?  Icons.light_mode : Icons.dark_mode)) ,
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

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text('Sultan Palace',
            style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text('Multi-Cuisine',
            style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text('Colombo-07',
            style: Theme.of(context).textTheme.bodySmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(image: AssetImage('asset/images/kottu.png'),
                width: 100.00, height: 100.00,),
                Text('Kottu Roti',
                style: Theme.of(context).textTheme.bodyMedium,
                ),
                IconButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/customer/home');
                }, icon:  Icon(
                  Icons.add,
                  size: 30,
                  color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                ))
              ],
            )
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