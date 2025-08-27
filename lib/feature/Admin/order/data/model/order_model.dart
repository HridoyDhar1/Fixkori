import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String serviceId;
  final String serviceName;
  final double price;
  final String? location;
  final String? userId;
  final String? userEmail;
  final DateTime dateTime;
  final String status;
  final String? adminId;

  OrderModel({
    required this.serviceId,
    required this.serviceName,
    required this.price,
    this.location,
    this.userId,
    this.userEmail,
    required this.dateTime,
    this.status = "pending",
    this.adminId,
  });

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'price': price,
      'location': location,
      'userId': userId,
      'userEmail': userEmail,
      'date': "${dateTime.day}/${dateTime.month}/${dateTime.year}",
      'time': "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}",
      'createdAt': FieldValue.serverTimestamp(),
      'status': status,
      'adminId': adminId,
    };
  }
}
