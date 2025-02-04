import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cuisineconnect/Widget/themController.dart';

//Cart page for the customer

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
            themeNotifier.toggleTheme();
          }, icon: Icon(themeNotifier.isDarkMode ?  Icons.light_mode : Icons.dark_mode)) ,
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
              title: Text('Sultan Palace',
                  style: Theme.of(context).textTheme.headlineLarge),
              subtitle: Text('Multi-Cuisine',
                  style: Theme.of(context).textTheme.bodyMedium),
              trailing: Text('Colombo-07',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            const Divider(),
            ListTile(
              title: Text('Kottu Roti',
                  style: Theme.of(context).textTheme.bodyMedium),
              subtitle: Text('LKR 500.00',
                  style: Theme.of(context).textTheme.bodySmall),
              trailing: Text('1',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            const Divider(),
            ListTile(
              title: Text('Chicken Fried Rice',
                  style: Theme.of(context).textTheme.bodyMedium),
              subtitle: Text('LKR 600.00',
                  style: Theme.of(context).textTheme.bodySmall),
              trailing: Text('1',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            const Divider(),
            ListTile(
              title: Text('Total',
                  style: Theme.of(context).textTheme.headlineLarge),
              trailing: Text('LKR 1100.00',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            const SizedBox(height: 10),
        Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/customer/home');
              },
              child: Text(
                'Checkout',
              ),
            );
          },
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
                child: IconButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/customer/home');
                }, icon: Icon(Icons.home), color: themeNotifier.isDarkMode ?
                Colors.amber : Colors.amber),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: IconButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/customer/cart');
                }, icon:  Icon(Icons.shopping_cart,color: themeNotifier.isDarkMode ?
                Colors.white : Colors.black,)),
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
