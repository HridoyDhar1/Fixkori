
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> booking;
  final String bookingId;

  const BookingDetailsScreen({
    super.key,
    required this.booking,
    required this.bookingId,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  Map<String, dynamic>? providerData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProviderData();
  }

  Future<void> _fetchProviderData() async {
    try {
      final providerId = widget.booking["providerUserId"];
      print('Fetching provider data for ID: $providerId');

      if (providerId == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'No provider ID found in booking data';
        });
        return;
      }

      // Try multiple possible collection paths
      final CollectionReference providersRef = FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection('admins_profile');

      final snapshot = await providersRef.doc(providerId).get();

      if (snapshot.exists) {
        print('Provider data found: ${snapshot.data()}');
        setState(() {
          providerData = snapshot.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        print('No provider found with ID: $providerId');

        // Alternative approach: query by userId field
        final querySnapshot = await providersRef
            .where('userId', isEqualTo: providerId)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          print('Provider found using userId query: ${querySnapshot.docs.first.data()}');
          setState(() {
            providerData = querySnapshot.docs.first.data() as Map<String, dynamic>;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'Provider information not found';
          });
        }
      }
    } catch (e) {
      print('Error fetching provider data: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading provider information: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7FAFF),
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Details Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Service',
                    widget.booking["serviceName"] ?? "Unknown Service",
                  ),
                  _buildDetailRow(
                    'Price',
                    "\$${widget.booking["price"] ?? "0"}",
                  ),
                  _buildDetailRow(
                    'Location',
                    widget.booking["location"] ?? "No location",
                  ),
                  _buildDetailRow(
                    'Date',
                    _formatDate(widget.booking["date"]),
                  ),
                  _buildDetailRow(
                    'Time',
                    widget.booking["time"] ?? "No time specified",
                  ),
                  _buildDetailRow(
                    'Status',
                    widget.booking["status"] ?? "pending",
                    status: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Provider Details Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Provider',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),

                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                  if (providerData != null) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: (providerData!["profileImage"] != null &&
                              providerData!["profileImage"]
                                  .toString()
                                  .isNotEmpty)
                              ? Image.network(
                            providerData!["profileImage"],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/default_avatar.png",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                              : Image.asset(
                            "assets/images/default_avatar.png",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        providerData!["name"] ?? "Service Provider",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (providerData!["email"] != null)
                            Text(providerData!["email"]),
                          if (providerData!["number"] != null)
                            Text(providerData!["number"]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (providerData!["location"] != null)
                      _buildDetailRow(
                        'Provider Location',
                        providerData!["location"],
                      ),
                    if (providerData!["workType"] != null)
                      _buildDetailRow(
                        'Work Type',
                        providerData!["workType"],
                      ),
                    if (providerData!["companyName"] != null)
                      _buildDetailRow(
                        'Company',
                        providerData!["companyName"],
                      ),
                  ] else if (errorMessage.isEmpty)
                    const Text("Provider information not available"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Booking Info Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Booking ID',
                    widget.bookingId,
                  ),
                  _buildDetailRow(
                    'Order Date',
                    _formatTimestamp(widget.booking["createdAt"]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDetailRow(String label, String value, {bool status = false}) {
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
            child: status
                ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(value),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                value.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
                : Text(value),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      case "in progress":
        return Colors.orange;
      default: // pending
        return Colors.blue;
    }
  }
}