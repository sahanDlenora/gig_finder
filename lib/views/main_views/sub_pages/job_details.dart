import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:gig_finder/widgets/reusable/add_job_input.dart';
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
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
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          "assets/m.jpg",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Madhusanka",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.call,
                          color: Colors.red.shade300,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.message,
                          color: Colors.blue.shade200,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.bookmark,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 13,
                ),
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
                          txt_1: "Job Title",
                          txt_2: widget.job.title,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        JobDetailsShow(
                          txt_1: "Description",
                          txt_2: widget.job.description,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        JobDetailsShow(
                          txt_1: "Location",
                          txt_2: widget.job.location,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        JobDetailsShow(
                          txt_1: "Foods",
                          txt_2: widget.job.foods,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        JobDetailsShow(
                          txt_1: "Time",
                          txt_2: widget.job.workTime,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        JobDetailsShow(
                          txt_1: "Salary",
                          txt_2: widget.job.salary.toString(),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Center(
                          child: CustomButton(
                            text: "Apply Now",
                            onPressed: () {},
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
}
