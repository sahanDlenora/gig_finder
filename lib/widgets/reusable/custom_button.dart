import 'package:flutter/material.dart';
import 'package:gig_finder/utils/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color buttonBgColor;
  //final double width;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.buttonBgColor,
    //required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return /*Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        gradient: gradientColor1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: mainWhiteColor,
          ),
        ),
      ),
    );*/
        ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        backgroundColor: buttonBgColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
