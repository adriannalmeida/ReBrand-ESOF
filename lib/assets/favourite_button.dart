import 'package:flutter/material.dart';
import 'package:AP1/assets/colors.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? onTap;

  LikeButton({Key? key, required this.isLiked, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, // Adjust the size as needed
        height: 40, // Adjust the size as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.brown, // Change the color as needed
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: Colors.white, // Change the color as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
