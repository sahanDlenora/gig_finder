import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gig_finder/service/job/favouriteService.dart';
import 'package:go_router/go_router.dart';

class SingleJobCard extends StatefulWidget {
  final Job job;

  const SingleJobCard({super.key, required this.job});

  @override
  State<SingleJobCard> createState() => _SingleJobCardState();
}

class _SingleJobCardState extends State<SingleJobCard> {
  final _favouriteService = FavouriteService();
  bool isFav = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavouriteStatus();
  }

  Future<void> _loadFavouriteStatus() async {
    isFav = await _favouriteService.isFavourite(widget.job.id);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _toggleFavourite() async {
    if (isFav) {
      await _favouriteService.removeFromFavourites(widget.job.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favourites')),
      );
    } else {
      await _favouriteService.addToFavourites(widget.job);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favourites')),
      );
    }

    setState(() {
      //isFav = !isFav;
    });
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.exists ? doc.data() : null;
  }

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} minutes ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserById(job.createdBy),
      builder: (context, userSnapshot) {
        final userData = userSnapshot.data;
        final userName = userData?['name'] ?? 'Unknown';
        final profileUrl = userData?['profilePicture'];

        return FutureBuilder<bool>(
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
                      /// USER HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundImage:
                                    profileUrl != null && profileUrl.isNotEmpty
                                        ? NetworkImage(profileUrl)
                                        : const AssetImage("assets/n.png")
                                            as ImageProvider,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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

                          /// BOOKMARK BUTTON
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: _toggleFavourite,
                              icon: Icon(
                                Icons.bookmark,
                                size: 22,
                                color: isFav ? Colors.green : Colors.grey,
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
                              style: TextStyle(fontWeight: FontWeight.w600)),
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
                                      borderRadius: BorderRadius.circular(100)),
                                ),
                                child: Container(
                                  width: 40,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.document_scanner_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 40,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
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
}
