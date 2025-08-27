// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../Admin/notification/widget/order_details.dart';
//
//
//
// class UserBookingListScreen extends StatefulWidget {
//   const UserBookingListScreen({super.key});
//
//   @override
//   State<UserBookingListScreen> createState() => _UserBookingListScreenState();
// }
//
// class _UserBookingListScreenState extends State<UserBookingListScreen> {
//   final user = FirebaseAuth.instance.currentUser;
//
//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("My Bookings")),
//         body: const Center(
//           child: Text("Please login to see your bookings."),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Bookings"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("serviceApp")
//             .doc("appData")
//             .collection("orders")
//             .where("userId", isEqualTo: user!.uid)
//             .orderBy("createdAt", descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text("You have not placed any bookings yet."),
//             );
//           }
//
//           final bookings = snapshot.data!.docs;
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               final booking = bookings[index];
//               final data = booking.data() as Map<String, dynamic>;
//
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 child: ListTile(
//                   leading: data["imageUrl"] != null
//                       ? ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       data["imageUrl"],
//                       width: 60,
//                       height: 60,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                       : Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(8)),
//                     child: const Icon(Icons.image_not_supported),
//                   ),
//                   title: Text(data["serviceName"] ?? "Untitled Service"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Price: \$${data["price"] ?? "0"}"),
//                       Text(
//                           "Date: ${data["date"]?.split("T").first ?? "N/A"}"),
//                       Text("Time: ${data["time"] ?? "N/A"}"),
//                       Text("Status: ${data["status"] ?? "pending"}"),
//                     ],
//                   ),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                   onTap: () {
//                     // You can navigate to order details page
//                     Get.to(() => OrderDetailsScreen(orderData: data));
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
