import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Association {
  final String idAssociation;
  final String image;
  final String description;
  final String name;
  
  Association({
    required this.idAssociation,
    required this.image,
    required this.description,
    required this.name,
  });
}

class AssociationProvider extends ChangeNotifier {
  
  List<Association> _association=[];
  List<Association> _associations = [];

  List<Association> get associations => _associations;

  void fetchAssociations() async {
    try {
      // Access Firestore collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Associations').get();

      // Clear existing products list
      _associations.clear();

      // Iterate over each document and create Product objects
      querySnapshot.docs.forEach((doc) {
        _associations.add(Association(
          idAssociation:doc['idAssociation'] ,
          image:doc['image'],
          name:doc['name'],
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

