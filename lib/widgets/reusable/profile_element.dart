import 'dart:ui';

import 'package:flutter/material.dart';

class ProfileElement extends StatelessWidget {
  final String profileElementName;
  final IconData iconName;
  const ProfileElement({
    super.key,
    required this.profileElementName,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Icon(
                  iconName,
                  color: Colors.green,
                  size: 18,
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              profileElementName,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
          ],
        ),
        Text(
          ">",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
