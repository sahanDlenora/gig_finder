import 'package:flutter/material.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: "poppins",
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Text(""),
        ],
      ),
    );
  }
}
