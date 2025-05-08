import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:gig_finder/service/job/job_service.dart';
import 'package:gig_finder/widgets/reusable/ApplicantsListWidget.dart';

class JobApplicant extends StatefulWidget {
  const JobApplicant({super.key});

  @override
  State<JobApplicant> createState() => _JobApplicantState();
}

class _JobApplicantState extends State<JobApplicant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Applicants",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: "poppins",
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Job>>(
                future: JobService()
                    .getJobsByUser(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading jobs'));
                  }

                  final jobs = snapshot.data;

                  if (jobs == null || jobs.isEmpty) {
                    return Center(child: Text('You have not posted any jobs.'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return Card(
                        elevation: 3,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text(job.description),
                              SizedBox(height: 12),
                              Text('Applicants:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              ApplicantsListWidget(jobId: job.id),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )),
        ),
      ),
    );
  }
}
