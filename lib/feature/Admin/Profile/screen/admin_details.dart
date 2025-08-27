import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serviceapp/feature/Admin/Profile/widget/edit_profile.dart';

import '../../Auth/data/model/admin_model.dart';
import '../data/repository/admin_repository.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  static const String name = '/admin_profile';

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final AdminRepository _adminRepository = AdminRepository();

  AdminModel? adminData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }
  Future<void> _loadAdminData() async {
    try {
      final data = await _adminRepository.fetchAdminData();
      setState(() {
        adminData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", "Failed to fetch admin data");
    }
  }
  Future<void> fetchAdminData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection('admins_profile')
          .where('userId', isEqualTo: user.uid) // Query by user ID
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          adminData = AdminModel.fromMap(snapshot.docs.first.data());
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', 'Failed to fetch admin data');
    }
  }

  Widget _menuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 0.5,
              blurRadius: 0.5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.grey[800], size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: adminData?.imageUrl != null
                          ? NetworkImage(adminData!.imageUrl!)
                          : const NetworkImage(
                                  "https://randomuser.me/api/portraits/men/32.jpg",
                                )
                                as ImageProvider,
                    ),
                    const SizedBox(height: 12),

                    // Name
                    Text(
                      adminData?.name ?? "No Name",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Email
                    Text(
                      adminData?.email ?? "No Email",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),

                    // Location
                    Text(
                      adminData?.location ?? "No Location",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),

                    // Edit Profile Button
                    OutlinedButton(
                      onPressed: () {
                        if (adminData != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileScreen(adminData: adminData!),
                            ),
                          ).then(
                            (_) => fetchAdminData(),
                          ); // Refresh data after returning
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _menuItem(
                      Icons.help_outline,
                      "Help Center",
                      onTap: () => Get.toNamed("/login"),
                    ),
                    _menuItem(Icons.share, "Share & Earn"),
                    _menuItem(Icons.star_border, "Rate us"),

                    _menuItem(Icons.privacy_tip_outlined, "Privacy Policy"),
                    _menuItem(
                      Icons.logout,
                      "Logout",
                      onTap: () => Get.toNamed("/login"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
