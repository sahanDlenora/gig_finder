import 'package:flutter/material.dart';
import 'package:gig_finder/widgets/reusable/job_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage("assets/h.png"),
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.notifications_none_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Hello Thilina",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Find Your Perfect Part Time Job",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    height: 1.3,
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      fillColor: Colors.grey.shade200,
                      border: InputBorder.none,
                      hintText: "Search for jobs",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.green.shade100),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Jobs",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "poppins",
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                JobCard(),
                SizedBox(
                  height: 18,
                ),
                JobCard(),
                SizedBox(
                  height: 18,
                ),
                JobCard(),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
