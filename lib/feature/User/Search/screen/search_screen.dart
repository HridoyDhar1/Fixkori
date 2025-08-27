//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:serviceapp/feature/User/Home/widget/service_details.dart';
//
// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   String selectedCategory = "All";
//   String searchQuery = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF7FAFF),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Search bar
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.search, color: Colors.grey),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: TextField(
//                               onChanged: (value) {
//                                 setState(() {
//                                   searchQuery = value;
//                                 });
//                               },
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: "Search your needs here",
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Container(
//                     height: 50,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.teal,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(Icons.tune, color: Colors.white),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               // Firestore data stream
//               StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection("serviceApp")
//                     .doc("appData")
//                     .collection('job_posts')
//                     .orderBy('timestamp', descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Expanded(
//                       child: Center(child: CircularProgressIndicator()),
//                     );
//                   }
//
//                   final jobs = snapshot.data!.docs
//                       .map((doc) => doc.data() as Map<String, dynamic>)
//                       .toList();
//
//                   // Extract unique categories
//                   final categories = [
//                     "All",
//                     ...{
//                       for (var job in jobs) (job['category'] ?? '').toString()
//                     }..removeWhere((c) => c.isEmpty),
//                   ];
//
//                   // Filter jobs
//                   final filteredJobs = jobs.where((job) {
//                     final matchesCategory = selectedCategory == "All" ||
//                         (job["category"] ?? "") == selectedCategory;
//                     final matchesSearch = (job["post"] ?? "")
//                         .toString()
//                         .toLowerCase()
//                         .contains(searchQuery.toLowerCase());
//                     return matchesCategory && matchesSearch;
//                   }).toList();
//
//                   return Expanded(
//                     child: Column(
//                       children: [
//                         // Categories
//                         SizedBox(
//                           height: 40,
//                           child: ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: categories.length,
//                             separatorBuilder: (_, __) =>
//                             const SizedBox(width: 8),
//                             itemBuilder: (context, index) {
//                               bool isSelected =
//                                   categories[index] == selectedCategory;
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedCategory = categories[index];
//                                   });
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 16),
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? Colors.teal
//                                         : Colors.transparent,
//                                     border: Border.all(
//                                         color: Colors.teal, width: 1.2),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       categories[index],
//                                       style: TextStyle(
//                                         color: isSelected
//                                             ? Colors.white
//                                             : Colors.teal,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//
//                         const SizedBox(height: 16),
//
//                         // Job cards
//                         Expanded(
//                           child: GridView.builder(
//                             itemCount: filteredJobs.length,
//                             gridDelegate:
//                             SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               mainAxisSpacing: 12,
//                               crossAxisSpacing: 12,
//                               childAspectRatio: 0.8,
//                             ),
//                             itemBuilder: (context, index) {
//                               final job = filteredJobs[index];
//                               return GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ServiceDetailsScreen(
//                                         service: job,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(12),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.shade200,
//                                         spreadRadius: 2,
//                                         blurRadius: 6,
//                                       ),
//                                     ],
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.vertical(
//                                           top: Radius.circular(12),
//                                         ),
//                                         child: job["imageUrl"] != null
//                                             ? Image.network(
//                                           job["imageUrl"],
//                                           height: 160,
//                                           width: double.infinity,
//                                           fit: BoxFit.cover,
//                                         )
//                                             : Container(
//                                           height: 160,
//                                           color: Colors.grey[300],
//                                           child: Icon(
//                                             Icons.broken_image,
//                                             color: Colors.grey[600],
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               job["post"] ?? "",
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             Text(
//                                               "\$${job["price"] ?? ''}",
//                                               style: TextStyle(
//                                                 color: Colors.teal,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             // Text(
//                                             //   job["location"] ?? "",
//                                             //   style: TextStyle(
//                                             //     color: Colors.grey[600],
//                                             //     fontSize: 5,
//                                             //   ),
//                                             // ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:serviceapp/feature/User/Home/widget/service_details.dart';
//
// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   String selectedCategory = "All";
//   String searchQuery = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF7FAFF),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔍 Search bar
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.search, color: Colors.grey),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: TextField(
//                               onChanged: (value) {
//                                 setState(() {
//                                   searchQuery = value;
//                                 });
//                               },
//                               decoration: const InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: "Search your needs here",
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Container(
//                     height: 50,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.teal,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.tune, color: Colors.white),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               // 🔥 Firestore data stream (using collectionGroup)
//               StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collectionGroup("job_posts") // ✅ fetch all job_posts across admins
//                     .orderBy('timestamp', descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Expanded(
//                       child: Center(child: CircularProgressIndicator()),
//                     );
//                   }
//
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Expanded(
//                       child: Center(child: Text("No jobs available")),
//                     );
//                   }
//
//                   final jobs = snapshot.data!.docs
//                       .map((doc) => doc.data() as Map<String, dynamic>)
//                       .toList();
//
//                   // Extract unique categories
//                   final categories = [
//                     "All",
//                     ...{
//                       for (var job in jobs) (job['category'] ?? '').toString()
//                     }..removeWhere((c) => c.isEmpty),
//                   ];
//
//                   // Filter jobs
//                   final filteredJobs = jobs.where((job) {
//                     final matchesCategory = selectedCategory == "All" ||
//                         (job["category"] ?? "") == selectedCategory;
//                     final matchesSearch = (job["post"] ?? "")
//                         .toString()
//                         .toLowerCase()
//                         .contains(searchQuery.toLowerCase());
//                     return matchesCategory && matchesSearch;
//                   }).toList();
//
//                   return Expanded(
//                     child: Column(
//                       children: [
//                         // 🏷 Categories filter
//                         SizedBox(
//                           height: 40,
//                           child: ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: categories.length,
//                             separatorBuilder: (_, __) =>
//                             const SizedBox(width: 8),
//                             itemBuilder: (context, index) {
//                               bool isSelected =
//                                   categories[index] == selectedCategory;
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedCategory = categories[index];
//                                   });
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 16),
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? Colors.teal
//                                         : Colors.transparent,
//                                     border: Border.all(
//                                         color: Colors.teal, width: 1.2),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       categories[index],
//                                       style: TextStyle(
//                                         color: isSelected
//                                             ? Colors.white
//                                             : Colors.teal,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//
//                         const SizedBox(height: 16),
//
//                         // 📋 Job cards
//                         Expanded(
//                           child: GridView.builder(
//                             itemCount: filteredJobs.length,
//                             gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               mainAxisSpacing: 12,
//                               crossAxisSpacing: 12,
//                               childAspectRatio: 0.8,
//                             ),
//                             itemBuilder: (context, index) {
//                               final job = filteredJobs[index];
//                               return GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           ServiceDetailsScreen(
//                                             service: job,
//                                           ),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(12),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.shade200,
//                                         spreadRadius: 2,
//                                         blurRadius: 6,
//                                       ),
//                                     ],
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: const BorderRadius.vertical(
//                                           top: Radius.circular(12),
//                                         ),
//                                         child: job["imageUrl"] != null
//                                             ? Image.network(
//                                           job["imageUrl"],
//                                           height: 160,
//                                           width: double.infinity,
//                                           fit: BoxFit.cover,
//                                         )
//                                             : Container(
//                                           height: 160,
//                                           color: Colors.grey[300],
//                                           child: Icon(
//                                             Icons.broken_image,
//                                             color: Colors.grey[600],
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               job["post"] ?? "",
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             Text(
//                                               "\$${job["price"] ?? ''}",
//                                               style: const TextStyle(
//                                                 color: Colors.teal,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             Text(
//                                               job["location"] ?? "",
//                                               style: TextStyle(
//                                                 color: Colors.grey[600],
//                                                 fontSize: 10,
//                                               ),
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serviceapp/feature/User/Home/widget/service_details.dart';

class SearchScreen extends StatefulWidget {
  final String initialCategory; // 👈 new

  const SearchScreen({super.key, this.initialCategory = "All"});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String selectedCategory; // 👈 updated
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory; // 👈 preselect category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 Search bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search your needs here",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 🔥 Firestore data stream
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("all_job_posts")
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Expanded(
                      child: Center(child: Text("No jobs available")),
                    );
                  }

                  final jobs = snapshot.data!.docs
                      .map((doc) => {
                    "id": doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  })
                      .toList();

                  // Extract unique categories
                  final categories = [
                    "All",
                    ...{
                      for (var job in jobs) (job['category'] ?? '').toString()
                    }..removeWhere((c) => c.isEmpty),
                  ];

                  // Filter jobs
                  final filteredJobs = jobs.where((job) {
                    final matchesCategory = selectedCategory == "All" ||
                        (job["category"] ?? "") == selectedCategory;
                    final matchesSearch = (job["post"] ?? "")
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                    return matchesCategory && matchesSearch;
                  }).toList();

                  return Expanded(
                    child: Column(
                      children: [
                        // 🏷 Categories filter
                        SizedBox(
                          height: 40,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              bool isSelected =
                                  categories[index] == selectedCategory;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = categories[index];
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.teal
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: Colors.teal, width: 1.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      categories[index],
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.teal,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 📋 Job cards
                        Expanded(
                          child: GridView.builder(
                            itemCount: filteredJobs.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.8,
                            ),
                            itemBuilder: (context, index) {
                              final job = filteredJobs[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ServiceDetailsScreen(service: job),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        spreadRadius: 2,
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: job["imageUrl"] != null
                                            ? Image.network(
                                          job["imageUrl"],
                                          height: 160,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                            : Container(
                                          height: 160,
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              job["post"] ?? "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "\$${job["price"] ?? ''}",
                                              style: const TextStyle(
                                                color: Colors.teal,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              job["location"] ?? "",
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 10,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
