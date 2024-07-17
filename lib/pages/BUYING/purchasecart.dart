import 'package:flutter/material.dart';

class PurchaseCart extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous route, the main page
            },
          ),
        ),
        body:Center(

          child: Text(
            'Thank you For The purchase! \nYour order will be sent soon!',
            style: TextStyle(fontSize: 24),
          ),
        )
    );
  }
}