import 'package:AP1/pages/BUYING/donation_decoration.dart';
import 'package:flutter/material.dart';
import 'package:AP1/assets/colors.dart';
import 'package:AP1/pages/BUYING/product_description.dart';
import 'package:AP1/firebase/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:AP1/pages/BUYING/products_provider.dart';
import 'package:AP1/pages/BUYING/favorite_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:AP1/pages/BUYING/buy_provider.dart';

class CartProductsPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  String? getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  List<Product> getCartProducts(ProductProvider productProvider, cartProductsProvider cartProvider) {
  List<Product> cartProducts = [];
  final userId = getCurrentUserId();
  List<Product> products = productProvider.products;
  List<cartProduct> cartSProducts = cartProvider.cartProducts;

  // Using a Set to track added product IDs
  Set<String> addedProductIds = {};

  for (var cartProduct in cartSProducts) {
    for (var product in products) {
      if (product.idProduct == cartProduct.idProduct && cartProduct.idUser == userId) {
        if (!addedProductIds.contains(product.idProduct)) {
          cartProducts.add(product);
          addedProductIds.add(product.idProduct);
        }
      }
    }
  }
  return cartProducts;
}
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightbeige,
    
      body: Consumer2<ProductProvider, cartProductsProvider>(
        builder: (context, productProvider, cartProvider, _) {
          if (productProvider.products.isEmpty) {
            productProvider.fetchProducts(); // Fetch products if the list is empty
            return Center(child: Text('No Products in the products provider.'));
          } else if (cartProvider.cartProducts.isEmpty) {
            cartProvider.fetchCartProducts();
            return Center(child: Text('No Products in the cart provider.'));
          } else {
            List<Product> cartProducts = getCartProducts(productProvider, cartProvider);

            if (cartProducts.isEmpty) {
              return Center(child: Text('No cart products found.'));
            }

            // Calculate total price
            double totalPrice = 0.0;
            for (Product cartproduct in cartProducts) {
              try {
                totalPrice += double.parse(cartproduct.price.replaceAll(',', '.'));
              } catch (e) {
                // Handle the parsing error, skip invalid price
                print('Error parsing price for product ${cartproduct.idProduct}: ${cartproduct.price}');
              }
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Your articles:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'GloriaFont'
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProducts.length,
                      itemBuilder: (context, index) {
                        final product = cartProducts[index];
                        final userId = getCurrentUserId();
                        final isFavorite = cartProvider.cartProducts.any((cartProduct) =>
                            cartProduct.idProduct == product.idProduct && cartProduct.idUser == userId);

                        if (userId == null) {
                          return Center(child: Text('User not logged in')); // Ensure userId is non-null
                        }

                        return GestureDetector(
                          onTap: () {
                            FavoritesProvider favoritesProvider = FavoritesProvider();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDescription(
                                  type_clothes: product.type_clothes,
                                  size: product.size,
                                  imageUrl: product.imageUrl,
                                  price: product.price,
                                  condition: product.condition,
                                  description: product.description,
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
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color:AppColors.brown, // Background color for the container
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
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          imageSnapshot.data!,
                                          width: 100, // Adjust width as needed
                                          height: 100, // Adjust height as needed
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.type_clothes,
                                              style: TextStyle(
                                                color: Colors.white, // Text color
                                                fontFamily: 'Imprima',
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Size: ${product.size}',
                                              style: TextStyle(
                                                color: Colors.white, // Text color
                                                fontFamily: 'Imprima',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '\$${product.price}',
                                          style: TextStyle(
                                            color: Colors.white, // Text color
                                            fontFamily: 'Imprima',
                                            fontSize: 16,
                                          ),
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
                  
                  ElevatedButton(
                      onPressed: () {
                    // Add your button onPressed logic here
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> DecorationPageDonation(donationAmount: totalPrice)));
                  },
                  child: Text(
                    '   Pay  -->  ',
                    style:TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'GloriaFont',
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.brown), // Background color
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)), // Padding
                    elevation: MaterialStateProperty.all<double>(5), // Elevation (shadow)
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // BorderRadius.circular() for rounded corners
                        ),
                      ),
                    ),
                ),
                SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color:AppColors.brown,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 2, // Blur radius
                          offset: Offset(0, -2), // Shadow offset
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price:',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Imprima',
                            fontSize: 18,
  
                          ),
                        ),
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Imprima',
                            fontSize: 18,
                            
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
  }

  Future<String> _getImage(String imageName) async {
    String imageURL = await FirebaseStorage.instance.ref().child(imageName).getDownloadURL();
    return imageURL;
  }
}
