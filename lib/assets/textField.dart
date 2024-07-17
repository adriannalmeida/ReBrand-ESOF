import 'package:flutter/material.dart';
import 'package:AP1/assets/colors.dart';
class MyTextField extends StatelessWidget{
  final controller;
  final String hintText;
  final bool hide;
  final Color borderColor;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.hide,
    this.borderColor=AppColors.beige,
  });

  @override
  Widget build(BuildContext context){
    return Padding(
                padding:const EdgeInsets.symmetric(horizontal: 50.0),
                child:TextField(
                  controller: controller,
                  obscureText: hide,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.lightbeige),
                      borderRadius:BorderRadius.circular(30.0),
                      ),
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color:AppColors.lightbrown,
                      fontFamily: 'Imprima',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      ),
                    fillColor: AppColors.lightbeige,
                    filled: true,
                
                  ),
                )

              );
  }
}