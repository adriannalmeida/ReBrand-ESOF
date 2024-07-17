import 'package:AP1/assets/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DecorationPageLogin extends StatelessWidget {
  const DecorationPageLogin({super.key});

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

    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthenticationPage()),
      );
    });

    return Scaffold(
      backgroundColor: backColor,
      body: Center(
        child: FutureBuilder<List<String>>(
          future: Future.wait([
            _loadImage('circle_pink.png'),
            _loadImage('circle_beige.png'),
            _loadImage('NAMEBRAND.png'),
            _loadImage('text_below.png')
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.contains('')) {
              return const Text('Error loading images');
            }
            final images = snapshot.data!;
            return Stack(
              alignment: Alignment.center,
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
                Positioned(
                  left: 100,
                  top: 500,
                  child: Image.network(images[3], width: 200),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
