import 'package:flutter/material.dart';

class plainButtons extends StatelessWidget{

  final Function()? onTap;
  final String text;
  plainButtons({super.key, required this.onTap,required this.text});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
    onTap: onTap,
    child:Container(
      child: Text(
        text, 
        style:TextStyle(
          color: Colors.white,
          fontFamily: 'Imprima',
          fontSize: 16
          )
      ),
    )
  );
  }
}