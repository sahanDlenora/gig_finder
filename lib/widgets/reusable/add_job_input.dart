import 'package:flutter/material.dart';

class AddJobInput extends StatelessWidget {
  final TextEditingController controller;
  final String? lableText;
  final String? Function(String?)? validator;
  const AddJobInput({
    super.key,
    required this.controller,
    this.lableText,
    this.validator,
  });

  @override
 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green.shade100), // Default border color
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 12),
        ),
      ),
    );
  }
}
