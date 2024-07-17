import 'package:AP1/assets/colors.dart';
import 'package:AP1/pages/BUYING/product_description.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AP1/firebase/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:AP1/buttons/heart_button.dart';
import 'package:provider/provider.dart';
import 'package:AP1/pages/BUYING/products_provider.dart';
import 'package:AP1/pages/BUYING/favorite_provider.dart';
import 'package:AP1/pages/BUYING/buy_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FavoriteProductsPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  //final userID = user.email;
  String? getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  List<Product> getFavoriteProducts(ProductProvider productProvider, FavoritesProvider favoritesProvider) {
  List<Product> favoriteProducts = [];

  final userId = getCurrentUserId();

    // Fetch products and favorites lists
    List<Product> products = productProvider.products;
    List<Favorite> favorites = favoritesProvider.favorites;

    // Filter products that are in the favorites list
    for (var favorite in favorites) {
      for (var product in products) {
        if (product.idProduct == favorite.idProduct) {
          if(favorite.idUser == userId){
            favoriteProducts.add(product);
          }
            
        }
      }
    }

    return favoriteProducts;
  }

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightbeige,

      body: Consumer2<ProductProvider, FavoritesProvider>(
        builder: (context, productProvider, favoritesProvider, _) {
          if (productProvider.products.isEmpty) {
            productProvider.fetchProducts(); // Fetch products if the list is empty
            return Center(child: Text('No Products in the  products provider.'));
          } else if (favoritesProvider.favorites.isEmpty) {
            favoritesProvider.fetchFavorites(); // Fetch favorites if the list is empty
            return Center(child: Text('No Products in the  favorites provider.'));
          } else {
            List<Product> favoriteProducts = getFavoriteProducts(productProvider, favoritesProvider);

            if (favoriteProducts.isEmpty) {
              return Center(child: Text('No favorite products found.'));
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {

                  final product = favoriteProducts[index];
                  //
                  String? getCurrentUserId() {
                  final user = FirebaseAuth.instance.currentUser;
                  return user?.uid;
                  }
                  final userId = getCurrentUserId();
                  final isFavorite = favoritesProvider.favorites.any((favorite) =>
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
                            product: product,
                            favoritesProvider: favoritesProvider,
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
                                                    favoritesProvider.removeFavorite(product.idProduct, userId);
                                                  } else {
                                                    favoritesProvider.addFavorite(product.idProduct, userId);
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
  }}