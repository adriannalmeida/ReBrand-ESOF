import 'package:AP1/assets/colors.dart';
import 'package:AP1/assets/textField.dart';
import 'package:AP1/assets/warnig_messages.dart';
import 'package:AP1/buttons/not_buttons.dart';
import 'package:AP1/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController=TextEditingController();

  final TextEditingController surnameController=TextEditingController();

  final TextEditingController dateBirth=TextEditingController();

  final TextEditingController email=TextEditingController();

  final TextEditingController numberController=TextEditingController();

  final TextEditingController usernameController=TextEditingController();

  final TextEditingController passwordController=TextEditingController();

  final TextEditingController confirmPasswordController=TextEditingController();

  void register() async{
    showDialog(
        context: context,
        builder: (context)=> const Center(child: CircularProgressIndicator(),)
    );
    if(passwordController.text!=confirmPasswordController.text){
      Navigator.pop(context);
      messageUser("Password don't match", context);
    }
    try{
      UserCredential? userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: passwordController.text,);
      Navigator.pop(context);

      nameController.clear();
      surnameController.clear();
      dateBirth.clear();
      email.clear();
      numberController.clear();
      usernameController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );

    } on FirebaseAuthException catch(e){
      Navigator.pop(context);
      messageUser(e.code, context);
      print("b");
    }

  }

  void loginPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
  }

  @override
  Widget build( BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.lightgreen,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          //child: Column(
            child: SingleChildScrollView(
            //children: [
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              SizedBox(height: 85,),
              //username field
              MyTextField(
                controller: nameController,
                hintText: 'Name',
                hide: false),
              SizedBox(height:10,),
              MyTextField(
                controller: surnameController,
                hintText: 'Surname',
                hide: false),
                SizedBox(height:10,),
              MyTextField(
                controller: dateBirth,
                hintText: 'Birth date',
                hide: false),
              SizedBox(height:10,),
              MyTextField(
                controller: email,
                hintText: 'E-mail',
                hide: false),
              SizedBox(height:10,),
              MyTextField(
                controller: numberController,
                hintText: 'Phone number',
                hide: false),
                SizedBox(height:10,),
              MyTextField(
                controller:usernameController,
                hintText: 'Username',
                hide: false),
                SizedBox(height:10,),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                hide: true),
              SizedBox(height:10,),
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                hide: true),
              Text('Already have an account?',
                  style:TextStyle(
                    fontWeight: FontWeight.normal,
                  color: Colors.white,
                  ),),
              SizedBox(height:10,),

              plainButtons(
                onTap:()=>loginPage(context),
                text: "Login Here",
                ),

              SizedBox(height:25,),
              //nextButton

              ElevatedButton(
              onPressed: () => register(),
              // ignore: sort_child_properties_last
              child: Text(
                '  REGISTER   ',
                style:TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontFamily: 'GloriaFont',
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.brown), // Background color
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Text color
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)), // Padding
                elevation: MaterialStateProperty.all<double>(5), // Elevation (shadow)
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // BorderRadius.circular() for rounded corners
                    ),
                  ),
                ),
                ),
                ]
              ),
          ),
        )
      ),
    );
  }
}
