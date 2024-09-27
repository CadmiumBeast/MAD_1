import 'package:cuisineconnect/Screen/homeCustomer.dart';
import 'package:cuisineconnect/Screen/homeResturant.dart';
import 'package:cuisineconnect/Screen/login.dart';
import 'package:cuisineconnect/Screen/resturantitem.dart';
import 'package:cuisineconnect/Screen/signin.dart';
import 'package:cuisineconnect/Screen/starting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return GetMaterialApp(
      routes: {
        '/' : (context) => const StartingPage(),
        '/login' : (context) => const Loginpage(),
        '/register' : (context) => const SignIn(),
        '/customer/home' : (context) => const HomeCustomer(),
        '/resturant/home' : (context) => const Homeresturant(),
        '/resturant/item' : (context) => const ResturantItems(),

      },
      initialRoute: '/',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 12.00,
            fontFamily: 'Outfit'
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 16.00,
            fontFamily: 'Outfit'
          ),
          bodySmall: TextStyle(
            color: Colors.black,
            fontSize: 14.00,
            fontFamily: 'Outfit'
          ),
          headlineLarge: TextStyle(
            color: Colors.black,
            fontSize: 20.00, 
            fontFamily: 'Outfit'
          )
        ),

        inputDecorationTheme:const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
          )
        
        ),

        elevatedButtonTheme:ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(
                
                fontSize: 16.0,
                fontFamily: 'Outfit'
              )
            )
          )
        )
        

      ),
      darkTheme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 18.00,
            fontFamily: 'Outfit'
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 16.00,
            fontFamily: 'Outfit'
          ),
          bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 14.00,
            fontFamily: 'Outfit'
          )

        ), 
        inputDecorationTheme:const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          ),
          )
        
        ),
      ),
      debugShowCheckedModeBanner: false,      
    );
  }
}
