import 'package:AP1/pages/choose.dart';
import 'package:AP1/pages/decoration_page_login.dart';
import 'package:AP1/pages/login_page.dart';
import 'package:AP1/pages/main_page.dart';
import 'package:AP1/pages/BUYING/products.dart';
import 'package:AP1/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthenticationPage extends StatefulWidget{
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool showLoginPage=true;

  void tooglePages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context){
    if(showLoginPage){
      return LoginPage();
    }
    else{
      return RegisterPage();
    }
  }
}