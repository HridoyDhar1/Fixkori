
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:serviceapp/feature/User/Home/screen/user_home.dart';
import 'package:serviceapp/feature/User/Profile/presentation/screen/user_profile.dart';
import 'package:serviceapp/feature/User/Search/screen/search_screen.dart';
import 'package:serviceapp/feature/chat/presentaion/screen/chat_list.dart';

import '../../core/config/navigation_controller.dart';

class CustomUserNavigationScreen extends StatelessWidget {
  final NavigationController navigationController = Get.put(NavigationController());
  static const String name = '/user_navigation';

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: Colors.white,

      body: Obx(() {
        return IndexedStack(
          index: navigationController.selectedIndex.value,
          children: [
            UserHomeScreen(),
            SearchScreen(),
ChatListScreen(),
            UserProfileScreen(),
          ],
        );
      }),

      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          currentIndex: navigationController.selectedIndex.value,
          onTap: (index) => navigationController.updateIndex(index),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),

            // ✅ Chat with badge
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.message),
                  if (navigationController.chatCount.value > 0)
                    Positioned(
                      right: -6,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${navigationController.chatCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Chat',
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
