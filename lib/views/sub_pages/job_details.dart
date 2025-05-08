import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:gig_finder/service/job/JobApplicationService%20.dart';
import 'package:gig_finder/views/sub_pages/chat_page.dart';
import 'package:gig_finder/widgets/reusable/custom_button.dart';
import 'package:gig_finder/widgets/reusable/job_details_show.dart';

class JobDetails extends StatefulWidget {
  final Job job;

  const JobDetails({
    super.key,
    required this.job,
  });

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchJobOwner();
  }

  Future<void> fetchJobOwner() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.job.createdBy)
        .get();

    if (doc.exists) {
      setState(() {
        userData = doc.data();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileUrl = userData?['profilePicture'];
    final userName = userData?['name'] ?? 'Loading...';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: "poppins",
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: profileUrl != null && profileUrl.isNotEmpty
                            ? Image.network(
                                profileUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/n.png",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    iconButton(Icons.call, Colors.red.shade300),
                    GestureDetector(
                      onTap: () {
                        if (userData != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                receiverID: widget.job.createdBy,
                                receiverName: userData!['name'],
                              ),
                            ),
                          );
                        }
                      },
                      child: iconButton(Icons.message, Colors.blue.shade200),
                    ),
                    iconButton(Icons.bookmark, Colors.grey),
                  ],
                ),
                const SizedBox(height: 13),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        JobDetailsShow(
                            txt_1: "Job Title", txt_2: widget.job.title),
                        const SizedBox(height: 10),
                        JobDetailsShow(
                            txt_1: "Description",
                            txt_2: widget.job.description),
                        const SizedBox(height: 10),
                        JobDetailsShow(
                            txt_1: "Location", txt_2: widget.job.location),
                        const SizedBox(height: 10),
                        JobDetailsShow(txt_1: "Foods", txt_2: widget.job.foods),
                        const SizedBox(height: 10),
                        JobDetailsShow(
                            txt_1: "Time", txt_2: widget.job.workTime),
                        const SizedBox(height: 10),
                        JobDetailsShow(
                            txt_1: "Salary",
                            txt_2: widget.job.salary.toString()),
                        const SizedBox(height: 12),
                        Center(
                          child: CustomButton(
                            text: "Apply Now",
                            onPressed: () async {
                              await JobApplicationService()
                                  .applyToJob(widget.job.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("You have applied to this job.")),
                              );
                            },
                            buttonBgColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget iconButton(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(child: Icon(icon, color: color)),
    );
  }
}
