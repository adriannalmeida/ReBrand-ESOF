import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:AP1/assets/colors.dart';
import 'package:AP1/pages/BUYING/products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AP1/firebase/firestore.dart';
import 'package:AP1/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:AP1/pages/DONATION/donatemainpage.dart';
import 'package:AP1/pages/DONATION/association_page.dart';

class DonateMoneyPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  TextEditingController _controller = TextEditingController();

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
    Color backColor = Color(0xFF97AA78);

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: backColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.brown,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DonateMainPage()));
          },
        ),
      ),
      body: Stack(
        children: [
          // Foreground widgets
          Positioned(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).size.height / 4,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Choose the amount of the donation: ',
                  labelStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: 'GloriaFont',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).size.height / 2.5,
            child: ElevatedButton(
              onPressed: () {
                double donationAmount = double.tryParse(_controller.text) ?? 0.0;
                Navigator.push(context, MaterialPageRoute(builder: (context) => AssociationPage(donationAmount: donationAmount)));
              },
              child: Text(
                'Donate',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontFamily: 'GloriaFont',
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.pink),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
                elevation: MaterialStateProperty.all<double>(5),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),

          // Background widgets (added last to be on top)
          FutureBuilder<List<String>>(
            future: Future.wait([
              _loadImage('circle_pink.png'),
              _loadImage('circle_beige.png'),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(); // Placeholder while loading
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.contains('')) {
                return SizedBox(); // Placeholder for error
              }
              final images = snapshot.data!;
              return Positioned(
                right: 0.0,
                top: 0,
                child: Image.network(images[0], width: 190),
              );
            },
          ),
          FutureBuilder<String>(
            future: _loadImage('circle_beige.png'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(); // Placeholder while loading
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return SizedBox(); // Placeholder for error
              }
              return Positioned(
                right: 250.0,
                top: 500.0,
                child: Image.network(snapshot.data!, width: 190),
              );
            },
          ),
        ],
      ),
    );
  }
}
