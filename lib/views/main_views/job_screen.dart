import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';

import 'package:gig_finder/service/job/favouriteService.dart';

import 'package:gig_finder/service/job/JobApplicationService%20.dart';

import 'package:gig_finder/service/job/job_service.dart';
import 'package:gig_finder/views/main_views/sub_pages/job_applicant.dart';
import 'package:gig_finder/views/sub_pages/add_jobs.dart';
import 'package:gig_finder/widgets/reusable/ApplicantsListWidget.dart';
import 'package:gig_finder/widgets/reusable/apply_job_card.dart';
import 'package:gig_finder/widgets/reusable/my_job_card.dart';
import 'package:gig_finder/widgets/reusable/single_job_card.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'My Jobs'),
    Tab(text: 'Apply'),
    Tab(text: 'Applicants'),
    Tab(text: 'Saved'),
  ];

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final _favouriteService = FavouriteService();

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
              SingleChildScrollView(
                child: FutureBuilder<List<Job>>(
                  future: _appliedJobsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          const Center(
                            child: Text(
                              'You have not applied to any jobs.',
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
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    JobApplicant(),
                  ],
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: StreamBuilder<List<Job>>(
                      stream: _favouriteService.getFavouriteJobs(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                "No saved jobs yet.",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        } else {
                          final jobs = snapshot.data!;
                          return ListView.builder(
                            itemCount: jobs.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              return SingleJobCard(job: job);
                            },
                          );
                        }
                      },
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
