import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:AP1/assets/colors.dart';
import 'package:AP1/pages/main_page.dart';
import 'package:AP1/pages/DONATION/donatemainpage.dart';

class ChoosePage extends StatelessWidget {
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
      body: Center(
        child: FutureBuilder<List<String>>(
          future: Future.wait([
            _loadImage('circle_pink.png'),
            _loadImage('circle_beige.png'),
            _loadImage('NAMEBRAND.png'),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.contains('')) {
              return Text('Error loading images');
            }
            final images = snapshot.data!;
            return Column(
              children: <Widget>[
                Container(
                  width: 600, // Set width to desired value
                  height: 600, // Set height to desired value
                  child: Stack(
                    children: <Widget>[
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
                        top: 325,
                        child: Image.network(images[2], width: 200),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.0), // Add some space between the images and the button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                  },
                  child: Text(
                    '   SHOP    ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'GloriaFont',
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.pink), // Background color
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)), // Padding
                    elevation: MaterialStateProperty.all<double>(5), // Elevation (shadow)
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // BorderRadius.circular() for rounded corners
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0), // Add some space between the images and the button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DonateMainPage()));
                  },
                  child: Text(
                    '   DONATE    ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'GloriaFont',
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.pink), // Background color
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)), // Padding
                    elevation: MaterialStateProperty.all<double>(5), // Elevation (shadow)
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // BorderRadius.circular() for rounded corners
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
