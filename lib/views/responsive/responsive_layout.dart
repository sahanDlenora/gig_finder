import 'package:flutter/material.dart';
import 'package:gig_finder/utils/constants/app_constants.dart';

class ResponsiveLayoutScreen extends StatefulWidget {
  final Widget MobileScreenLayout;
  final Widget WebScreenLayout;

  const ResponsiveLayoutScreen(
      {super.key,
      required this.MobileScreenLayout,
      required this.WebScreenLayout});

  @override
  State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenMinWidth) {
          return widget.WebScreenLayout;
        } else {
          return widget.MobileScreenLayout;
        }
      },
    );
  }
}
