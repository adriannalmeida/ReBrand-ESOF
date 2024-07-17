import 'package:flutter/material.dart';
import 'package:AP1/assets/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:AP1/pages/choose.dart';
import 'package:AP1/pages/BUYING/products.dart';
import 'package:AP1/pages/BUYING/profile_page.dart';
import 'package:AP1/pages/BUYING/favorite_page.dart';
import 'package:AP1/pages/BUYING/buypage.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  void selectedIcon(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> listPage = [
    ProductsPage(),
    FavoriteProductsPage(),
    CartProductsPage(),
    ProfilePage(),
  ];

  Future<String> _loadImage(String imageName) async {
    try {
      return await FirebaseStorage.instance.ref(imageName).getDownloadURL();
    } catch (e) {
      print(e);
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.brown,
        actions: [
          FutureBuilder<String>(
            future: _loadImage('truelogo.png'), // Provide your image path here
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.error, color: Colors.red),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.network(
                  snapshot.data!,
                  width: 40, // Adjust width as needed
                  height: 40, // Adjust height as needed
                ),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // You can use any icon you want
            color: Colors.white, // Change the color of the back button
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChoosePage()));
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.brown,
        currentIndex: selectedIndex,
        onTap: selectedIcon,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, color: Colors.black, size: 35), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border_outlined, size: 35, color: Colors.black), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag, size: 35, color: Colors.black), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 35, color: Colors.black), label: '')
        ],
      ),
      body: listPage[selectedIndex],
    );
  }
}
