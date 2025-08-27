import 'package:flutter/material.dart';
import 'package:serviceapp/feature/User/Home/widget/service_post.dart';

class ServiceCategoryGrid extends StatelessWidget {
  const ServiceCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final mainCategories = [
      {"icon": Icons.local_laundry_service, "label": "Appliances"},
      {"icon": Icons.format_paint, "label": "Painting"},
      {"icon": Icons.electrical_services, "label": "Electrical"},
      {"icon": Icons.cleaning_services, "label": "Cleaning"},
      {"icon": Icons.ac_unit, "label": "Ac Services"},
      {"icon": Icons.handshake, "label": "Home Assist"},
      {"icon": Icons.bug_report, "label": "Pest Control"},
      {"icon": Icons.grid_view, "label": "More"},
    ];

    final extraCategories = [
      {"icon": Icons.plumbing, "label": "Plumbing"},
      {"icon": Icons.carpenter, "label": "Carpentry"},
      {"icon": Icons.security, "label": "Security"},
      {"icon": Icons.roofing, "label": "Roof Repair"},
      {"icon": Icons.wifi, "label": "Internet Setup"},
    ];

    void openServicePosts(BuildContext context, String serviceName) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServicePostsScreen(serviceName: serviceName),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
          ),
          itemCount: mainCategories.length,
          itemBuilder: (context, index) {
            final category = mainCategories[index];

            return InkWell(
              onTap: () {
                if (category["label"] == "More") {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                          ),
                          itemCount: extraCategories.length,
                          itemBuilder: (context, extraIndex) {
                            final extra = extraCategories[extraIndex];
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context); // Close bottom sheet
                                openServicePosts(context, extra["label"] as String);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      extra["icon"] as IconData,
                                      size: 28,
                                      color: Colors.blueGrey,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      extra["label"] as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  openServicePosts(context, category["label"] as String);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category["icon"] as IconData,
                      size: 28,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category["label"] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
