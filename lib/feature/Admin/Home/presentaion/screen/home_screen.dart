import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';
import 'package:serviceapp/feature/Admin/Message/presenation/screen/chat_list.dart';

import '../../../Services/presentaion/screen/services_screen.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({super.key});

  static const String name = '/home_admin';

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  List<Map<String, String>> services = [];
  List<Map<String, String>> filteredServices = [];

  TextEditingController searchController = TextEditingController();

  String adminName = '';
  String adminLocation = '';
  bool isLoading = true;
  bool isServicesLoading = true;

  int unreadMessages = 0; // For unread message badge

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterServices);
    _fetchAdminProfile();
    _fetchServices();
    _listenUnreadMessages();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Listen for unread messages for this admin
  void _listenUnreadMessages() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('serviceApp')
        .doc('appData')
        .collection('messages')
        .where('receiverId', isEqualTo: user.uid)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        unreadMessages = snapshot.docs.length;
      });
    });
  }

  /// Get icon path automatically based on name
  String _getIconForService(String name) {
    String lower = name.toLowerCase();
    if (lower.contains("repair")) return "assets/icons/repair.png";
    if (lower.contains("clean")) return "assets/icons/cleaner.png";
    if (lower.contains("electric")) return "assets/icons/electrician.png";
    if (lower.contains("carpent")) return "assets/icons/carpenter.png";
    if (lower.contains("house")) return "assets/icons/house.png";
    if (lower.contains("event")) return "assets/icons/red-carpet.png";
    return "assets/icons/service.png"; // default
  }

  /// Fetch admin profile from Firestore
  Future<void> _fetchAdminProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection("serviceApp")
            .doc("appData")
            .collection('admins_profile')
            .where('userId', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          setState(() {
            adminName = data['name'] ?? 'No Name';
            adminLocation = data['location'] ?? 'No Location';
            isLoading = false;
          });
        } else {
          setState(() {
            adminName = 'Unknown';
            adminLocation = 'Unknown';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        adminName = 'Error';
        adminLocation = '';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchServices() async {
    try {
      FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection('services')
          .snapshots()
          .listen((snapshot) {
        final loadedServices = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            "id": doc.id,
            "title": (data['title'] ?? '').toString(),
            "asset": (data['asset'] ?? _getIconForService(data['title'] ?? ''))
                .toString(),
          };
        }).toList();

        setState(() {
          services = loadedServices;
          filteredServices = List.from(services);
          isServicesLoading = false;
        });
      });
    } catch (e) {
      print("Error fetching services: $e");
      setState(() {
        isServicesLoading = false;
      });
    }
  }

  void _filterServices() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredServices = List.from(services);
      } else {
        filteredServices = services.where((service) {
          return service["title"]!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _addService(String name) async {
    try {
      final newService = {"title": name, "asset": _getIconForService(name)};
      await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection('services')
          .add(newService);

      await _fetchServices();
    } catch (e) {
      print("Error adding service: $e");
    }
  }

  Future<void> _deleteService(int index) async {
    try {
      final serviceId = services[index]['id'];
      if (serviceId != null) {
        await FirebaseFirestore.instance
            .collection("serviceApp")
            .doc("appData")
            .collection('services')
            .doc(serviceId)
            .delete();
      }

      setState(() {
        services.removeAt(index);
        _filterServices();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Service deleted"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print("Error deleting service: $e");
    }
  }

  void _showAddServiceDialog() {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Service"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Service Name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            CustomButton(
              name: "Save",
              width: 100,
              height: 50,
              color: Colors.black87,
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  _addService(nameController.text);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Service"),
        content: Text(
          "Are you sure you want to delete '${services[index]["title"]}'?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _deleteService(index);
              Navigator.pop(context);
            },
            child: const Text(
              "Yes, Delete",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(color: Color(0xFFFFEB99)),
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoading ? "Loading..." : adminName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isLoading ? "Loading..." : adminLocation,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    // ✅ Chat button with badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: () {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminChatList(),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.message, color: Colors.white),
                        ),
                        if (unreadMessages > 0)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '$unreadMessages',
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

                  ],
                ),
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "I want to hire a...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Services Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: isServicesLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Services",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        ...filteredServices.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, String> service = entry.value;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceDetailScreen(
                                    serviceTitle: service["title"]!,
                                  ),
                                ),
                              );
                            },
                            onDoubleTap: () {
                              int originalIndex = services.indexWhere(
                                    (s) => s["title"] == service["title"],
                              );
                              if (originalIndex != -1) {
                                _showDeleteDialog(originalIndex);
                              }
                            },
                            child: serviceCard(
                              service["title"]!,
                              service["asset"] ?? '',
                            ),
                          );
                        }),
                        GestureDetector(
                          onTap: _showAddServiceDialog,
                          child: serviceCard(
                            "Add",
                            "assets/icons/image-gallery.png",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceCard(String title, String assetPath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath, height: 40, width: 40),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
