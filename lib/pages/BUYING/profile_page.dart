

import 'package:AP1/assets/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AP1/assets/colors.dart';
class ProfilePage extends StatefulWidget{

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void logout() async{
  FirebaseAuth.instance.signOut();
  Navigator.push(context,
    MaterialPageRoute(builder: (context) => AuthenticationPage()),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
         child:ElevatedButton(
            onPressed: () {
              logout();
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightgreen,
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(20),

              elevation: 5,
            ),
            child: Text(
              '    LOGOUT   ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                fontFamily: 'GloriaFont',
              ),
            ),
          ),
        ),
       );
  }
}