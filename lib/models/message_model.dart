import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String id;
  String title;
  String description;
  String location;
  String foods;
  String date;
  String workTime;
  double salary;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  bool isUpdated;

