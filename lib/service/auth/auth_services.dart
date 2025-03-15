// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_finder/models/user_model.dart';
import 'package:gig_finder/service/exceptions/exceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get the current user
  // This method will return the current user, here the user is the one that is signed in and Firebase will return the user.
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Create user with email and password
  // This method will create a new user with email and password and return the user credential.
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error creating user: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error creating user: $e');
      throw Exception(e.toString());
    }
  }

  // Sign in with email and password
  // This method will sign in the user with email and password.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User signed in successfully");
    } on FirebaseAuthException catch (e) {
      print('Error signing in: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in: $e');
      throw Exception(e.toString());
    }
  }

  // Sign in with Google
  // This method will sign in the user with Google.
  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      // Obtain the GoogleSignInAuthentication object
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google Auth credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Create a new UserModel object
        UserModel newUser = UserModel(
          userId: user.uid,
          name: user.displayName ?? "No Name",
          email: user.email ?? "No Email",
          contact: "contact number", // Default value, update as needed
          userType: "userType", // Default value, update as needed
          profilePicture: user.photoURL ?? "",
          about: "about", // Default value, update as needed
          rating: 0, // Default value
          password: "", // No password needed for Google Sign-In
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save user to Firestore
        final DocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await DocRef.set(newUser.toJson());

        print("User signed in with Google and saved to Firestore");
      }
    } on FirebaseAuthException catch (e) {
      print('Error signing in with Google: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in with Google: $e');
      throw Exception(e.toString());
    }
  }
}