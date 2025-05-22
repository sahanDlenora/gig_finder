import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:gig_finder/service/job/job_service.dart';
import 'package:gig_finder/widgets/reusable/ApplicantsListWidget.dart';

class JobApplicant extends StatefulWidget {
  const JobApplicant({
    super.key,
  });

  @override
  State<JobApplicant> createState() => _JobApplicantState();
}

class _JobApplicantState extends State<JobApplicant> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: FutureBuilder<List<Job>>(
        future:
            JobService().getJobsByUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading jobs'));
          }

          final jobs = snapshot.data;

          if (jobs == null || jobs.isEmpty) {
            return Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                    'You have not posted any jobs.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Card(
                color: Colors.grey.shade200,
                elevation: 1,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Applicants',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 116,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ApplicantsListWidget(jobId: job.id),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
