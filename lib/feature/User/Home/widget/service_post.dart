// import 'package:flutter/material.dart';
// import 'package:serviceapp/feature/User/Company/screen/company_profile.dart';
//
//
// class ServicePostsScreen extends StatelessWidget {
//   final String serviceName;
//   const ServicePostsScreen({super.key, required this.serviceName});
//
//
//   final List<Map<String, dynamic>> services = const [
//
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
// automaticallyImplyLeading: false
//         ,
//         title: Center(child: Text(serviceName,style: TextStyle(color: Colors.black87),)),
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.white,
//       ),
//       body: ListView.builder(
//         itemCount: services.length,
//         itemBuilder: (context, index) {
//           var service = services[index];
//           return GestureDetector(
//             onTap: (){
//
//
//               // Navigator.push(context, MaterialPageRoute(builder: (context)=>CompanyProfileDetails()));
//             },
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey.shade300, width: 1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Top Row: Image + Name + Verified + Rating
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         radius: 18,
//                         backgroundColor: Colors.grey.shade200,
//                         child: const Icon(Icons.store, color: Colors.grey),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     service["name"],
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 const Icon(Icons.verified,
//                                     size: 20, color: Colors.black),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 const Icon(Icons.star,
//                                     color: Colors.black87, size: 16),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   "${service["rating"]} (${service["reviews"]})",
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   const Divider(),
//                   // Location & Status
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on_outlined, size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         "${service["location"]} • ${service["status"]}",
//                         style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//
//                   // Price & Duration
//                   Row(
//                     children: [
//                       const Icon(Icons.attach_money, size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         "Starts @ ₦${service["price"]}/hr",
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       const SizedBox(width: 8),
//                       const Icon(Icons.access_time, size: 16),
//                       const SizedBox(width: 4),
//                       Text(service["duration"],
//                           style: const TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//
//                   // Jobs Completed
//                   Row(
//                     children: [
//                       const Icon(Icons.check_circle, size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         "${service["jobs"]} similar jobs completed near you",
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Admin/Auth/data/model/admin_model.dart';
import '../../Company/screen/company_profile.dart';


class ServicePostsScreen extends StatefulWidget {
  final String serviceName;
  const ServicePostsScreen({super.key, required this.serviceName});

  @override
  State<ServicePostsScreen> createState() => _ServicePostsScreenState();
}

class _ServicePostsScreenState extends State<ServicePostsScreen> {
  List<AdminModel> admins = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAdmins();
  }

  Future<void> fetchAdmins() async {
    CollectionReference adminsRef = FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection('admins_profile');

    QuerySnapshot snapshot = await adminsRef.get();
    admins = snapshot.docs
        .map((doc) => AdminModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (admins.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No Companies Found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Center(
          child: Text(widget.serviceName,
              style: const TextStyle(color: Colors.black87)),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: admins.length,
        itemBuilder: (context, index) {
          final admin = admins[index];

          return GestureDetector(
            onTap: () {
              // Navigate to detailed company profile
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompanyProfileDetails(admin: admin,))); // You can pass admin object if needed
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Image + Name + Verified + Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: admin.imageUrl != null
                            ? NetworkImage(admin.imageUrl!)
                            : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name & verified
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    admin.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.verified,
                                    size: 20, color: Colors.black),
                              ],
                            ),
                            // Rating placeholder
                            Row(
                              children: const [
                                Icon(Icons.star,
                                    color: Colors.black87, size: 16),
                                SizedBox(width: 4),
                                Text("4.7 (115 Reviews)",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),

                  // Location & Status
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${admin.location} • Available",
                          style:
                          TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Email & Number
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          admin.email,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        admin.number,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Work type & Employees
                  Row(
                    children: [
                      const Icon(Icons.work, size: 16),
                      const SizedBox(width: 4),
                      Text('${admin.workType} • ${admin.employees} Employees'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
