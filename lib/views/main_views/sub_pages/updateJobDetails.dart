import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:gig_finder/widgets/reusable/add_job_input.dart';

class Updatejobdetails extends StatefulWidget {
  final Job job;
  const Updatejobdetails({super.key, required this.job});

  @override
  State<Updatejobdetails> createState() => _UpdatejobdetailsState();
}

class _UpdatejobdetailsState extends State<Updatejobdetails> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController foodsController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController salaryController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.job.title);
    descriptionController = TextEditingController(text: widget.job.description);
    locationController = TextEditingController(text: widget.job.location);
    foodsController = TextEditingController(text: widget.job.foods);
    dateController = TextEditingController(text: widget.job.date);
    timeController = TextEditingController(text: widget.job.workTime);
    salaryController =
        TextEditingController(text: widget.job.salary.toString());
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    foodsController.dispose();
    dateController.dispose();
    timeController.dispose();
    salaryController.dispose();
    super.dispose();
  }

  Future<void> updateJob() async {
    final updatedJob = {
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "location": locationController.text.trim(),
      "foods": foodsController.text.trim(),
      "date": dateController.text.trim(),
      "time": timeController.text.trim(),
      "salary": double.tryParse(salaryController.text.trim()) ?? 0.0,
      "updatedAt": DateTime.now(),
      "isUpdated": true,
    };

    try {
      await FirebaseFirestore.instance
          .collection("jobs")
          .doc(widget.job.id)
          .update(updatedJob);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Job updated successfully")),
      );

      Navigator.pop(context); // Go back after update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update job: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Job",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: "poppins",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
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
              AddJobInput(controller: titleController),
              SizedBox(
                height: 6,
              ),
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              AddJobInput(controller: descriptionController),
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
              AddJobInput(controller: locationController),
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
              AddJobInput(controller: foodsController),
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
              AddJobInput(controller: dateController),
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
              AddJobInput(controller: timeController),
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
              AddJobInput(controller: salaryController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update Job',
                  style: TextStyle(
                    //fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
