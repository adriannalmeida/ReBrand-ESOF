import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:AP1/assets/colors.dart';
import 'package:AP1/pages/choose.dart';
import 'package:AP1/pages/DONATION/donateclothespage.dart';
import 'package:AP1/pages/DONATION/donate_money_page.dart';
import 'package:AP1/pages/DONATION/partners_page.dart';

class DonateMainPage extends StatefulWidget {
  const DonateMainPage({Key? key}) : super(key: key);

  @override
  State<DonateMainPage> createState() => _DonateMainPageState();
}

class _DonateMainPageState extends State<DonateMainPage> {
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
    Color backColor = AppColors.lightbeige;

    return Scaffold(
      backgroundColor: backColor, // main page background color
      appBar: AppBar(
        backgroundColor: backColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // You can use any icon you want
            color: AppColors.brown, // Change the color of the back button
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChoosePage()));
          },
        ),
      ),
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
                  width: 600,
                  height: 400,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: 0.0,
                        top: 0.0,
                        child: Image.network(images[0], width: 250),
                      ),
                      Positioned(
                        right: 170.0,
                        top: 100.0,
                        child: Image.network(images[1], width: 250),
                      ),
                      Positioned(
                        left: 100,
                        top: 200,
                        child: Image.network(images[2], width: 200),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0), // Add some space between the images and the button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DonateClothesPage()));
                  },
                  child: Text(
                    '   CLOTHES    ',
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DonateMoneyPage()));
                  },
                  child: Text(
                    '   MONEY    ',
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
                SizedBox(height: 40.0), // Add some space between the images and the button
                ElevatedButton(
                  onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PartnersPage()));
                    // Add your button onPressed logic here
                  },
                  child: Text(
                    '   OUR PARTNERS    ',
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