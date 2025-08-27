
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  String? id;
  final String userId;  // Add this field
  final String name;
  final String email;
  final String number;
  final String location;
  final String workType;
  final String country;
  final String employees;
  final String? imageUrl;

  AdminModel({
    this.id,
    required this.userId,  // Add this
    required this.name,
    required this.email,
    required this.number,
    required this.location,
    required this.workType,
    required this.country,
    required this.employees,
    this.imageUrl,
  });

  // Update toMap() to include userId
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,  // Add this
      'name': name,
      'email': email,
      'number': number,
      'location': location,
      'workType': workType,
      'country': country,
      'employees': employees,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Update fromMap() to include userId
  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: map['id'],
      userId: map['userId'] ?? '',  // Add this
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      number: map['number'] ?? '',
      location: map['location'] ?? '',
      workType: map['workType'] ?? '',
      country: map['country'] ?? '',
      employees: map['employees'] ?? '',
      imageUrl: map['imageUrl']??'',
    );
  }

  // Update copyWith() to include userId
  AdminModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? number,
    String? location,
    String? workType,
    String? country,
    String? employees,
    String? imageUrl,
  }) {
    return AdminModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,  // Add this
      name: name ?? this.name,
      email: email ?? this.email,
      number: number ?? this.number,
      location: location ?? this.location,
      workType: workType ?? this.workType,
      country: country ?? this.country,
      employees: employees ?? this.employees,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}