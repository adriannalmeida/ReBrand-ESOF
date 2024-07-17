import 'package:AP1/assets/warnig_messages.dart';
import 'package:AP1/pages/DONATION/Donation_clothes.dart';
import 'package:AP1/pages/DONATION/donatemainpage.dart';
import 'package:flutter/material.dart';
import 'package:AP1/assets/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AP1/firebase/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:AP1/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonateClothesPage extends StatefulWidget {
  const DonateClothesPage({Key? key}) : super(key: key);

  @override
  _DonateClothesPageState createState() => _DonateClothesPageState();
}

class _DonateClothesPageState extends State<DonateClothesPage> {
  String? _userEmail;
  String? _selectedSize;
  bool ssize = false;
  String? _selectedGender;
  bool sgender = false;
  String? _selectedCategory;
  bool scategory = false;
  String? _selectedCondition;
  bool scondition = false;
  String? _selectedStyle;
  bool sstyle = false;
  String? _selectedFitType;
  bool sfittype = false;

  List<String> sizes = ['S', 'M', 'L', 'XL'];
  List<String> genders = ['Male', 'Female', 'Unisex'];
  List<String> category = ['Shirt', 'Pants', 'Dress', 'Jacket', 'Shoes'];
  List<String> condition = ['Good as new', 'Used a few times', 'Slightly Damaged'];
  List<String> style = ['Modern', 'Vintage', 'Casual', 'Boho', 'Elegant', 'Cute'];
  List<String> fittype = ['Fitted', 'Baggy', 'Regular'];

  final FirestoreService firestoreService = FirestoreService();

  void _resetFields() {
    setState(() {
      _selectedSize = null;
      ssize = false;
      _selectedGender = null;
      sgender = false;
      _selectedCategory = null;
      scategory = false;
      _selectedCondition = null;
      scondition = false;
      _selectedStyle = null;
      sstyle = false;
      _selectedFitType = null;
      sfittype = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
      });
    } else {
      print("not user");
    }
  }

  Future<String> _loadImage(String imageName) async {
    try {
      return await FirebaseStorage.instance.ref(imageName).getDownloadURL();
    } catch (e) {
      print(e);
      return '';
    }
  }

  void _showSelectionModal(BuildContext context, String label, List<String> options, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((String option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  onSelected(option);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Color(0xFF97AA78);
    return Scaffold(
      backgroundColor: backColor, // Change background color to brown
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DonateMainPage()));
          },
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<String>(
            future: _loadImage('circle_beige.png'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Error loading image');
              }
              return Positioned(
                right: 200.0,
                top: 500.0,
                child: Image.network(snapshot.data!, width: 190),
              );
            },
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 80, top: 90), // Adjust top padding as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _buildFilterButton('Size', _selectedSize, sizes, (String value) {
                    setState(() {
                      _selectedSize = value;
                      ssize = value.isNotEmpty;
                    });
                  }),
                  SizedBox(height: 20),
                  _buildFilterButton('Gender', _selectedGender, genders, (String value) {
                    setState(() {
                      _selectedGender = value;
                      sgender = value.isNotEmpty;
                    });
                  }),
                  SizedBox(height: 20),
                  _buildFilterButton('Category', _selectedCategory, category, (String value) {
                    setState(() {
                      _selectedCategory = value;
                      scategory = value.isNotEmpty;
                    });
                  }),
                  SizedBox(height: 20),
                  _buildFilterButton('Condition', _selectedCondition, condition, (String value) {
                    setState(() {
                      _selectedCondition = value;
                      scondition = value.isNotEmpty;
                    });
                  }),
                  SizedBox(height: 20),
                  _buildFilterButton('Style', _selectedStyle, style, (String value) {
                    setState(() {
                      _selectedStyle = value;
                      sstyle = value.isNotEmpty;
                    });
                  }),
                  SizedBox(height: 20),
                  _buildFilterButton('Fit Type', _selectedFitType, fittype, (String value) {
                    setState(() {
                      _selectedFitType = value;
                      sfittype = value.isNotEmpty;
                    });
                  }),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(AppColors.pink),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(45)),
                      elevation: MaterialStateProperty.all<double>(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (ssize == true &&
                          scategory == true &&
                          scondition == true &&
                          sfittype == true &&
                          sgender == true &&
                          sgender == true) {
                        firestoreService.addClothesDonate(
                          Donations_Clothes(
                            useremail: _userEmail ?? "",
                            category: _selectedCategory ?? "",
                            condition: _selectedCondition ?? "",
                            fit_type: _selectedFitType ?? "",
                            gender: _selectedGender ?? "",
                            size: _selectedSize ?? "",
                            style: _selectedStyle ?? "",
                          ),
                        );
                        messageUser('Donation made successfully', context);
                        _resetFields();
                      } else {
                        messageUser('Please complete all the fields', context);
                      }
                    },
                    child: Text(
                      'Apply Changes'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'GloriaFont',
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

  Widget _buildFilterButton(String label, String? selectedValue, List<String> options, Function(String) onSelected) {
    return Container(
      width: 250,
      height: 70,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(AppColors.brown),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(25)),
          elevation: MaterialStateProperty.all<double>(5),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          _showSelectionModal(context, label, options, onSelected);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedValue ?? 'Select $label',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontFamily: 'GloriaFont',
              ),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
