import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  String name;
  String email;
  String contact;
  String userType; // 'job_seeker' or 'job_provider'
  String profilePicture;
  String about;
  double rating;
  String password;
  DateTime createdAt;
  DateTime updatedAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.contact,
    required this.userType,
    required this.profilePicture,
    required this.about,
    required this.rating,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert model to JSON (For saving to firestore)
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "email": email,
      "contact": contact,
      "userType": userType,
      "profilePicture": profilePicture,
      "about": about,
      "rating": rating,
      "password": password,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  // create user instance from a map (for retriving from firestore)

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      userId: data["userId"] ?? "",
      name: data["name"] ?? "",
      email: data["email"] ?? "",
      contact: data["contact"] ?? "",
      userType: data["userType"] ?? "",
      profilePicture: data["profilePicture"] ?? "",
      about: data["about"] ?? "",
      rating: data["rating"] ?? "",
      password: data["password"] ?? "",
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
