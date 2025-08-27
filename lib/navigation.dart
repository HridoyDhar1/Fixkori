//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:serviceapp/feature/Admin/Home/presentaion/screen/home_screen.dart';
// import 'package:serviceapp/feature/Admin/Profile/screen/admin_details.dart';
// import 'package:serviceapp/feature/Admin/order/screen/order_screen.dart';
// import 'package:serviceapp/feature/Admin/Job/screen/job_post.dart';
// import 'core/config/navigation_controller.dart';
//
// class CustomNavigationScreen extends StatelessWidget {
//   final NavigationController navigationController =
//   Get.put(NavigationController());
//
//   static const String name = '/navigation';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       // Main body with IndexedStack for navigation
//       body: Obx(() {
//         return IndexedStack(
//           index: navigationController.selectedIndex.value,
//           children: [
//             HomeScreenAdmin(),
//             OrdersScreen(),
//             JobPostScreen(),
//             AdminProfileScreen(),
//           ],
//         );
//       }),
//
//       // Bottom Navigation Bar
//       bottomNavigationBar: Obx(() {
//         return BottomNavigationBar(
//           backgroundColor: Colors.white,
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Colors.black87,
//           unselectedItemColor: Colors.grey,
//           currentIndex: navigationController.selectedIndex.value,
//           onTap: (index) => navigationController.updateIndex(index),
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.notifications), // Badge removed
//               label: 'Notification',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.add),
//               label: 'Post',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'Profile',
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serviceapp/feature/Admin/Home/presentaion/screen/home_screen.dart';
import 'package:serviceapp/feature/Admin/Profile/screen/admin_details.dart';

import 'package:serviceapp/feature/Admin/Job/screen/job_post.dart';
import 'package:serviceapp/feature/Admin/order/screen/order_screen.dart';
import 'core/config/navigation_controller.dart';


class CustomNavigationScreen extends StatelessWidget {
  final NavigationController navigationController =
  Get.put(NavigationController());

  static const String name = '/navigation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Main body with IndexedStack for navigation
      body: Obx(() {
        return IndexedStack(
          index: navigationController.selectedIndex.value,
          children: [
            HomeScreenAdmin(),
AdminOrdersScreen(),
            JobPostScreen(),
            AdminProfileScreen(),
          ],
        );
      }),

      // Bottom Navigation Bar
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey,
          currentIndex: navigationController.selectedIndex.value,
          onTap: (index) => navigationController.updateIndex(index),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),

            // ✅ Notification tab with badge
            BottomNavigationBarItem(
              icon: Obx(() {
                final count = navigationController.notificationCount.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications),
                    if (count > 0)
                      Positioned(
                        right: -6,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              }),
              label: 'Notification',
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Post',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}
