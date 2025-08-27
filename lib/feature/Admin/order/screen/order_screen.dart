import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  // Update order status
  Future<void> updateOrder(String orderId, String status) async {
    await FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("orders")
        .doc(orderId)
        .update({"status": status});
  }

  @override
  Widget build(BuildContext context) {
    final adminUser = FirebaseAuth.instance.currentUser;

    if (adminUser == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in as admin")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Notifications")),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("serviceApp")
            .doc("appData")
            .collection("orders")
            .where("providerUserId", isEqualTo: adminUser.uid)
            .orderBy("createdAt", descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // shimmer/loading placeholder
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders yet"));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              final status = data["status"] ?? "pending";
              Color statusColor;
              if (status == "accepted") {
                statusColor = Colors.green;
              } else if (status == "declined") {
                statusColor = Colors.red;
              } else {
                statusColor = Colors.orange;
              }

              return Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // leading avatar
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: (data["imageUrl"] != null &&
                          data["imageUrl"].toString().isNotEmpty)
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          data["imageUrl"],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.notifications, size: 30);
                          },
                        ),
                      )
                          : const Icon(Icons.notifications, size: 30,color: Colors.pink,),
                    ),
                    const SizedBox(width: 12),

                    // text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["serviceName"] ?? "No Name",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Date: ${data["date"]}\nTime: ${data["time"]}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Status: ${status.toUpperCase()}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () => updateOrder(order.id, "accepted"),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => updateOrder(order.id, "declined"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
