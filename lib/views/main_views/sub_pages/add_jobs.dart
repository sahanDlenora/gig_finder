import 'package:flutter/material.dart';
import 'package:gig_finder/widgets/reusable/add_job_input.dart';

class AddJobs extends StatelessWidget {
  AddJobs({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _foodsController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Job Title",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          AddJobInput(
                            controller: _titleController,
                            lableText: "Enter job title",
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "Please enter job title";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Job Description",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          AddJobInput(
                            controller: _descriptionController,
                            lableText: "Enter description",
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "Please enter description";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Location",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          AddJobInput(
                            controller: _locationController,
                            lableText: "Enter location",
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "Please enter location";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Foods",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          AddJobInput(
                            controller: _foodsController,
                            lableText: "Enter foods gives",
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "Please enter foods";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Salary",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          AddJobInput(
                            controller: _salaryController,
                            lableText: "Enter salary",
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "Please enter Salary";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
