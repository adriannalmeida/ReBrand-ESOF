import 'package:AP1/assets/colors.dart';
import 'package:AP1/pages/BUYING/favorite_provider.dart';
import 'package:AP1/pages/BUYING/product_description.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AP1/firebase/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:AP1/buttons/heart_button.dart';
import 'package:AP1/pages/BUYING/profile_page.dart';
import 'package:AP1/pages/BUYING/favorite_page.dart';
import 'package:provider/provider.dart';
import 'package:AP1/pages/BUYING/products_provider.dart';
import 'package:AP1/pages/BUYING/favorite_provider.dart';
import 'package:AP1/pages/BUYING/buy_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductsPage extends StatelessWidget {

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightbeige,

      body: Consumer2<ProductProvider, FavoritesProvider>(
        builder: (context, productProvider, FavoritesProvider, _) {
          if (productProvider.products.isEmpty) {
            productProvider.fetchProducts(); // Fetch products if the list is empty
            return Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {

                  final product = productProvider.products[index];
                  String? getCurrentUserId() {
                  final user = FirebaseAuth.instance.currentUser;
                  return user?.uid;
                  }
                  final userId = getCurrentUserId();
                  final isFavorite = FavoritesProvider.favorites.any((favorite) =>
                      favorite.idProduct == product.idProduct && favorite.idUser == userId);
                  if (userId == null) {
                    return Center(child: Text('User not logged in')); // Ensure userId is non-null
                  }
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the product description page
                      cartProductsProvider cartProvider = cartProductsProvider();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDescription(
                            type_clothes:product.type_clothes,
                            size:product.size,
                            imageUrl:product.imageUrl,
                            price:product.price,
                            condition:product.price,
                            description:product.description,
                            product:product,
                            favoritesProvider: FavoritesProvider,
                            cartProvider: cartProvider,
                          ),
                        ),
                      );
                    },
                    child: FutureBuilder<String>(
                      future: _getImage(product.imageUrl),
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
                                  decoration: BoxDecoration(
                                    color: Color(0xFFCAB891), // Background color for the container
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2), // Shadow color
                                        spreadRadius: 1, // Spread radius
                                        blurRadius: 2, // Blur radius
                                        offset: Offset(0, 2), // Shadow offset
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ), // Round corners
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              imageSnapshot.data!,
                                              width: 150, // Adjust width as needed
                                              height: 150, // Adjust height as needed
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: HeartButton(
                                                onPressed: () {
                                                  if (isFavorite) {
                                                    FavoritesProvider.removeFavorite(product.idProduct, userId);
                                                  } else {
                                                    FavoritesProvider.addFavorite(product.idProduct, userId);
                                                  }
                                                },
                                                isFavorite: isFavorite,
                                                size:20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        product.type_clothes,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white, // Text color
                                          fontFamily:'Imprima',
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '  Size: ${product.size}        \$${product.price}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily:'Imprima',
                                          color: Colors.white, // Text color
                                        ),
                                      ),
                                      SizedBox(height: 8),
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
