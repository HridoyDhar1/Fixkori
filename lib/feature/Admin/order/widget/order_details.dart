import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  Future<Map<String, dynamic>?> _fetchOrder() async {
    final doc = await FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("orders")
        .doc(orderId)
        .get();

    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Order not found"));
          }

          final orderData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Service: ${orderData["serviceName"] ?? "N/A"}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Date: ${orderData["date"] ?? "N/A"}"),
                Text("Time: ${orderData["time"] ?? "N/A"}"),
                Text("Status: ${orderData["status"] ?? "N/A"}"),
                const SizedBox(height: 16),
                Text("Customer: ${orderData["customerName"] ?? "N/A"}"),
                Text("Phone: ${orderData["phone"] ?? "N/A"}"),
                const SizedBox(height: 16),
                Text("Address: ${orderData["address"] ?? "N/A"}"),
                const SizedBox(height: 16),
                Text("Notes: ${orderData["notes"] ?? "No notes"}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
