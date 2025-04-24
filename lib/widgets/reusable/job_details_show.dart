import 'package:flutter/material.dart';

class JobDetailsShow extends StatefulWidget {
  final String txt_1;
  final String txt_2;
  const JobDetailsShow({
    super.key,
    required this.txt_1,
    required this.txt_2,
  });

  @override
  State<JobDetailsShow> createState() => _JobDetailsShowState();
}

class _JobDetailsShowState extends State<JobDetailsShow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.txt_1,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: "poppins",
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Text(
            widget.txt_2,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
