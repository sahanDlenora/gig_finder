import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_finder/service/auth/auth_services.dart';
import 'package:gig_finder/views/auth_views/login.dart';
import 'package:gig_finder/views/sub_pages/about_me.dart';
import 'package:gig_finder/widgets/reusable/profile_element.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Loading...";
  String profileImage = "https://i.stack.imgur.com/l60Hf.png"; // Default image

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? "No Name";
          profileImage = userDoc['profilePicture'].isNotEmpty
              ? userDoc['profilePicture']
              : "https://i.stack.imgur.com/l60Hf.png";
        });
      }
    }
  }

 void _logout(BuildContext context) async {
    try {
      await AuthService().signOut();
      context.go('/login'); // Use the correct route name for your login screen
    } catch (e) {
      print("Error signing out: $e");
    }
  }

   @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                
                SizedBox(height: 8),

                // Profile Info Section
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: profileImage.startsWith("http")
                              ? NetworkImage(
                                  profileImage) // Firebase storage URL
                              : AssetImage(profileImage),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            userName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins',
                              color: Colors.black.withOpacity(0.8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // My Account Section
                Text("My Account",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "poppins")),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditProfileScreen()), // Replace with your actual widget
                    );
                  },
                  child: ProfileElement(
                    profileElementName: "About Me",
                    iconName: Icons.person,
                  ),
                ),

                ProfileElement(
                    profileElementName: "Education",
                    iconName: Icons.cast_for_education),
                ProfileElement(
                    profileElementName: "Skills", iconName: Icons.bubble_chart),
                ProfileElement(
                    profileElementName: "Job Experiences",
                    iconName: Icons.explore_rounded),
                SizedBox(height: 12),

                // General Section
                Text("General",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "poppins")),
                SizedBox(height: 12),
                ProfileElement(
                    profileElementName: "Settings", iconName: Icons.settings),
                ProfileElement(
                    profileElementName: "Privacy Policy",
                    iconName: Icons.security),
                ProfileElement(
                    profileElementName: "Help Center", iconName: Icons.help),

                // Log Out Button with GestureDetector
                GestureDetector(
                  onTap: () => _logout(context),
                  child: ProfileElement(
                      profileElementName: "Log Out", iconName: Icons.logout),
                ),

                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
