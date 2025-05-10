import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_finder/models/job_model.dart';

class JobApplicationService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> applyToJob(String jobId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final userDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();
    if (!userDoc.exists) return;

    final userData = userDoc.data();

    await _firestore
        .collection('jobs')
        .doc(jobId)
        .collection('applicants')
        .doc(currentUser.uid)
        .set({
      'name': userData?['name'],
      'email': userData?['email'],
      'profilePicture': userData?['profilePicture'],
      'contact': userData?['contact'], // add this
      'about': userData?['about'], // add this
      'userId': currentUser.uid, // needed for message icon navigation
      'appliedAt': Timestamp.now(),
    });

    // Save a reference under jobApplications
    await _firestore
        .collection('jobApplications')
        .doc(currentUser.uid)
        .collection('appliedJobs')
        .doc(jobId)
        .set({'appliedAt': Timestamp.now()});
  }

  // fetch applicants for a specific job
  Future<List<Map<String, dynamic>>> getApplicants(String jobId) async {
    final snapshot = await _firestore
        .collection('jobs')
        .doc(jobId)
        .collection('applicants')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Job>> getAppliedJobs() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return [];

    final appliedJobsSnapshot = await _firestore
        .collection('jobApplications')
        .doc(currentUser.uid)
        .collection('appliedJobs')
        .get();

    List<Job> appliedJobs = [];

    for (var doc in appliedJobsSnapshot.docs) {
      final jobId = doc.id;
      final jobDoc = await _firestore.collection('jobs').doc(jobId).get();
      if (jobDoc.exists) {
        appliedJobs.add(Job.fromJson(jobDoc.data()!));
      }
    }

    return appliedJobs;
  }

  Future<void> deleteAppliedJob(String jobId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    // Remove from applicants list in job document
    await _firestore
        .collection('jobs')
        .doc(jobId)
        .collection('applicants')
        .doc(currentUser.uid)
        .delete();

    // Remove from user's applied jobs
    await _firestore
        .collection('jobApplications')
        .doc(currentUser.uid)
        .collection('appliedJobs')
        .doc(jobId)
        .delete();
  }
}
