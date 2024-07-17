import 'package:flutter/material.dart';
import 'package:AP1/assets/colors.dart';

//
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
import 'package:firebase_auth/firebase_auth.dart';

//

class HeartButton extends StatefulWidget {
  final Function() onPressed;
  final bool isFavorite;
  double size;

  HeartButton({required this.onPressed, required this.isFavorite ,required this.size,});

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  late bool selected;
  @override

  void initState(){
    super.initState();
    selected = widget.isFavorite;
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap:() {
        setState(() {
          selected=!selected;
        });
        widget.onPressed();
      }, 
      child: Container(
        
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.brown,
           boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 2, // Blur radius
              offset: Offset(0, 2), // Shadow offset
            ),
          ],
          ),
        child: Icon(
          selected ? Icons.favorite : Icons.favorite_border,
          color:Colors.white,
          size: widget.size,
        ),
      ),
    );
  }
}
