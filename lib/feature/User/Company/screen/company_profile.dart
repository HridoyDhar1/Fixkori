// //
// //
// // import 'package:flutter/material.dart';
// //
// // import '../../../Admin/Auth/data/model/admin_model.dart';
// //
// //
// //
// // class CompanyProfileDetails extends StatelessWidget {
// //   final AdminModel admin;
// //
// //   const CompanyProfileDetails({super.key, required this.admin});
// //
// //   static const String routeName = '/company_profile';
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const SizedBox(height: 50),
// //
// //             /// Profile Header
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Name + Verified
// //                       Row(
// //                         children: [
// //                           Text(
// //                             admin.name,
// //                             style: const TextStyle(
// //                               fontSize: 22,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 10),
// //                           const Icon(Icons.verified,
// //                               size: 18, color: Colors.blue),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 6),
// //
// //                       // Rating placeholder
// //                       Row(
// //                         children: const [
// //                           Icon(Icons.star, size: 16, color: Colors.amber),
// //                           SizedBox(width: 4),
// //                           Text("4.7", style: TextStyle(fontSize: 14)),
// //                           SizedBox(width: 4),
// //                           Text(
// //                             "(115 Reviews)",
// //                             style: TextStyle(fontSize: 14, color: Colors.grey),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 6),
// //
// //                       // Location
// //                       Row(
// //                         children: [
// //                           const Icon(Icons.location_on_outlined, size: 16),
// //                           const SizedBox(width: 4),
// //                           Flexible(
// //                             child: Text(
// //                               admin.location,
// //                               style: const TextStyle(fontSize: 14),
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //                           const Text(
// //                             " • Available",
// //                             style: TextStyle(fontSize: 14, color: Colors.grey),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 6),
// //
// //                       // Email
// //                       Row(
// //                         children: [
// //                           const Icon(Icons.email, size: 16),
// //                           const SizedBox(width: 4),
// //                           Flexible(
// //                             child: Text(
// //                               admin.email,
// //                               style: const TextStyle(fontSize: 14),
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 6),
// //
// //                       // Email
// //                       Row(
// //                         children: [
// //                           const Icon(Icons.phone, size: 16),
// //                           const SizedBox(width: 4),
// //                           Flexible(
// //                             child: Text(
// //                               admin.number,
// //                               style: const TextStyle(fontSize: 14),
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 6),
// //
// //                       // Work type & employees
// //                       Row(
// //                         children: [
// //                           const Icon(Icons.work, size: 16),
// //                           const SizedBox(width: 4),
// //                           Text('${admin.workType} • ${admin.employees} Employees'),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 // Profile Image
// //                 CircleAvatar(
// //                   radius: 50,
// //                   backgroundImage: admin.imageUrl != null
// //                       ? NetworkImage(admin.imageUrl!)
// //                       : const AssetImage('assets/default_avatar.png')
// //                   as ImageProvider,
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 16),
// //
// //             /// Buttons
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.black,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       padding: const EdgeInsets.symmetric(vertical: 14),
// //                     ),
// //                     onPressed: () {
// //
// //                     },
// //
// //                     child: const Text(
// //                       "Message",
// //                       style: TextStyle(color: Colors.white),
// //                     ),
// //                   ),
// //                 ),
// //
// //                 const SizedBox(width: 8),
// //                 Expanded(
// //                   child: OutlinedButton(
// //                     style: OutlinedButton.styleFrom(
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       padding: const EdgeInsets.symmetric(vertical: 14),
// //                     ),
// //                     onPressed: () {
// //
// //                     },
// //                     child: const Text("Call"),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 30),
// //
// //             /// Company Info
// //             const Text(
// //               "Company Info",
// //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //             ),
// //             const SizedBox(height: 20),
// //
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   "About ${admin.name}",
// //                   style: const TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.black,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   "📍 Location: ${admin.location}\n"
// //                       "💼 Work Type: ${admin.workType}\n"
// //                       "👥 Employees: ${admin.employees}\n"
// //                       "📧 Email: ${admin.email}\n"
// //                       "🌍 Country: ${admin.country}\n",
// //
// //
// //
// //                   style: TextStyle(fontSize: 14, color: Colors.grey[800]),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import '../../../Admin/Auth/data/model/admin_model.dart';
//
// class CompanyProfileDetails extends StatelessWidget {
//   final AdminModel admin;
//
//   const CompanyProfileDetails({super.key, required this.admin});
//
//   static const String routeName = '/company_profile';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 50),
//
//             /// Profile Header
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Name + Verified
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               admin.name,
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           const Icon(Icons.verified, size: 18, color: Colors.blue),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//
//                       // Rating placeholder
//                       Row(
//                         children: const [
//                           Icon(Icons.star, size: 16, color: Colors.amber),
//                           SizedBox(width: 4),
//                           Text("4.7", style: TextStyle(fontSize: 14)),
//                           SizedBox(width: 4),
//                           Text(
//                             "(115 Reviews)",
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//
//                       // Location
//                       Row(
//                         children: [
//                           const Icon(Icons.location_on_outlined, size: 16),
//                           const SizedBox(width: 4),
//                           Flexible(
//                             child: Text(
//                               admin.location,
//                               style: const TextStyle(fontSize: 14),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const Text(
//                             " • Available",
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//
//                       // Email
//                       Row(
//                         children: [
//                           const Icon(Icons.email, size: 16),
//                           const SizedBox(width: 4),
//                           Flexible(
//                             child: Text(
//                               admin.email,
//                               style: const TextStyle(fontSize: 14),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//
//                       // Phone
//                       Row(
//                         children: [
//                           const Icon(Icons.phone, size: 16),
//                           const SizedBox(width: 4),
//                           Flexible(
//                             child: Text(
//                               admin.number,
//                               style: const TextStyle(fontSize: 14),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//
//                       // Work type & employees
//                       Row(
//                         children: [
//                           const Icon(Icons.work, size: 16),
//                           const SizedBox(width: 4),
//                           Text('${admin.workType} • ${admin.employees} Employees'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Profile Image
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.grey[200],
//                   backgroundImage: admin.imageUrl != null && admin.imageUrl!.isNotEmpty
//                       ? NetworkImage(admin.imageUrl!)
//                       : const AssetImage('assets/images/default_avatar.png')
//                   as ImageProvider,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             /// Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                     onPressed: () {
//                       // TODO: Implement messaging functionality
//                     },
//                     child: const Text(
//                       "Message",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                     onPressed: () {
//                       // TODO: Implement calling functionality
//                     },
//                     child: const Text("Call"),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//
//             /// Company Info
//             const Text(
//               "Company Info",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "About ${admin.name}",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "📍 Location: ${admin.location}\n"
//                       "💼 Work Type: ${admin.workType}\n"
//                       "👥 Employees: ${admin.employees}\n"
//                       "📧 Email: ${admin.email}\n"
//                       "🌍 Country: ${admin.country}\n",
//                   style: TextStyle(fontSize: 14, color: Colors.grey[800]),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../../Admin/Auth/data/model/admin_model.dart';

class CompanyProfileDetails extends StatelessWidget {
  final AdminModel admin;

  const CompanyProfileDetails({super.key, required this.admin});

  static const String routeName = '/company_profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            /// Profile Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Verified
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              admin.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.verified, size: 18, color: Colors.blue),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Rating placeholder
                      Row(
                        children: const [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text("4.7", style: TextStyle(fontSize: 14)),
                          SizedBox(width: 4),
                          Text(
                            "(115 Reviews)",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Location
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              admin.location,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Text(
                            " • Available",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Email
                      Row(
                        children: [
                          const Icon(Icons.email, size: 16),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              admin.email,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Phone
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              admin.number,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Work type & employees
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

                /// Profile Image
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: admin.imageUrl != null && admin.imageUrl!.isNotEmpty
                        ? FadeInImage.assetNetwork(
                      placeholder: "assets/images/default_avatar.png",
                      image: admin.imageUrl!,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )
                        : Image.asset(
                      "assets/images/default_avatar.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // TODO: Implement messaging functionality
                    },
                    child: const Text(
                      "Message",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // TODO: Implement calling functionality
                    },
                    child: const Text("Call"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            /// Company Info
            const Text(
              "Company Info",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About ${admin.name}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "📍 Location: ${admin.location}\n"
                      "💼 Work Type: ${admin.workType}\n"
                      "👥 Employees: ${admin.employees}\n"
                      "📧 Email: ${admin.email}\n"
                      "🌍 Country: ${admin.country}\n",
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
