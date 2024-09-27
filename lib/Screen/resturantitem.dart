import 'package:flutter/material.dart';

class ResturantItems extends StatefulWidget {
  const ResturantItems({super.key});

  @override
  State<ResturantItems> createState() => _ResturantItemsState();
}

class _ResturantItemsState extends State<ResturantItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Image(image: AssetImage('asset/images/logo.png'),
      width: 110, height: 80,
      ),
      actions: [
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
                IconButton(onPressed: (){}, icon: const Icon(
                  Icons.add,
                  size: 30,
                  
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
                }, icon: const Icon(Icons.home), color: Colors.black,),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: IconButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/customer/cart');
                }, icon: const Icon(Icons.shopping_cart)),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: IconButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/orderList');
                }, icon: const Icon(Icons.list)),
              ),
            ],
            
           )
        
    ),
    );
  }
}