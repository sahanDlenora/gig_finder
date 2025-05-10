import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:gig_finder/service/job/JobApplicationService%20.dart';
import 'package:gig_finder/service/job/job_service.dart';
import 'package:gig_finder/views/sub_pages/add_jobs.dart';
import 'package:gig_finder/widgets/reusable/ApplicantsListWidget.dart';
import 'package:gig_finder/widgets/reusable/apply_job_card.dart';
import 'package:gig_finder/widgets/reusable/my_job_card.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'My Jobs'),
    Tab(text: 'Apply'),
    Tab(text: 'Saved'),
  ];

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  late Future<List<Job>> _appliedJobsFuture;

  @override
  void initState() {
    super.initState();
    _appliedJobsFuture = JobApplicationService().getAppliedJobs();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: JobScreen.myTabs.length,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                Center(
                  child: Text(
                    "Jobs",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "poppins",
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 0, // Remove shadow for a cleaner look
            iconTheme: IconThemeData(color: Colors.black), // Back button color
            bottom: TabBar(
              tabs: JobScreen.myTabs,
              indicatorColor: Colors.green, // Active tab indicator color
              indicatorWeight: 3.0, // Indicator thickness
              labelColor: Colors.green, // Active tab text color
              unselectedLabelColor: Colors.grey, // Inactive tab text color
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ), // Active tab font styling
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ), // Inactive tab font styling
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            MyJobCard(),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Job>>(
                future: _appliedJobsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('You have not applied to any jobs.'));
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: ApplyJobListCard(
                      jobs: snapshot.data!,
                      onJobDeleted: () {
                        setState(() {
                          _appliedJobsFuture =
                              JobApplicationService().getAppliedJobs();
                        });
                      },
                    ),
                  );
                },
              ),
              Column(
                children: [
                  Center(
                    child: Text(
                      "Saved Jobs",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
