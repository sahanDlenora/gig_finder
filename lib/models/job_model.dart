import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String id;
  String title;
  String description;
  String location;
  String foods;
  Double salary;
  DateTime createdAt;
  DateTime updatedAt;
  bool isUpdated;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.foods,
    required this.salary,
    required this.createdAt,
    required this.updatedAt,
    required this.isUpdated,
  });

  /*factory Job.fromJson(Map<String, dynamic> doc, String id) {
    Job(
      id: id,
      title: doc["title"],
      description: doc["description"],
      location: doc["location"],
      foods: doc["foods"],
      salary: doc["salary"],
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
      updatedAt: (doc["updatedAt"] as Timestamp).toDate(),
      isUpdated: doc["isUpdated"],
    );
  }*/
}
