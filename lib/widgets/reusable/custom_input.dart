import 'package:flutter/material.dart';
import 'package:gig_finder/utils/constants/colors.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?) validator;

  const CustomInput({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.obscureText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(8),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          prefixIcon: Icon(
            icon,
            color: mainWhiteColor,
            size: 20,
          ),
        ),
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
