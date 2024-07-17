import 'package:flutter/material.dart';
import 'package:AP1/assets/colors.dart';
import 'package:AP1/firebase/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:AP1/pages/DONATION/associations_provider.dart';
import 'package:AP1/pages/DONATION/association_description.dart';
import 'package:AP1/pages/DONATION/donate_money_page.dart';
import 'package:AP1/pages/ThankPage.dart';

class AssociationPage extends StatelessWidget {
  final double donationAmount;
  final FirestoreService firestoreService = FirestoreService();

  AssociationPage({required this.donationAmount});

  String? getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<String> _getLogoImage() async {
    String logoURL = await FirebaseStorage.instance
        .ref()
        .child('truelogo.png') // Update with the actual path in Firebase Storage
        .getDownloadURL();
    return logoURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.brown,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FutureBuilder<String>(
              future: _getLogoImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Image.network(
                    snapshot.data!,
                    width: 40, // Adjust width as needed
                    height: 40, // Adjust height as needed
                  );
                }
              },
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DonateMoneyPage()),
            );
          },
        ),
      ),
      backgroundColor: AppColors.lightbeige,
      body: Consumer<AssociationProvider>(
        builder: (context, associationProvider, _) {
          if (associationProvider.associations.isEmpty) {
            associationProvider.fetchAssociations();
            return Center(child: Text('No data found'));
          } else {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: ListView.builder(
                  itemCount: associationProvider.associations.length,
                  itemBuilder: (context, index) {
                    final association = associationProvider.associations[index];
                    final userId = getCurrentUserId();
                    if (userId == null) {
                      return Center(child: Text('User not logged in'));
                    }
                    return GestureDetector(
                      child: FutureBuilder<String>(
                        future: _getImage(association.image),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (imageSnapshot.hasError) {
                            return Text('Error: ${imageSnapshot.error}');
                          } else {
                            return Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Text(
                                          association.name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'GloriaFont',
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        ClipOval(
                                          child: Image.network(
                                            imageSnapshot.data!,
                                            width: 180,
                                            height: 180,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (userId != null) {
                                              firestoreService.addMoneyDonate(donationAmount, association.name, userId);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ThankPage(),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text(
                                            'SELECT',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                              fontFamily: 'GloriaFont',
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(AppColors.pink),
                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                            elevation: MaterialStateProperty.all<double>(5),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AssociationDescription(
                                                  name: association.name,
                                                  description: association.description,
                                                  idAssociation: association.idAssociation,
                                                  image: association.image,
                                                  amount: donationAmount,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'KNOW MORE',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                              fontFamily: 'GloriaFont',
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(AppColors.lightgreen),
                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                            elevation: MaterialStateProperty.all<double>(5),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
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
