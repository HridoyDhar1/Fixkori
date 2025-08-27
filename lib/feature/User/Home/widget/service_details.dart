
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';

import '../../../Admin/Auth/data/model/admin_model.dart';

import '../../../chat/presentaion/widget/chat_screen.dart';
import '../../Company/screen/company_profile.dart';
import '../../Search/wiget/order_details.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsScreen({super.key, required this.service});

  static const String name = '/service';

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Map<String, dynamic>? providerData;

  @override
  void initState() {
    super.initState();
    _fetchProvider();
  }

  // Fetch provider/admin profile
  Future<void> _fetchProvider() async {
    final userId = widget.service["userId"];
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection('admins_profile')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        providerData = snapshot.docs.first.data();
      });
    }
  }

  // Pick Date
  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  // Pick Time
  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }
  Future<void> _openChat() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar(
        "Error",
        "You must be logged in to chat",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final providerId = providerData?["userId"] ?? widget.service["userId"];
    final providerName = providerData?["name"] ?? "Service Provider";
    final providerImageUrl = providerData?["profileImage"] ?? "";

    final chatsRef = FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("chats");

    // Check if chat exists
    final existingChatQuery = await chatsRef
        .where("userId", isEqualTo: user.uid)
        .where("providerId", isEqualTo: providerId)
        .limit(1)
        .get();

    String chatId;
    if (existingChatQuery.docs.isNotEmpty) {
      chatId = existingChatQuery.docs.first.id;

      // Make sure userName and userImageUrl are updated
      await chatsRef.doc(chatId).update({
        "userName": user.displayName ?? "User",
        "userImageUrl": user.photoURL ?? "",
      });
    } else {
      // Create new chat
      final newChatDoc = await chatsRef.add({
        "userId": user.uid,
        "providerId": providerId,
        "userName": user.displayName ?? "User",
        "providerName": providerName,
        "userImageUrl": user.photoURL ?? "",
        "providerImageUrl": providerImageUrl,
        "serviceCard": {
          "post": widget.service["post"] ?? "Untitled Service",
          "price": widget.service["price"] ?? "0",
          "imageUrl": widget.service["imageUrl"] ?? "",
        },
        "lastMessage": "",
        "lastMessageTime": FieldValue.serverTimestamp(),
      });
      chatId = newChatDoc.id;
    }

    // Navigate to chat screen
    Get.to(() => UserChatScreen(
      chatId: chatId,
      otherUserId: providerId,
      otherUserName: providerName,
    ));
  }

  // Future<void> _openChat() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     Get.snackbar(
  //       "Error",
  //       "You must be logged in to chat",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }
  //
  //   // Provider info
  //   final providerId = providerData?["userId"] ?? widget.service["userId"];
  //   final providerName = providerData?["name"] ?? "Service Provider";
  //   final providerImageUrl = providerData?["profileImage"] ?? "";
  //
  //   final chatsRef = FirebaseFirestore.instance
  //       .collection("serviceApp")
  //       .doc("appData")
  //       .collection("chats");
  //
  //   // Check if chat already exists between this user and provider
  //   final existingChatQuery = await chatsRef
  //       .where("userId", isEqualTo: user.uid)
  //       .where("providerId", isEqualTo: providerId)
  //       .limit(1)
  //       .get();
  //
  //   String chatId;
  //   if (existingChatQuery.docs.isNotEmpty) {
  //     chatId = existingChatQuery.docs.first.id;
  //   } else {
  //     final newChatDoc = await chatsRef.add({
  //       "userId": user.uid,
  //       "providerId": providerId,
  //       "userName": user.displayName ?? "User",
  //       "providerName": providerName,
  //       "userImageUrl": user.photoURL ?? "",
  //       "providerImageUrl": providerImageUrl,
  //       "serviceCard": {
  //         "post": widget.service["post"] ?? "Untitled Service",
  //         "price": widget.service["price"] ?? "0",
  //         "imageUrl": widget.service["imageUrl"] ?? "",
  //       },
  //       "lastMessage": "",
  //       "lastMessageTime": FieldValue.serverTimestamp(),
  //     });
  //     chatId = newChatDoc.id;
  //   }
  //
  //   // Navigate to single chat screen
  //   Get.to(() => UserChatScreen(
  //     chatId: chatId,
  //     otherUserId: providerId, // Pass provider ID
  //     otherUserName: providerName, // Pass provider name
  //   ));
  // }


  // Place order
  Future<void> _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (selectedDate == null || selectedTime == null) {
      Get.snackbar(
        "Error",
        "Please select date and time before booking",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final providerId = providerData?["userId"] ?? widget.service["userId"];

      final orderData = {
        "userId": user.uid,
        "serviceId": widget.service["id"] ??
            widget.service["timestamp"].toString(),
        "serviceName": widget.service["post"] ?? "Untitled Service",
        "price": widget.service["price"] ?? "0",
        "location": widget.service["location"] ?? "No location",
        "imageUrl": widget.service["imageUrl"],
        "date": selectedDate!.toIso8601String(),
        "time":
        "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
        "status": "pending",
        "providerUserId": providerId,
        "providerEmail": providerData?["email"] ?? widget.service["userEmail"],
        "createdAt": FieldValue.serverTimestamp(),
      };

      final orderRef = await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("orders")
          .add(orderData);

      // Add notification only for this admin
      await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("admins_profile")
          .doc(providerId)
          .collection("notifications")
          .add({
        "orderId": orderRef.id,
        "title": "New Order Received",
        "body": "You have a new order for ${widget.service["post"]} at ${orderData["time"]}",
        "createdAt": FieldValue.serverTimestamp(),
        "isRead": false,
      });

      // Automatically create chat if not exists
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationScreen(

            service: widget.service,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
          ),
        ),
      );

      Get.snackbar(
        "Success",
        "Order placed successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to place order: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.service;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: job["imageUrl"] != null
                  ? Image.network(
                job["imageUrl"],
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          job["post"] ?? "Untitled Service",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "\$${job["price"] ?? '0'}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Category
                  if (job["category"] != null)
                    Row(
                      children: [
                        const Icon(Icons.category, color: Colors.blue, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          job["category"],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.redAccent, size: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          job["location"] ?? "No location provided",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Date & Time Picker
                  const Text("Select Date & Time",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size(100, 50),
                            backgroundColor: Colors.grey,
                          ),
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.white),
                          label: Text(
                            selectedDate == null
                                ? "Pick Date"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          onPressed: pickDate,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size(100, 50),
                            backgroundColor: Colors.black87,
                          ),
                          icon:
                          const Icon(Icons.access_time, color: Colors.white),
                          label: Text(
                            selectedTime == null
                                ? "Pick Time"
                                : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          onPressed: pickTime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Service Description
                  const Text("Service Description",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(
                    "This is a professional ${job["post"] ?? "service"} provided by our expert team. "
                        "We ensure high quality service with 100% satisfaction.",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 20),

                  // Service Provider Section
                  const Text("Service Provider",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),

                  providerData == null
                      ? const Center(child: CircularProgressIndicator())
                      : GestureDetector(
                    onTap: () {
                      final admin = AdminModel(
                        userId: providerData!['userId'] ?? '',
                        name: providerData!['name'] ?? 'Service Provider',
                        email: providerData!['email'] ?? '',
                        number: providerData!['number'] ?? '',
                        location: providerData!['location'] ?? '',
                        workType: providerData!['workType'] ?? '',
                        employees: providerData!['employees'] ?? '',
                        country: providerData!['country'] ?? '',
                        imageUrl: providerData!['profileImage'] ?? '',
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CompanyProfileDetails(admin: admin),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.teal.withOpacity(0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[200],
                            child: ClipOval(
                              child: (providerData!["imageUrl"] != null &&
                                  providerData!["imageUrl"]
                                      .toString()
                                      .isNotEmpty)
                                  ? Image.network(
                                providerData!["imageUrl"],
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
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  providerData!["name"] ??
                                      "Service Provider",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                if (providerData!["email"] != null)
                                  Text(
                                    providerData!["email"],
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14),
                                  ),
                                const SizedBox(height: 4),
                                Row(
                                  children: const [
                                    Icon(Icons.verified,
                                        color: Colors.teal, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      "Verified Provider",
                                      style: TextStyle(
                                          color: Colors.teal, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.teal),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Map placeholder
                  const Text("Service Location",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: AssetImage("assets/images/map_placeholder.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Buttons
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.message, color: Colors.teal),
                label: const Text("Message", style: TextStyle(color: Colors.teal)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(100, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Colors.teal),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _openChat,
              ),
            ),
            const SizedBox(width: 8),
            CustomButton(
              name: "Order",
              width: 200,
              height: 50,
              color: Colors.teal,
              onPressed: _placeOrder,
            ),
          ],
        ),
      ),
    );
  }
}
