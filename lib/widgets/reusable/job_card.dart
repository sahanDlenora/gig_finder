import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:gig_finder/service/job/favouriteService.dart';
import 'package:gig_finder/service/job/job_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class JobCard extends StatefulWidget {
  final String searchQuery;
  const JobCard({super.key, required this.searchQuery});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  final _favouriteService = FavouriteService();
  final Map<String, bool> _favouriteStatus = {};

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

  Future<void> _loadFavouriteStatus(String jobId) async {
    if (!_favouriteStatus.containsKey(jobId)) {
      final isFav = await _favouriteService.isFavourite(jobId);
      setState(() {
        _favouriteStatus[jobId] = isFav;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          final jobs = snapshot.data!;
          final filteredJobs = widget.searchQuery.isEmpty
              ? jobs
              : jobs
                  .where((job) =>
                      job.title
                          .toLowerCase()
                          .contains(widget.searchQuery.toLowerCase()) ||
                      job.description
                          .toLowerCase()
                          .contains(widget.searchQuery.toLowerCase()) ||
                      job.location
                          .toLowerCase()
                          .contains(widget.searchQuery.toLowerCase()))
                  .toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredJobs.length,
            itemBuilder: (context, index) {
              final job = filteredJobs[index];
              _loadFavouriteStatus(job.id);

              return FutureBuilder<Map<String, dynamic>?>(
                future: getUserById(job.createdBy),
                builder: (context, userSnapshot) {
                  final userData = userSnapshot.data;
                  final userName = userData?['name'] ?? 'Unknown';
                  final profileUrl = userData?['profilePicture']; // FIXED HERE

                  return FutureBuilder(
                      future: _favouriteService.isFavourite(job.id),
                      builder: (context, favSnapshot) {
                        final isFav = favSnapshot.data ?? false;

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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundImage: profileUrl !=
                                                        null &&
                                                    profileUrl.isNotEmpty
                                                ? NetworkImage(profileUrl)
                                                : const NetworkImage(
                                                        'https://i.stack.imgur.com/l60Hf.png')
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
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          onPressed: () async {
                                            final newFavStatus =
                                                !_favouriteStatus[job.id]!;
                                            if (newFavStatus) {
                                              await _favouriteService
                                                  .addToFavourites(job);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content:
                                                        Text('Added to job')),
                                              );
                                            } else {
                                              await _favouriteService
                                                  .removeFromFavourites(job.id);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Removed from job')),
                                              );
                                            }

                                            setState(() {
                                              _favouriteStatus[job.id] =
                                                  newFavStatus;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.bookmark,
                                            color: isFav
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 22,
                                          ),
                                        ),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      Text(job.location),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
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
                                                  Icons
                                                      .document_scanner_outlined,
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
                      });
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
