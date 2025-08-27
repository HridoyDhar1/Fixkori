// import 'package:flutter/material.dart';
//
// class CompnayAboutSection extends StatelessWidget {
//   const CompnayAboutSection({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//
//       children: [
//
//         Text(
//           "About Palmcedar Cleaning",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "Praesent sit amet felis quis massa bibendum iaculis et vel est. "
//               "Suspendisse at lectus neque. Nunc eu mauris in diam ultricies "
//               "porttitor a ut ligula. Sed nec ligula quam. Phasellus lacinia quis "
//               "lorem non ultrices. Fusce molestie nulla et pulvinar cursus. "
//               "Interdum et malesuada fames ac ante ipsum primis in faucibus.\n\n"
//               "Praesent sit amet felis quis massa bibendum iaculis et vel est. "
//               "Suspendisse at lectus neque. Nunc eu mauris in diam ultricies "
//               "porttitor a ut ligula. Sed nec ligula quam. Phasellus lacinia quis "
//               "lorem non ultrices. Fusce molestie nulla et pulvinar cursus. "
//               "Interdum et malesuada fames ac ante ipsum primis in faucibus.",
//           style: TextStyle(fontSize: 14, color: Colors.grey[800]),
//         ),
//         const SizedBox(height: 16),
//
//         // Projects Section
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Employees",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             TextButton(
//               onPressed: () {},
//               child: Row(
//                 children: [
//                   Text("View all"),
//                   const SizedBox(width: 4),
//                   Icon(Icons.arrow_forward_ios, size: 14),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//
//         SizedBox(
//           height: 250,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: 3,
//             separatorBuilder: (context, index) => SizedBox(width: 8),
//             itemBuilder: (context, index) {
//               return Container(
//                 width: 150,
//
//                 margin: const EdgeInsets.only(left: 15),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.transparent,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
//                       child: Image.asset(
//                         "assets/images/vertical-shot-happy-dark-skinned-female-with-curly-hair.jpg", // Ensure this is the local asset path
//                         height: 190,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         "Palmcedar Shoiyle",
//                         style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text(
//                         "Experience 2 year",
//                         style: const TextStyle(fontSize: 12, color: Colors.red),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
