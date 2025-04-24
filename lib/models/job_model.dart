import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String id;
  String title;
  String description;
  String location;
  String foods;
  String workTime;
  double salary;

  DateTime createdAt;
  DateTime updatedAt;
  bool isUpdated;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.foods,
    required this.workTime,
    required this.salary,
    required this.createdAt,
    required this.updatedAt,
    required this.isUpdated,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json["id"] ?? '',
      title: json["title"] ?? '',
      description: json["description"] ?? '',
      location: json["location"] ?? '',
      foods: json["foods"] ?? '',
      workTime: json["workTime"] ?? '',
      salary: json["salary"],
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      updatedAt: (json["updatedAt"] as Timestamp).toDate(),
      isUpdated: json["isUpdated"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'foods': foods,
      'workTime': workTime,
      'salary': salary,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isUpdated': isUpdated,
    };
  }
}
