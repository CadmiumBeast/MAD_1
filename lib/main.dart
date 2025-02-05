import 'package:cuisineconnect/Screen/homeCustomer.dart';
import 'package:cuisineconnect/Screen/Resturants/homeResturant.dart';
import 'package:cuisineconnect/Screen/login.dart';
import 'package:cuisineconnect/Screen/Resturants/resturantitem.dart';
import 'package:cuisineconnect/Screen/signin.dart';
import 'package:cuisineconnect/Screen/starting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cuisineconnect/Widget/themController.dart';

import 'Providers/location_provider.dart';
import 'Screen/Admin/AddRestaurant.dart';
import 'Screen/Admin/ViewUsers.dart';
import 'Screen/Admin/home.dart';
import 'Screen/customerPage.dart';
import 'Screen/profile.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModifier()),
        ChangeNotifierProvider(create: (_) => LocationProvider()), // Add LocationProvider here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeModifier>(
        builder: (Context, thememodfier, child) {
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
              '/profile' : (context) => const ProfilePage(),
              '/logout' : (context) => const Loginpage(),
              '/customer/home' : (context) => const HomeCustomer(),
              '/customer/cart' : (context) => const CartPage(),
              '/resturant/home' : (context) => const Homeresturant(),
              '/resturant/item' : (context) => const ResturantItems(),
              '/admin/home' : (context) => const AdminHome(),
              '/admin/restaurant/add' : (context) => const AdminAddRestaurant(),
              '/admin/customer/list' : (context) => const AdminAllUsers(),
            },
            initialRoute: '/',
            themeMode: thememodfier.currentTheme,
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
                    ),
                    titleLarge: TextStyle(
                        color: Colors.black,
                        fontSize: 24.00,
                        fontFamily: 'Outfit'
                    ),
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

              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  elevation: WidgetStateProperty.resolveWith<double>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return 4.0;
                      }
                      return 2.0;
                    },
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.grey[800]!;
                      }
                      return Colors.black;
                    },
                  ),
                ),
              ),
            ),


            darkTheme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.black,
                iconTheme: IconThemeData(
                  color: Colors.white
                )
              ),
                textTheme: const TextTheme(
                  bodyLarge: TextStyle(
                    color: Colors.white,
                    fontSize: 14.00,
                    fontFamily: 'Outfit',
                  ),
                  bodyMedium: TextStyle(
                    color: Colors.white,
                    fontSize: 16.00,
                    fontFamily: 'Outfit',
                  ),
                  headlineLarge: TextStyle(
                    color: Colors.white,
                    fontSize: 20.00,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                  ),
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
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                      textStyle: WidgetStateProperty.all<TextStyle>(
                          const TextStyle(

                              fontSize: 16.0,
                              fontFamily: 'Outfit'
                          )
                      )
                  )
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedIconTheme: IconThemeData(
                  color: Colors.white
                ),
                unselectedIconTheme: IconThemeData(
                  color: Colors.amber
                )
              )
            ),
            debugShowCheckedModeBanner: false,
          );
        }
    );
  }
}