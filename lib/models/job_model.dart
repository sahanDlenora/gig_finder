import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';


  /// ✅ FIXED: Provide all required fields when constructing Job from Firestore
  factory Job.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Job(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      foods: data['foods'] ?? '',
      date: data['date'] ?? '',
      workTime: data['workTime'] ?? '',
      salary: (data['salary'] ?? 0).toDouble(),
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isUpdated: data['isUpdated'] ?? false,
    );
  }
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json["id"] ?? '',
      title: json["title"] ?? '',
      description: json["description"] ?? '',
      location: json["location"] ?? '',
      foods: json["foods"] ?? '',
      date: json['date'] ?? '',
      workTime: json["workTime"] ?? '',
      salary: (json["salary"] ?? 0).toDouble(),
      createdBy: json["createdBy"] ?? '',
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      updatedAt: (json["updatedAt"] as Timestamp).toDate(),
      isUpdated: json["isUpdated"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'foods': foods,
      'date': date,
      'workTime': workTime,
      'salary': salary,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isUpdated': isUpdated,
    };
  }
}
