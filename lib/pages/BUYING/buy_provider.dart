import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class cartProduct {
  final String idProduct;
  final String idUser;

  cartProduct({
    required this.idProduct,
    required this.idUser,  
});
}

class cartProductsProvider extends ChangeNotifier {
  
  List<cartProduct> _cartProducts=[];
  List<cartProduct> _cartProduct = [];

  List<cartProduct> get cartProducts => _cartProducts;

  void fetchCartProducts() async {
    try {
      // Access Firestore collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('CartProducts').get();

      // Clear existing products list
      _cartProducts.clear();

      // Iterate over each document and create Product objects
      querySnapshot.docs.forEach((doc) {
        _cartProducts.add(cartProduct(
          idProduct:doc['idProduct'],
          idUser:doc['idUser'],
        ));
      });

      // Notify listeners that the data has been fetched
      notifyListeners();
    } catch (error) {
      print('Error fetching cartProducts: $error');
    }
  }

  void addcartProducts(String idProduct, String idUser) async {
    try {
      // Add the favorite to Firestore
      await FirebaseFirestore.instance.collection('CartProducts').add({
        'idProduct': idProduct,
        'idUser': idUser,
      });
      // Update local list of favorites
      _cartProducts.add(cartProduct(
        idProduct: idProduct,
        idUser: idUser,
      ));

      // Notify listeners about the change
      notifyListeners();
    } catch (error) {
      print('Error adding favorite: $error');
    }
  }

   void removecartProducts(String idProduct, String idUser) async {
    try {
      // Remove the favorite from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cartProducts')
          .where('idProduct', isEqualTo: idProduct)
          .where('idUser', isEqualTo: idUser)
          .get();

      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });

      // Update local list of favorites
      _cartProducts.removeWhere((cartProduct) =>
          cartProduct.idProduct == idProduct && cartProduct.idUser == idUser);

      // Notify listeners about the change
      notifyListeners();
    } catch (error) {
      print('Error removing favorite: $error');
    }
  }
}