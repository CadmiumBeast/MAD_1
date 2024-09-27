import 'package:flutter/material.dart';

class HomeCustomer extends StatefulWidget {
  const HomeCustomer({super.key});

  @override
  State<HomeCustomer> createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {
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

      body: GridView.builder(gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1, 
        ),
        itemCount: 9,
        itemBuilder: (context , index){
          return GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/resturant/item');
            },
            child: Container(
              child: Column(
                children: [
                  Image(image: AssetImage('asset/images/sultan.png')),
                  Text('Sultan Palace',
                  style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text('Multi-Cuisine',
                  style: Theme.of(context).textTheme.bodySmall),
                  Text('Colombo-07', 
                  style: Theme.of(context).textTheme.bodyLarge)
                ],
              ),
            ),
          );
        },
        padding: const EdgeInsets.all(10),
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