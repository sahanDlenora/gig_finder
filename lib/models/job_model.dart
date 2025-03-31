import 'dart:ffi';

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

  factory Job.fromJson(Map<String, dynamic> doc, String id) {
    Job(
      id: id,
      title: title,
      description: description,
      location: location,
      foods: foods,
      salary: salary,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isUpdated: isUpdated,
    );
  }
}
