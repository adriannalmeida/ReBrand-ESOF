import 'package:AP1/pages/DONATION/associations_provider.dart';
import 'package:AP1/pages/decoration_page_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:AP1/pages/BUYING/products_provider.dart';
import 'package:AP1/pages/BUYING/favorite_provider.dart';
import 'firebase/firebaseoptions.dart';
import 'package:AP1/pages/BUYING/buy_provider.dart';

void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()), 
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_)=> AssociationProvider()),
        ChangeNotifierProvider(create: (_) => cartProductsProvider()),
      ],
    child: Rebrand(),
    ),
   );// Call runApp() with your MainPage widget
}

class Rebrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donate and Buyapp',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: DecorationPageLogin(),
    );
  }
}
