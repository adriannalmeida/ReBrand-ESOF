import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:AP1/pages/DONATION/association_page.dart';

class DecorationPageDonation extends StatelessWidget {
  final double donationAmount;

  const DecorationPageDonation({Key? key, required this.donationAmount});

  Future<List<String>> _loadImages(List<String> imageNames) async {
    List<String> imageUrls = [];
    try {
      for (String imageName in imageNames) {
        String imageUrl = await FirebaseStorage.instance.ref(imageName).getDownloadURL();
        imageUrls.add(imageUrl);
      }
    } catch (e) {
      print(e);
    }
    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Color(0xFF97AA78);

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AssociationPage(donationAmount: donationAmount)),
      );
    });

    return Scaffold(
      backgroundColor: backColor,
      body: Center(
        child: FutureBuilder<List<String>>(
          future: _loadImages(['circle_pink.png', 'circle_beige.png', 'text_below.png']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Text('Error loading images');
            }
            final images = snapshot.data!;
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Text(
                  'All the money that you will spend in this purchase will be donated to the charity of your choice!',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'GloriaFont'),
                ),
                Positioned(
                  right: 0.0,
                  top: 200.0,
                  child: Image.network(images[0], width: 250),
                ),
                Positioned(
                  left: 0.0,
                  top: 125.0,
                  child: Image.network(images[1], width: 250),
                ),
                Positioned(
                  left: 100,
                  top: 500,
                  child: Image.network(images[2], width: 200),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
