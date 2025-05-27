import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_finder/models/job_model.dart';

class FavouriteService {
  final _favourites = FirebaseFirestore.instance.collection('favourites');

  /// Always gets the latest logged-in user
  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  Future<void> addToFavourites(Job job) async {
    await _favourites.doc('${currentUserId}_${job.id}').set(job.toJson());
  }

  Future<void> removeFromFavourites(String jobId) async {
    await _favourites.doc('${currentUserId}_$jobId').delete();
  }

  Future<bool> isFavourite(String jobId) async {
    final doc = await _favourites.doc('${currentUserId}_$jobId').get();
    return doc.exists;
  }

  Stream<List<Job>> getFavouriteJobs() {
    return _favourites
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: '${currentUserId}_')
        .where(FieldPath.documentId, isLessThan: '${currentUserId}_\uf8ff') // Range for matching current user's docs
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => Job.fromJson(e.data())).toList());
  }
}
