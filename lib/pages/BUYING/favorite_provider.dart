import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Favorite {
  final String idProduct;
  final String idUser;

  Favorite({
    required this.idProduct,
    required this.idUser,  
});
}

class FavoritesProvider extends ChangeNotifier {
  
  List<Favorite> _favorite=[];
  List<Favorite> _favorites = [];

  List<Favorite> get favorites => _favorites;

  void fetchFavorites() async {
    try {
      // Access Firestore collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Favorites').get();

      // Clear existing products list
      _favorites.clear();

      // Iterate over each document and create Product objects
      querySnapshot.docs.forEach((doc) {
        _favorites.add(Favorite(
          idProduct:doc['idProduct'],
          idUser:doc['idUser'],
        ));
      });

      // Notify listeners that the data has been fetched
      notifyListeners();
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  void addFavorite(String idProduct, String idUser) async {
    try {
      // Add the favorite to Firestore
      await FirebaseFirestore.instance.collection('Favorites').add({
        'idProduct': idProduct,
        'idUser': idUser,
      });
      // Update local list of favorites
      _favorites.add(Favorite(
        idProduct: idProduct,
        idUser: idUser,
      ));

      // Notify listeners about the change
      notifyListeners();
    } catch (error) {
      print('Error adding favorite: $error');
    }
  }

   void removeFavorite(String idProduct, String idUser) async {
    try {
      // Remove the favorite from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Favorites')
          .where('idProduct', isEqualTo: idProduct)
          .where('idUser', isEqualTo: idUser)
          .get();

      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });

      // Update local list of favorites
      _favorites.removeWhere((favorite) =>
          favorite.idProduct == idProduct && favorite.idUser == idUser);

      // Notify listeners about the change
      notifyListeners();
    } catch (error) {
      print('Error removing favorite: $error');
    }
  }
}


