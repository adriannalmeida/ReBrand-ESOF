import 'package:flutter/material.dart';
import 'package:AP1/assets/colors.dart'; 
import 'package:AP1/firebase/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssociationDescription extends StatelessWidget {
  final String idAssociation;
  final String image;
  final String description;
  final String name;
  final double amount;
  
  AssociationDescription({
    required this.idAssociation,
    required this.image,
    required this.description,
    required this.name,
    required this.amount,
  });

  final FirestoreService firestoreService = FirestoreService();
  String? getCurrentUserId() {
      final user = FirebaseAuth.instance.currentUser;
      return user?.uid;
  } Future<String> _loadImage(String imageName) async {
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
                Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: AppColors.lightbeige,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<String>(
                future: _getImage(image),
                builder: (context, imageSnapshot) {
                  if (imageSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (imageSnapshot.hasError) {
                    return Text('Error: ${imageSnapshot.error}');
                  } else {
                    return Column(
                      children: [
                        SizedBox(height: 10), // Adjust height as needed
                        Text(
                          'Please select the charity Associations that you want to donate to.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Imprima',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        ClipOval(
                          child: Image.network(
                            imageSnapshot.data!,
                            width: 180, // Adjust width as needed
                            height: 180, // Adjust height as needed
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'GloriaFont',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Imprima',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  final userId = getCurrentUserId();
                  if (userId != null) {

                    firestoreService.addMoneyDonate(amount, name, userId);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  '    DONATE    ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'GloriaFont',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _getImage(String imageName) async {
    String imageURL = await FirebaseStorage.instance
        .ref()
        .child(imageName)
        .getDownloadURL();
    return imageURL;
  }
}