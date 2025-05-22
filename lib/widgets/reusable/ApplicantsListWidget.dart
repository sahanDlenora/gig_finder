import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gig_finder/service/job/JobApplicationService%20.dart';
import 'package:gig_finder/views/sub_pages/chat_page.dart';

class ApplicantsListWidget extends StatefulWidget {
  final String jobId;

  const ApplicantsListWidget({super.key, required this.jobId});

  @override
  State<ApplicantsListWidget> createState() => _ApplicantsListWidgetState();
}

class _ApplicantsListWidgetState extends State<ApplicantsListWidget> {
  List<Map<String, dynamic>> applicants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadApplicants();
  }

  Future<void> loadApplicants() async {
    final data = await JobApplicationService().getApplicants(widget.jobId);
    setState(() {
      applicants = data;
      isLoading = false;
    });
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (applicants.isEmpty) {
      return const Center(child: Text("No applicants yet."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: applicants.length,
      itemBuilder: (context, index) {
        final applicant = applicants[index];
        final appliedAt = (applicant['appliedAt'] as Timestamp).toDate();
        final profileUrl = applicant['profilePicture'];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
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
                            backgroundImage:
                                profileUrl != null && profileUrl.isNotEmpty
                                    ? NetworkImage(profileUrl)
                                    : const NetworkImage(
                                        'https://i.stack.imgur.com/l60Hf.png'),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                applicant['name'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                getTimeAgo(appliedAt),
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
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.message,
                              color: Colors.green, size: 18),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatPage(
                                  receiverID: applicant['userId'],
                                  receiverName:
                                      applicant['name'] ?? 'Applicant',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    applicant['email'] ?? '',
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (applicant['contact'] != null)
                    Text("Contact: ${applicant['contact']}",
                        style: const TextStyle(fontSize: 12)),
                  if (applicant['about'] != null)
                    Text(
                      "About: ${applicant['about']}",
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
