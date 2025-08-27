// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../widget/carousel_card.dart';
// import '../widget/service_card.dart';
// import '../widget/service_category.dart';
//
// class UserHomeScreen extends StatefulWidget {
//   const UserHomeScreen({super.key});
//
//   static const String name = '/user_home';
//
//   @override
//   State<UserHomeScreen> createState() => _UserHomeScreenState();
// }
//
// class _UserHomeScreenState extends State<UserHomeScreen> {
//   final PageController _pageController = PageController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("serviceApp")
//               .doc("appData")
//               .collection('job_posts')
//               .orderBy('timestamp', descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             final jobs = snapshot.data!.docs
//                 .map((doc) => doc.data() as Map<String, dynamic>)
//                 .toList();
//
//             // ✅ Extract unique categories
//             final categories = [
//               ...{
//                 for (var job in jobs) (job['category'] ?? '').toString()
//               }..removeWhere((c) => c.isEmpty),
//             ];
//
//             return ListView(
//               children: [
//                 const SizedBox(height: 10),
//                 _buildCarousel(),
//                 const SizedBox(height: 15),
//                 ServiceCategoryGrid(),
//
//                 // ✅ Dynamically build category sections
//                 for (var category in categories) ...[
//                   _buildSectionTitle(category),
//                   _buildHorizontalList(
//                     jobs
//                         .where((job) => job['category'] == category)
//                         .map((job) => HomeServiceCard(
//
//                       title: job['post'] ?? "No Title",
//                       price: "\$${job['price'] ?? '0'}",
//                       imageUrl: job['imageUrl'] ??
//                           "assets/images/placeholder.png",
//
//                     ))
//                         .toList(),
//                   ),
//                 ],
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCarousel() {
//     return SizedBox(
//       height: 200,
//       child: PageView(
//         controller: _pageController,
//         children: [
//           HomeCarouselCard(
//             title: "Destroy all your uninvited guests at Home",
//             buttonText: "Book Now",
//             imageAssetPath: "assets/images/17837.jpg",
//           ),
//           HomeCarouselCard(
//             title: "Offer 2",
//             buttonText: "Book Now",
//             imageAssetPath: "assets/images/hvac-engineer-dusting-blower-fan.jpg",
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
//       child: Row(
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const Spacer(),
//           Text(
//             "View all",
//             style: TextStyle(fontSize: 14, color: Colors.blue[700]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHorizontalList(List<Widget> items) {
//     return SizedBox(
//       height: 150,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: items,
//       ),
//     );
//   }
// }
//
// // ✅ Example HomeServiceCard widget
// class HomeServiceCard extends StatelessWidget {
//   final String title;
//   final String price;
//   final String imageUrl;
//
//   const HomeServiceCard({
//     super.key,
//     required this.title,
//     required this.price,
//     required this.imageUrl,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 120,
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // If image is a network link, use Image.network
//           imageUrl.startsWith("http")
//               ? Image.network(
//             imageUrl,
//             height: 80,
//             width: 120,
//             fit: BoxFit.cover,
//             errorBuilder: (_, __, ___) => Image.asset(
//               "assets/images/placeholder.png",
//               height: 80,
//               width: 120,
//               fit: BoxFit.cover,
//             ),
//           )
//               : Image.asset(
//             imageUrl,
//             height: 80,
//             width: 120,
//             fit: BoxFit.cover,
//           ),
//           const SizedBox(height: 6),
//           Text(
//             title,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text(
//             price,
//             style: const TextStyle(color: Colors.green),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:serviceapp/feature/User/Home/widget/service_details.dart';
// import '../widget/carousel_card.dart';
// import '../widget/service_card.dart';
// import '../widget/service_category.dart';
//
// class UserHomeScreen extends StatefulWidget {
//   const UserHomeScreen({super.key});
//
//   static const String name = '/user_home';
//
//   @override
//   State<UserHomeScreen> createState() => _UserHomeScreenState();
// }
//
// class _UserHomeScreenState extends State<UserHomeScreen> {
//   final PageController _pageController = PageController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("serviceApp")
//               .doc("appData")
//               .collection('job_posts')
//               .orderBy('timestamp', descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             final jobs = snapshot.data!.docs
//                 .map((doc) => doc.data() as Map<String, dynamic>)
//                 .toList();
//
//             // ✅ Extract unique categories
//             final categories = [
//               ...{
//                 for (var job in jobs) (job['category'] ?? '').toString()
//               }..removeWhere((c) => c.isEmpty),
//             ];
//
//             return ListView(
//               children: [
//                 const SizedBox(height: 10),
//                 _buildCarousel(),
//                 const SizedBox(height: 15),
//                 ServiceCategoryGrid(),
//
//                 // ✅ Dynamically build category sections
//                 for (var category in categories) ...[
//                   _buildSectionTitle(category),
//                   _buildHorizontalList(
//                     jobs.where((job) => job['category'] == category).toList(),
//                   ),
//                 ],
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCarousel() {
//     return SizedBox(
//       height: 200,
//       child: PageView(
//         controller: _pageController,
//         children: [
//           HomeCarouselCard(
//             title: "Destroy all your uninvited guests at Home",
//             buttonText: "Book Now",
//             imageAssetPath: "assets/images/17837.jpg",
//           ),
//           HomeCarouselCard(
//             title: "Offer 2",
//             buttonText: "Book Now",
//             imageAssetPath: "assets/images/hvac-engineer-dusting-blower-fan.jpg",
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
//       child: Row(
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const Spacer(),
//           Text(
//             "View all",
//             style: TextStyle(fontSize: 14, color: Colors.blue[700]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ✅ Updated horizontal list with navigation
//   Widget _buildHorizontalList(List<Map<String, dynamic>> jobs) {
//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: jobs.length,
//         itemBuilder: (context, index) {
//           final job = jobs[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       ServiceDetailsScreen(service: job), // Pass job
//                 ),
//               );
//             },
//             child: HomeServiceCard(
//               title: job['post'] ?? "No Title",
//               price: "\$${job['price'] ?? '0'}",
//               imageUrl: job['imageUrl'] ?? "assets/images/placeholder.png",
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serviceapp/feature/User/Home/widget/service_details.dart';
import '../../Search/screen/search_screen.dart';
import '../widget/carousel_card.dart';
import '../widget/service_card.dart';
import '../widget/service_category.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  static const String name = '/user_home';

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("all_job_posts") // ✅ fetch from global jobs
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final jobs = snapshot.data!.docs
                .map((doc) => {
              "id": doc.id,
              ...doc.data() as Map<String, dynamic>,
            })
                .toList();

            if (jobs.isEmpty) {
              return const Center(child: Text("No jobs available"));
            }

            // ✅ Extract unique categories
            final categories = [
              ...{
                for (var job in jobs) (job['category'] ?? '').toString()
              }..removeWhere((c) => c.isEmpty),
            ];

            return ListView(
              children: [
                const SizedBox(height: 10),
                _buildCarousel(),
                const SizedBox(height: 15),
                ServiceCategoryGrid(),

                // ✅ Dynamically build category sections
                for (var category in categories) ...[
                  _buildSectionTitle(category),
                  _buildHorizontalList(
                    jobs.where((job) => job['category'] == category).toList(),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 200,
      child: PageView(
        controller: _pageController,
        children: [
          HomeCarouselCard(
            title: "Destroy all your uninvited guests at Home",
            buttonText: "Book Now",
            imageAssetPath: "assets/images/17837.jpg",
          ),
          HomeCarouselCard(
            title: "Offer 2",
            buttonText: "Book Now",
            imageAssetPath: "assets/images/hvac-engineer-dusting-blower-fan.jpg",
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          GestureDetector(

            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(initialCategory: title), // ✅ pass category
                ),
              );
            },
            child: Text(
              "View all",
              style: TextStyle(fontSize: 14, color: Colors.blue[700]),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Updated horizontal list with navigation
  Widget _buildHorizontalList(List<Map<String, dynamic>> jobs) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailsScreen(service: job),
                ),
              );
            },
            child: HomeServiceCard(
              title: job['post'] ?? "No Title",
              price: "\$${job['price'] ?? '0'}",
              imageUrl: job['imageUrl'] ??
                  "https://via.placeholder.com/150", // ✅ fallback image
            ),
          );
        },
      ),
    );
  }
}
