import 'package:flutter/material.dart';

class MediaIcon extends StatelessWidget {
  final String socialImg;
  const MediaIcon({
    super.key,
    required this.socialImg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: ClipOval(
        child: Image.asset(
          socialImg,
          width: 35,
          height: 35,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
