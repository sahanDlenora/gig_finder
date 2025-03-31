import 'package:flutter/material.dart';
import 'package:gig_finder/widgets/reusable/add_job_input.dart';

class AddJobs extends StatelessWidget {
  AddJobs({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: Column(
                children: [
                  Text(
                    "Add Jobs",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Job Title"),
                      SizedBox(
                        height: 8,
                      ),
                      AddJobInput(
                        controller: _nameController,
                        lableText: "Enter job title",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
