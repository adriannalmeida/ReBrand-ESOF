import 'package:flutter/material.dart';
import 'package:AP1/assets/colors.dart'; 
import 'package:AP1/pages/BUYING/purchasecart.dart';
import 'package:AP1/firebase/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:AP1/buttons/heart_button.dart';
import 'package:AP1/pages/BUYING/products_provider.dart';
import 'package:AP1/pages/BUYING/favorite_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:AP1/pages/BUYING/buy_provider.dart';


class ProductDescription extends StatelessWidget {
  final String type_clothes;
  final String size;
  final String imageUrl;
  final String price;
  final String condition;
  final String description;
  final Product product;
  final FavoritesProvider favoritesProvider;
  final cartProductsProvider cartProvider;

  ProductDescription({
    required this.type_clothes,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.condition,
    required this.description,
    required this.product,
    required this.favoritesProvider,
    required this.cartProvider,
  });

  final FirestoreService firestoreService = FirestoreService();
  Future<String> _loadImage(String imageName) async {
      try {
        return await FirebaseStorage.instance.ref(imageName).getDownloadURL();
      } catch (e) {
        print(e);
        return '';
      }
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

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final isFavorite = favoritesProvider.favorites.any((favorite) =>
      favorite.idProduct == product.idProduct && favorite.idUser == userId);
    final inCart = cartProvider.cartProducts.any((cartProduct) =>
      cartProduct.idProduct == product.idProduct && cartProduct.idUser == userId);
    if (userId == null) {
      return Center(child: Text('User not logged in')); // Ensure userId is non-null
    }

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            FutureBuilder<String>(
              future: _getImage(imageUrl),
              builder: (context, imageSnapshot) {
                if (imageSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (imageSnapshot.hasError) {
                  return Text('Error: ${imageSnapshot.error}');
                } else {
                  return Stack(
                     children: [
                      Container(
                        width: double.infinity,
                        height: 400, // Set the height of the container according to your image size
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageSnapshot.data!), // Use the image URL here
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color
                              spreadRadius: 3, // Spread radius
                              blurRadius: 7, // Blur radius
                              offset: Offset(0, 3), // Offset of the shadow
                            ),
                          ],
                        ),
                      ),
                       Positioned(
                          bottom: 10,
                          right: 10,
                          child: HeartButton(
                            onPressed: () {
                              if (isFavorite) {
                                favoritesProvider.removeFavorite(product.idProduct, userId!);
                              } else {
                                favoritesProvider.addFavorite(product.idProduct, userId!);
                              }
                            },
                            isFavorite: isFavorite,
                            size: 20,
                          ),
                        ),
                    ],
                  );

                }
              },
            ),
            SizedBox(height:30),
            Padding(
              padding: EdgeInsets.only(left: 15,),

             child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$type_clothes               $price\$',
                style: TextStyle(color: Colors.black,
                  fontSize: 15,
                ),
                
              ),
              Text(
                'Size: $size',
                style: TextStyle(color: Colors.black,
                  fontSize: 15,),
              ),
              Text(
                'Condition: $condition',
                style: TextStyle(color: Colors.black
                ,fontSize: 15,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '$description',
                style: TextStyle(color: Colors.black,
                fontSize:15,
                ),
                
              ),
            ],
          ),
        ),
        SizedBox(height: 100),
        
        Positioned(
          bottom: 10,
          right: 0,
          child: ElevatedButton(
          onPressed: () {
             if (inCart) {
               cartProvider.removecartProducts(product.idProduct, userId);
              } else {
               cartProvider.addcartProducts(product.idProduct, userId);
              }
            },
            style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.lightgreen,
      foregroundColor: Colors.white,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 5,
    ),
    child: Text(
      inCart ? 'REMOVE FROM CART' : 'ADD TO CART',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        fontFamily: 'GloriaFont',
      ),
    ),
  ),
),

      ],
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
