import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:gig_finder/service/job/job_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gig_finder/views/main_views/sub_pages/job_applicant.dart';
import 'package:gig_finder/views/main_views/sub_pages/updateJobDetails.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

class MyJobCard extends StatefulWidget {
  const MyJobCard({
    super.key,
  });

  @override
  State<MyJobCard> createState() => _MyJobCardState();
}

class _MyJobCardState extends State<MyJobCard> {
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) return doc.data();
    return null;
  }

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;
    return StreamBuilder(
      stream: JobService().jobs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error : ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/a.png", width: 200),
                  const SizedBox(height: 10),
                  const Text(
                    "No jobs available. Feel free to add a job",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        } else {
          final allJobs = snapshot.data!;
          final userJobs =
              allJobs.where((job) => job.createdBy == currentUserId).toList();
          if (userJobs.isEmpty) {
            return Center(
                child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/kk.png",
                  width: double.infinity,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "You haven't posted any jobs yet.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userJobs.length,
            itemBuilder: (context, index) {
              final job = userJobs[index];

              return FutureBuilder<Map<String, dynamic>?>(
                future: getUserById(job.createdBy),
                builder: (context, userSnapshot) {
                  final userData = userSnapshot.data;
                  final userName = userData?['name'] ?? 'Unknown';
                  final profileUrl = userData?['profilePicture']; // FIXED HERE

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: profileUrl != null &&
                                              profileUrl.isNotEmpty
                                          ? NetworkImage(profileUrl)
                                          : const AssetImage("assets/n.png")
                                              as ImageProvider,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          getTimeAgo(job.createdAt),
                                          style: TextStyle(
                                            fontSize: 8,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                JobApplicant(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Icon(
                                          Icons.book_online,
                                          color: Colors.grey,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                    PopupMenuButton(
                                      iconColor: Colors.grey,
                                      onSelected: (value) async {
                                        if (value == "1") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Updatejobdetails(),
                                            ),
                                          );
                                        } else if (value == "2") {
                                          //delete job from firestore
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("jobs")
                                                .doc(job.id)
                                                .delete();
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Failed to delete job'),
                                              ),
                                            );
                                          }
                                        }
                                        ;
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem(
                                            value: "1",
                                            child: Text(
                                              "Update",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: "2",
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ];
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              job.title,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text("Location - ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                Text(job.location),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Payment - Rs ${job.salary}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.green.shade400,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        GoRouter.of(context).push(
                                          "/job-details",
                                          extra: job,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                      child: Container(
                                        width: 40,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.document_scanner_outlined,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    Container(
                                      width: 40,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.upload_outlined,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _iconContainer(IconData icon, Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(child: Icon(icon, color: color)),
    );
  }
}
