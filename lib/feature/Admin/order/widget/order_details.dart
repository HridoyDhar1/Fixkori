
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminBookingDetailsScreen extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> bookingData;

  const AdminBookingDetailsScreen({
    super.key,
    required this.orderId,
    required this.bookingData,
  });

  @override
  State<AdminBookingDetailsScreen> createState() => _AdminBookingDetailsScreenState();
}

class _AdminBookingDetailsScreenState extends State<AdminBookingDetailsScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userId = widget.bookingData["userId"];
      print('Fetching user data for ID: $userId');

      if (userId == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'No user ID found in booking data';
        });
        return;
      }

      // Fetch user data from users collection
      final userSnapshot = await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        print('User data found: ${userSnapshot.data()}');
        setState(() {
          userData = userSnapshot.data();
          isLoading = false;
        });
      } else {
        print('No user found with ID: $userId');
        setState(() {
          isLoading = false;
          errorMessage = 'User information not found';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading user information: $e';
      });
    }
  }

  Future<void> updateOrderStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("orders")
          .doc(widget.orderId)
          .update({"status": status});

      Get.snackbar(
        "Success",
        "Order status updated to $status",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Update the local data
      setState(() {
        widget.bookingData["status"] = status;
      });
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update order status: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7FAFF),
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
                errorMessage = '';
              });
              _fetchUserData();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 1)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'ORDER STATUS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.bookingData["status"]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (widget.bookingData["status"] ?? "pending").toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text('Accept', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () => updateOrderStatus("accepted"),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.close, color: Colors.white),
                        label: const Text('Decline', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () => updateOrderStatus("declined"),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.done_all, color: Colors.white),
                        label: const Text('Complete', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () => updateOrderStatus("completed"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Service Details Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 1)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildDetailRow('Service', widget.bookingData["serviceName"] ?? "Unknown Service"),
                  _buildDetailRow('Price', "\$${widget.bookingData["price"] ?? "0"}"),
                  _buildDetailRow('Location', widget.bookingData["location"] ?? "No location"),
                  _buildDetailRow('Date', _formatDate(widget.bookingData["date"])),
                  _buildDetailRow('Time', widget.bookingData["time"] ?? "No time specified"),
                  if (widget.bookingData["imageUrl"] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text('Service Image:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.bookingData["imageUrl"],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, size: 50),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Customer Details Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 1)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Customer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  const SizedBox(height: 8),
                  if (errorMessage.isNotEmpty)
                    Text(errorMessage, style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
                  if (userData != null) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: (userData!["profileImage"] != null && userData!["profileImage"].toString().isNotEmpty)
                              ? Image.network(
                            userData!["profileImage"],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, size: 30);
                            },
                          )
                              : const Icon(Icons.person, size: 30),
                        ),
                      ),
                      title: Text(userData!["name"] ?? "Customer", style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (userData!["email"] != null) Text(userData!["email"]),
                          if (userData!["phone"] != null) Text(userData!["phone"]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (userData!["address"] != null) _buildDetailRow('Address', userData!["address"]),
                  ] else if (errorMessage.isEmpty)
                    const Text("Customer information not available"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order Information Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 1)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildDetailRow('Order ID', widget.orderId),
                  _buildDetailRow('Order Date', _formatTimestamp(widget.bookingData["createdAt"])),
                  if (widget.bookingData["providerEmail"] != null)
                    _buildDetailRow('Provider Email', widget.bookingData["providerEmail"]),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return "No date";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return "Invalid date";
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "Unknown date";
    try {
      if (timestamp is Timestamp) {
        return DateFormat('MMM dd, yyyy - HH:mm').format(timestamp.toDate());
      }
      return "Invalid date";
    } catch (e) {
      return "Invalid date";
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "accepted":
        return Colors.green;
      case "declined":
        return Colors.red;
      case "completed":
        return Colors.blue;
      case "in progress":
        return Colors.orange;
      default: // pending
        return Colors.grey;
    }
  }
}