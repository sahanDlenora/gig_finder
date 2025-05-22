import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:gig_finder/models/user_model.dart';
import 'package:gig_finder/service/auth/auth_services.dart';
import 'package:gig_finder/views/main_views/profile_screen.dart';
import 'package:gig_finder/views/main_views/sub_pages/friends.dart';
import 'package:gig_finder/views/main_views/sub_pages/notification.dart';
import 'package:gig_finder/widgets/reusable/job_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          _currentUser = UserModel.fromJson(doc.data()!);
          _isLoading = false;
        });
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile row
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
                            child: ClipOval(
                              child: _currentUser?.profilePicture != null &&
                                      _currentUser!.profilePicture.isNotEmpty
                                  ? Image.network(
                                      _currentUser!.profilePicture,
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Friends(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.person_3_outlined),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NotificationPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child:
                                        Icon(Icons.notifications_none_outlined),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Hello ${_currentUser?.name ?? "User"}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.trim().toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            fillColor: Colors.grey.shade200,
                            border: InputBorder.none,
                            hintText: "Search for jobs",
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.green.shade100),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Find Your Perfect Part",
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                height: 1.3,
                              ),
                            ),
                            Text(
                              "Time Jobs",
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 130,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.95,
                          enableInfiniteScroll: true,
                          aspectRatio: 2,
                        ),
                        items: [
                          "assets/x.jpg",
                          "assets/r.jpg",
                          "assets/b.jpg",
                        ].map((path) {
                          return Builder(
                            builder: (context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Opacity(
                                  opacity: 0.75,
                                  child: Image.asset(
                                    path,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
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
                      SizedBox(height: 15),
                      JobCard(searchQuery: _searchQuery),

                      SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
