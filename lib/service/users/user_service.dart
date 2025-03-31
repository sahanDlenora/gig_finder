// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gig_finder/models/user_model.dart';
import 'package:gig_finder/service/auth/auth_services.dart';
class UserService {
  // Create a collection reference
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  
  // Save the user in the Firestore database
  Future<void> saveUser(UserModel user) async {
    try {
      // Create a new user with email and password
      final userCredential = await AuthService().createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      // Retrieve the user ID from the created user
      final userId = userCredential.user?.uid;

      if (userId != null) {
        // Create a new user document in Firestore with the user ID as the document ID
        final userRef = _usersCollection.doc(userId);

        // Create a user map with the userId field
        final userMap = user.toJson();
        userMap['userId'] = userId;

        // Set the user data in Firestore
        await userRef.set(userMap);

        print('User saved successfully with ID: $userId');
      } else {
        print('Error: User ID is null');
      }
    } catch (error) {
      print('Error saving user: $error');
    }
  }



  //get user details by id

  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (error) {
      print('Error getting user: $error');
    }
    return null;
  }

}