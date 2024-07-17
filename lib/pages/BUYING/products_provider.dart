import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Product {
  final String idProduct;
  final String type_clothes;
  final String size;
  final String imageUrl;
  final String price;
  final String condition;
  final String description;

  Product({
    required this.idProduct,
    required this.type_clothes,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.condition,
    required this.description,
  });
  
  double get priceAsDouble {
    try {
      return double.parse(price);
    } catch (e) {
      // Handle the parsing error, return 0.0 or any default value
      return 0.0;
    }
  }
}


class ProductProvider extends ChangeNotifier {
  
  List<Product> _product=[];
  List<Product> _products = [];

  List<Product> get products => _products;

   

  void fetchProducts() async {
    try {
      // Access Firestore collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Products').get();

      // Clear existing products list
      _products.clear();

      // Iterate over each document and create Product objects
      querySnapshot.docs.forEach((doc) {
        _products.add(Product(
          idProduct:doc['idProduct'] ,
          type_clothes:doc['type_clothes'],
          size:doc['size'],
          imageUrl:doc['image'],
          price:doc['price'],
          condition:doc['condition'],
          description:doc['description'],
        ));
      });

      // Notify listeners that the data has been fetched
      notifyListeners();
    } catch (error) {
      print('Error fetching products: $error');
    }
  }
}

