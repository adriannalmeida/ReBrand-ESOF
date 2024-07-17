import 'package:flutter/material.dart';
import 'package:AP1/assets/colors.dart';

class SearchBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearchBar;
  final bool showPageTitle;
  final VoidCallback onBack;

  SearchBar({
    this.title = "Rebrand",
    this.showSearchBar = false,
    this.showPageTitle = false,
    required this.onBack,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: AppColors.brown,
      ),
      child: Stack(
        children: [
          //if (onBack != null)
            Positioned(
              left: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: onBack,
              ),
            ),
          if (showSearchBar)
            Center(
              child: Container(
                width: 200, 
                height: 40, 
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          if (showPageTitle && !showSearchBar)
            Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20, // Adjust the font size 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Positioned(
            right: 16,
            top: kToolbarHeight * 0.2,
            child: Image.asset(
              'ProductsImages/truelogo.png', 
              height: kToolbarHeight * 0.6, 
              width: kToolbarHeight * 0.6,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
