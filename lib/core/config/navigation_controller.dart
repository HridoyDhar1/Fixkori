
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;
  var notificationCount = 0.obs;
  var _orderListener = null;
  var chatCount=0.obs;

  @override
  void onInit() {
    super.onInit();
    _listenForNewOrders();
  }

  @override
  void onClose() {
    _orderListener?.cancel();
    super.onClose();
  }

  void updateIndex(int index) {
    selectedIndex.value = index;

    // Reset notification count when user visits notifications tab
    if (index == 1) {
      resetNotificationCount();
    }
  }

  void _listenForNewOrders() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Listen for new orders assigned to this admin
    _orderListener = FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("orders")
        .where("providerUserId", isEqualTo: user.uid)
        .where("status", isEqualTo: "pending")
        .snapshots()
        .listen((snapshot) {
      notificationCount.value = snapshot.docs.length;
    }, onError: (error) {
      print("Error listening for orders: $error");
    });
  }

  void resetNotificationCount() {
    notificationCount.value = 0;
  }

  // Optional: Mark orders as seen/read
  Future<void> markOrdersAsSeen() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("orders")
          .where("providerUserId", isEqualTo: user.uid)
          .where("status", isEqualTo: "pending")
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in ordersSnapshot.docs) {
        batch.update(doc.reference, {
          "notificationSeen": true,
          "seenAt": FieldValue.serverTimestamp()
        });
      }

      await batch.commit();
      resetNotificationCount();
    } catch (e) {
      print("Error marking orders as seen: $e");
    }
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// class NavigationController extends GetxController {
//   var selectedIndex = 0.obs;
//   var notificationCount = 0.obs; // For admin orders
//   var chatCount = 0.obs; // For user messages
//   var _orderListener = null;
//   var _chatListener = null;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _listenForNewOrders();
//     _listenForNewMessages();
//   }
//
//   @override
//   void onClose() {
//     _orderListener?.cancel();
//     _chatListener?.cancel();
//     super.onClose();
//   }
//
//   void updateIndex(int index) {
//     selectedIndex.value = index;
//
//     // Reset notification count when user visits notifications tab
//     if (index == 1) {
//       resetNotificationCount();
//     }
//     // Reset chat count when user visits chat tab
//     if (index == 2) {
//       resetChatCount();
//     }
//   }
//
//   void _listenForNewOrders() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     // Listen for new orders assigned to this admin (for admin users)
//     _orderListener = FirebaseFirestore.instance
//         .collection("serviceApp")
//         .doc("appData")
//         .collection("orders")
//         .where("providerUserId", isEqualTo: user.uid)
//         .where("status", isEqualTo: "pending")
//         .snapshots()
//         .listen((snapshot) {
//       notificationCount.value = snapshot.docs.length;
//     }, onError: (error) {
//       print("Error listening for orders: $error");
//     });
//   }
//
//   void _listenForNewMessages() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     // Listen for unread messages in all chats where user is a participant
//     _chatListener = FirebaseFirestore.instance
//         .collection("serviceApp")
//         .doc("appData")
//         .collection("chats")
//         .where("participants.${user.uid}", isNull: false)
//         .snapshots()
//         .listen((chatSnapshot) {
//       int totalUnread = 0;
//
//       // For each chat, check unread messages
//       for (final chatDoc in chatSnapshot.docs) {
//         final chatId = chatDoc.id;
//
//         // Listen for unread messages in this specific chat
//         FirebaseFirestore.instance
//             .collection("serviceApp")
//             .doc("appData")
//             .collection("chats")
//             .doc(chatId)
//             .collection("messages")
//             .where('senderId', isNotEqualTo: user.uid) // Messages from others
//             .where('read', isEqualTo: false) // Unread messages
//             .snapshots()
//             .listen((messageSnapshot) {
//           if (mounted) {
//             totalUnread += messageSnapshot.docs.length;
//             chatCount.value = totalUnread;
//           }
//         });
//       }
//     }, onError: (error) {
//       print("Error listening for messages: $error");
//     });
//   }
//
//   void resetNotificationCount() {
//     notificationCount.value = 0;
//   }
//
//   void resetChatCount() {
//     chatCount.value = 0;
//     _markAllMessagesAsRead();
//   }
//
//   // Mark all messages as read when user opens chat tab
//   Future<void> _markAllMessagesAsRead() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     try {
//       // Get all chats where user is a participant
//       final chatSnapshot = await FirebaseFirestore.instance
//           .collection("serviceApp")
//           .doc("appData")
//           .collection("chats")
//           .where("participants.${user.uid}", isNull: false)
//           .get();
//
//       final batch = FirebaseFirestore.instance.batch();
//
//       for (final chatDoc in chatSnapshot.docs) {
//         final chatId = chatDoc.id;
//
//         // Get all unread messages from others in this chat
//         final messagesSnapshot = await FirebaseFirestore.instance
//             .collection("serviceApp")
//             .doc("appData")
//             .collection("chats")
//             .doc(chatId)
//             .collection("messages")
//             .where('senderId', isNotEqualTo: user.uid)
//             .where('read', isEqualTo: false)
//             .get();
//
//         // Mark each message as read
//         for (final messageDoc in messagesSnapshot.docs) {
//           batch.update(messageDoc.reference, {
//             "read": true,
//             "readAt": FieldValue.serverTimestamp()
//           });
//         }
//       }
//
//       await batch.commit();
//     } catch (e) {
//       print("Error marking messages as read: $e");
//     }
//   }
//
//   // Optional: Mark orders as seen/read (for admin)
//   Future<void> markOrdersAsSeen() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     try {
//       final ordersSnapshot = await FirebaseFirestore.instance
//           .collection("serviceApp")
//           .doc("appData")
//           .collection("orders")
//           .where("providerUserId", isEqualTo: user.uid)
//           .where("status", isEqualTo: "pending")
//           .get();
//
//       final batch = FirebaseFirestore.instance.batch();
//
//       for (final doc in ordersSnapshot.docs) {
//         batch.update(doc.reference, {
//           "notificationSeen": true,
//           "seenAt": FieldValue.serverTimestamp()
//         });
//       }
//
//       await batch.commit();
//       resetNotificationCount();
//     } catch (e) {
//       print("Error marking orders as seen: $e");
//     }
//   }
// }