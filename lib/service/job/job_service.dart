import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gig_finder/models/job_model.dart';

class JobService {
  //create the firestore collection reference
  final CollectionReference jobCollection =
      FirebaseFirestore.instance.collection("jobs");

  // Add a new job
  Future<void> createNewJob(Job job) async {
    try {
      // Convert the job object to a map
      final Map<String, dynamic> data = job.toJson();

      // Add the job to the collection
      final DocumentReference docRef = await jobCollection.add(data);

      // Update the job document with generated ID
      await docRef.update({'id': docRef.id});
      print("job saved");
    } catch (error) {
      print('Error creating job : $error');
    }
  }

  //Get all jobs as a stream list of job
  Stream<List<Job>> get jobs {
    try {
      return jobCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => Job.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print(error);
      return Stream.empty();
    }
  }

  Future<List<Job>> getJobsByUser(String userId) async {
  try {
    final snapshot = await jobCollection.where('createdBy', isEqualTo: userId).get();
    return snapshot.docs
        .map((doc) => Job.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print("Error fetching user jobs: $e");
    return [];
  }
}

}
