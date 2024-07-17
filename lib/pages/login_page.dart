import 'package:AP1/assets/colors.dart';
import 'package:AP1/assets/textField.dart';
import 'package:AP1/assets/warnig_messages.dart';
import 'package:AP1/buttons/not_buttons.dart';
import 'package:AP1/pages/choose.dart';
import 'package:AP1/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:AP1/pages/BUYING/products.dart';
import 'package:AP1/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<String> _loadImage(String imageName) async {
    try {
      return await FirebaseStorage.instance.ref(imageName).getDownloadURL();
    } catch (e) {
      print(e);
      return '';
    }
  }

  void createAccount_(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void forgotPassword_() {}

  void login() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChoosePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      messageUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightgreen,
      body: Stack(
        children: [
          Center(
            child: FutureBuilder<List<String>>(
              future: Future.wait([
                _loadImage('circle_green.png'),
                _loadImage('pink_circle.png'),
                _loadImage('tshirt_LOGO.png')
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.contains('')) {
                  return const Text('Error loading images');
                }
                final images = snapshot.data!;
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      left: 150,
                      bottom: 500,
                      child: Image.network(images[0], width: 375),
                    ),
                    Positioned(
                      right: 175,
                      top: 600,
                      child: Image.network(images[1], width: 300),
                    ),
                    Positioned(
                      right: 5,
                      top: 100,
                      child: Image.network(images[2], width: 375),
                    ),
                  ],
                );
              },
            ),
          ),
 SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), // This handles the padding when the keyboard appears
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 500), // Adjust this value to position the fields below the logo
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    hide: false,
                  ),
                  SizedBox(height: 25),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    hide: true,
                  ),
                  SizedBox(height: 5),
                  plainButtons(
                    onTap: () => createAccount_(context),
                    text: "Create Account",
                  ),
                  plainButtons(
                    onTap: forgotPassword_,
                    text: "Forgot Password",
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () => login(),
                    child: Text(
                      '   NEXT   ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'GloriaFont',
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(AppColors.lightbrown),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
                      elevation: MaterialStateProperty.all<double>(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}