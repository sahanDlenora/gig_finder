import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:gig_finder/service/auth/auth_services.dart';
import 'package:gig_finder/service/job/job_service.dart';
import 'package:gig_finder/utils/functions/functions.dart';
import 'package:gig_finder/widgets/reusable/add_job_input.dart';
import 'package:gig_finder/widgets/reusable/custom_button.dart';
import 'package:go_router/go_router.dart';

class AddJobs extends StatelessWidget {
  AddJobs({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _foodsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _workTimeController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  void _submitForm(BuildContext context) async {
    //save form
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Add job to firestore or any other storage here
      try {
        // Create a new job
        final DateTime now = DateTime.now();

        // Get the current logged-in user
        final user = AuthService().getCurrentUser();
        if (user == null) {
          UtilFunctions()
              .showSnackBar(context: context, message: "User not logged in!");
          return;
        }

        final Job job = Job(
          id: "",
          title: _titleController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          foods: _foodsController.text,
          date: _dateController.text,
          workTime: _workTimeController.text,
          salary: double.tryParse(_salaryController.text) ?? 0.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isUpdated: false,
          createdBy: user.uid,
        );
        await JobService().createNewJob(job);

        if (context.mounted) {
          //Show success snackbar
          UtilFunctions().showSnackBar(
              context: context, message: "Job added successfully..!");
        }
        // Delay navigation to ensure snackbar is displayed
        await Future.delayed(Duration(seconds: 2));

        // Navigate to the home page
        GoRouter.of(context).go("/main-screen");
      } catch (error) {
        print(error);
        //Show success snackbar
        if (context.mounted) {
          UtilFunctions()
              .showSnackBar(context: context, message: "Faild to add job..!");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                            "Date",
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
                            controller: _dateController,
                            lableText: "Enter work date",
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "Please enter work date";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Time",
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
                            controller: _workTimeController,
                            lableText: "Enter work time",
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "Please enter work time";
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
                          SizedBox(
                            height: 16,
                          ),
                          CustomButton(
                            text: "Add Job",
                            buttonBgColor: Colors.green,
                            onPressed: () => _submitForm(context),
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
