// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:io';
//
// import '../Widget/themController.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   File? _profileImage;
//   String _currentLocation = "Fetching location...";
//
//   // Method to pick an image from the gallery
//   Future<void> _pickImageFromGallery() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//       if (pickedFile != null) {
//         setState(() {
//           _profileImage = File(pickedFile.path);
//         });
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }
//
//   // Method to fetch current location
//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         setState(() {
//           _currentLocation = "Location services are disabled.";
//         });
//         return;
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           setState(() {
//             _currentLocation = "Location permissions are denied.";
//           });
//           return;
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           _currentLocation =
//           "Location permissions are permanently denied. Cannot access location.";
//         });
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//
//       setState(() {
//         _currentLocation =
//         "Lat: ${position.latitude}, Lon: ${position.longitude}";
//       });
//     } catch (e) {
//       setState(() {
//         _currentLocation = "Error fetching location: $e";
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeNotifier = Provider.of<ThemeModifier>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Image(
//           image: AssetImage(
//             themeNotifier.isDarkMode
//                 ? 'asset/images/dark_logo.png'
//                 : 'asset/images/logo.png',
//           ),
//           width: 110,
//           height: 80,
//         ),
//         actions: [
//           IconButton(
//             onPressed: themeNotifier.toggleTheme,
//             icon: Icon(
//               themeNotifier.isDarkMode ? Icons.light_mode : Icons.dark_mode,
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             GestureDetector(
//               onTap: _pickImageFromGallery,
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage: _profileImage != null
//                     ? FileImage(_profileImage!) as ImageProvider
//                     : const AssetImage('asset/images/avatar.png'),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ListTile(
//               title: Text(
//                 'My Location',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               subtitle: Text(
//                 _currentLocation,
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ),
//             const Divider(),
//             ListTile(
//               title: Text(
//                 'Profile',
//                 style: Theme.of(context).textTheme.headlineLarge,
//               ),
//               subtitle: Text(
//                 'Shakeel Ahamed Shajahan',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               trailing: Text(
//                 'Edit',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ),
//             const Divider(),
//             ListTile(
//               title: Text(
//                 'Email',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               subtitle: Text(
//                 'ShakeelShajahan212@gmail.com',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//               trailing: Text(
//                 'Edit',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ),
//             const Divider(),
//             ListTile(
//               title: Text(
//                 'Phone Number',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               subtitle: Text(
//                 '0771234567',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//               trailing: Text(
//                 'Edit',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ),
//             const Divider(),
//             ListTile(
//               title: Text(
//                 'Address',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               subtitle: Text(
//                 'Colombo-07',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//               trailing: Text(
//                 'Edit',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             IconButton(
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, '/customer/home');
//               },
//               icon: const Icon(Icons.home),
//               color:
//               themeNotifier.isDarkMode ? Colors.white : Colors.black,
//             ),
//             IconButton(
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, '/customer/cart');
//               },
//               icon: const Icon(Icons.shopping_cart),
//               color: Colors.amber,
//             ),
//             IconButton(
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, '/orderList');
//               },
//               icon: const Icon(Icons.list),
//               color: Colors.amber,
//             ),
//             IconButton(
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, '/profile');
//               },
//               icon: const Icon(Icons.person),
//               color: Colors.amber,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../Widget/themController.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String _currentLocation = "Fetching location...";

  // Method to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Method to fetch current location
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentLocation = "Location services are disabled.";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentLocation = "Location permissions are denied.";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentLocation =
          "Location permissions are permanently denied. Cannot access location.";
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentLocation =
        "Lat: ${position.latitude}, Lon: ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        _currentLocation = "Error fetching location: $e";
      });
    }
  }

  // Method to open dialer when phone number is tapped
  Future<void> _callPhoneNumber(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not launch phone dialer");
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Image(
          image: AssetImage(
            themeNotifier.isDarkMode
                ? 'asset/images/dark_logo.png'
                : 'asset/images/logo.png',
          ),
          width: 110,
          height: 80,
        ),
        actions: [
          IconButton(
            onPressed: themeNotifier.toggleTheme,
            icon: Icon(
              themeNotifier.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImageFromGallery,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!) as ImageProvider
                    : const AssetImage('asset/images/avatar.png'),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                'My Location',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                _currentLocation,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Profile',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              subtitle: Text(
                'Shakeel Ahamed Shajahan',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Text(
                'Edit',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Email',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                'ShakeelShajahan212@gmail.com',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Text(
                'Edit',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Phone Number',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: GestureDetector(
                onTap: () {
                  _callPhoneNumber("0771234567");
                },
                child: Text(
                  '0771234567',
                  style: TextStyle(
                    color: Colors.blue, // Makes it look like a clickable link
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              trailing: Text(
                'Edit',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Divider(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/customer/home');
              },
              icon: const Icon(Icons.home),
              color:
              themeNotifier.isDarkMode ? Colors.white : Colors.black,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/customer/cart');
              },
              icon: const Icon(Icons.shopping_cart),
              color: Colors.amber,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/orderList');
              },
              icon: const Icon(Icons.list),
              color: Colors.amber,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/profile');
              },
              icon: const Icon(Icons.person),
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
