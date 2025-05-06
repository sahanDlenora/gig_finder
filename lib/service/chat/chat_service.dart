import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_finder/models/message_model.dart';

class ChatService {
  // Get instance of firestore and current user
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get User stream (Only users who have chatted)
  Stream<List<Map<String, dynamic>>> getUserStream() {
  final currentUserId = _auth.currentUser!.uid;

  return _firestore
      .collection("chat_rooms")
      .where("participants", arrayContains: currentUserId)
      .snapshots()
      .asyncMap((snapshot) async {
        final userIds = <String>{};

        // Collect all unique user IDs who chatted with current user
        for (var doc in snapshot.docs) {
          List<dynamic> participants = doc["participants"];
          for (var id in participants) {
            if (id != currentUserId) {
              userIds.add(id);
            }
          }
        }

        // If no other users found, return empty list
        if (userIds.isEmpty) return [];

        // Fetch user documents for each UID
        final futures = userIds.map((id) async {
          final userDoc = await _firestore.collection("users").doc(id).get();
          if (userDoc.exists) {
            final userData = userDoc.data()!;
            userData['uid'] = id;
            return userData;
          } else {
            return null;
          }
        });

        // Wait for all user fetches to complete
        final results = await Future.wait(futures);

        // Filter out nulls
        return results.whereType<Map<String, dynamic>>().toList();
      });
}


  // Send message
  Future<void> sendMessage(String receiverID, message) async {
    // Get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Message newMessage = Message(
      senderID: currentUserId,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // Construct chat room id for the two users
    List<String> ids = [currentUserId, receiverID];
    ids.sort(); // Sort the ids (this ensures the chat room ID is the same for any 2 people)
    String chatRoomID = ids.join('_');

    // Add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

    // Update participants field in chat room document
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .set({
          'participants': [currentUserId, receiverID],
        }, SetOptions(merge: true));
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // Construct a chat room id for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
