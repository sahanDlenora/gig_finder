import 'package:flutter/material.dart';

import 'package:gig_finder/views/sub_pages/add_jobs.dart';

import 'package:gig_finder/widgets/reusable/add_job_input.dart';
import 'package:gig_finder/widgets/reusable/custom_input.dart';
import 'package:gig_finder/widgets/reusable/job_card.dart';
import 'package:gig_finder/widgets/reusable/my_job_card.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Add Jobs'),
    Tab(text: 'Available'),
    Tab(text: 'Apply'),
    Tab(text: 'Saved'),
  ];

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
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
              AddJobs(),
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
              Column(
                children: [
                  Center(
                    child: Text(
                      "Add Jobs",
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
