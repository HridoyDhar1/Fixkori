
import 'package:get/get.dart';

// class NavigationController extends GetxController {
//   var notificationCount = 0.obs;
//
//   void incrementNotifications() {
//     notificationCount.value++;
//   }
//
//   void clearNotifications() {
//     notificationCount.value = 0;
//   }
//
//   var selectedIndex = 0.obs;
//
//   void updateIndex(int index) {
//     selectedIndex.value = index;
//   }
// }
//
// class NavigationController extends GetxController {
//   var selectedIndex = 0.obs;
//   var orderCount = 0.obs;
//
//   void updateIndex(int index) {
//     selectedIndex.value = index;
//
//     // ✅ Clear badge when user opens OrdersScreen
//     if (index == 1) {
//       clearOrders();
//     }
//
//   }
//
//   void incrementOrder() {
//     orderCount.value++;
//   }
//
//   void clearOrders() {
//     orderCount.value = 0;
//   }
// }
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;
  var notificationCount = 0.obs; // for admin notifications
  var chatCount = 0.obs; // 🔴 new: unread messages for user chat

  void updateIndex(int index) {
    selectedIndex.value = index;

    // ✅ Clear counts when user visits specific tab
    if (index == 1) {
      notificationCount.value = 0; // Search/Notification tab (if needed)
    }
    if (index == 2) {
      chatCount.value = 0; // Chat tab
    }
  }

  // Functions to increment counts
  void incrementNotification() {
    notificationCount.value++;
  }

  void incrementChat() {
    chatCount.value++;
  }
}
