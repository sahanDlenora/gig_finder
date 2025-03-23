import 'package:flutter/material.dart';
import 'package:gig_finder/widgets/reusable/profile_element.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                Center(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "poppins",
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
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
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Thilina Madhusanka",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppins',
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "My Account",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "poppins",
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                ProfileElement(
                  profileElementName: "About Me",
                  iconName: Icons.person,
                ),
                SizedBox(
                  height: 4,
                ),
                ProfileElement(
                  profileElementName: "Education",
                  iconName: Icons.cast_for_education,
                ),
                SizedBox(
                  height: 4,
                ),
                ProfileElement(
                  profileElementName: "Skils",
                  iconName: Icons.bubble_chart,
                ),
                SizedBox(
                  height: 4,
                ),
                ProfileElement(
                  profileElementName: "Job Experiences",
                  iconName: Icons.explore_rounded,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "General",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "poppins",
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                ProfileElement(
                  profileElementName: "Settings",
                  iconName: Icons.settings,
                ),
                SizedBox(
                  height: 4,
                ),
                ProfileElement(
                  profileElementName: "Privacy Policy",
                  iconName: Icons.security,
                ),
                SizedBox(
                  height: 4,
                ),
                ProfileElement(
                  profileElementName: "Help Center",
                  iconName: Icons.help,
                ),
                SizedBox(
                  height: 4,
                ),
                ProfileElement(
                  profileElementName: "Log Out",
                  iconName: Icons.logout,
                ),
                SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
