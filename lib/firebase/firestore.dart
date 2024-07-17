import 'package:AP1/pages/DONATION/Donation_money.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AP1/pages/DONATION/Donation_clothes.dart';

class FirestoreService{

  final CollectionReference products= FirebaseFirestore.instance.collection('Products');

  final CollectionReference donation_clothes= FirebaseFirestore.instance.collection('Donations_Clothes');

  final CollectionReference donation_money= FirebaseFirestore.instance.collection('Donations_money');

  
  Stream<QuerySnapshot> getProductsStream(){
    final productsStream=products.snapshots();
    return productsStream;
  }

  Stream<QuerySnapshot> getDonationClothes(){
    final dClothesStream=donation_clothes.snapshots();
    return dClothesStream;
  }

  Stream<QuerySnapshot> getDonationMoney(){
    final dMoneyStream=donation_money.snapshots();
    return dMoneyStream;
  }

  Future<void> addClothesDonate(Donations_Clothes clothes){
    return donation_clothes.add({
      'category':  clothes.category,
      'condition': clothes.condition,
      'fit_type': clothes.fit_type,
      'gender': clothes.gender,
      'size':clothes.size,
      'style':clothes.style,
    });
  }

  Future<void> addMoneyDonate(double amount, String association, String userId){
    return donation_money.add({
      'amount':amount,
      'association':association,
      'userId':userId,
    });
  }

}