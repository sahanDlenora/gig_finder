import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_finder/models/job_model.dart';

class FavouriteService {
  final _favourites = FirebaseFirestore.instance.collection('favourites');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addToFavourites(Job job) async {
    await _favourites.doc('${userId}_${job.id}').set(job.toJson());
  }

  Future<void> removeFromFavourites(String jobId) async {
    await _favourites.doc('${userId}_$jobId').delete();
  }

  Future<bool> isFavourite(String jobId) async {
    final doc = await _favourites.doc('${userId}_$jobId').get();
    return doc.exists;
  }

  Stream<List<Job>> getFavouriteJobs() {
    return _favourites.where('createdBy', isNotEqualTo: null).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((e) => Job.fromJson(e.data())).toList());
  }
}
