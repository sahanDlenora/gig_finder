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
      itemCount: applicants.length,
      itemBuilder: (context, index) {
        final applicant = applicants[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: applicant['profilePicture'] != null
                      ? NetworkImage(applicant['profilePicture'])
                      : const AssetImage('assets/n.png') as ImageProvider,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(applicant['name'] ?? 'No Name',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(applicant['email'] ?? ''),
                      if (applicant['contact'] != null)
                        Text("Contact: ${applicant['contact']}"),
                      if (applicant['about'] != null)
                        Text("About: ${applicant['about']}",
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (applicant['appliedAt'] as Timestamp)
                                .toDate()
                                .toLocal()
                                .toString()
                                .split('.')[0],
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          IconButton(
                            icon: const Icon(Icons.message),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatPage(
                                    receiverID: applicant[
                                        'userId'], // Make sure this field exists
                                    receiverName: applicant['name'] ??
                                        'Applicant', // Optional
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
