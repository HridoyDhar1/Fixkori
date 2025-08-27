// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';
//
// import '../../../../core/widgets/map_picker.dart';
// import '../../Auth/data/model/admin_model.dart';
//
// class JobPostScreen extends StatefulWidget {
//   const JobPostScreen({Key? key}) : super(key: key);
//
//   @override
//   State<JobPostScreen> createState() => _JobPostScreenState();
// }
//
// class _JobPostScreenState extends State<JobPostScreen> {
//   final TextEditingController _postController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();
//
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   // Location picker
//   Future<void> _openMapAndPickLocation() async {
//     LatLng? pickedLocation = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => MapPickerScreen()),
//     );
//
//     if (pickedLocation != null) {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         pickedLocation.latitude,
//         pickedLocation.longitude,
//       );
//
//       Placemark place = placemarks[0];
//       String address =
//           "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//
//       setState(() {
//         _locationController.text = address;
//       });
//     }
//   }
//
//   Future<String?> _uploadImage(File image) async {
//     try {
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       final ref = FirebaseStorage.instance.ref().child('job_images/$fileName');
//       await ref.putFile(image);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }
//
//   void _showAddJobDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         insetPadding: EdgeInsets.symmetric(horizontal: 20),
//         child: Container(
//           padding: EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Add Job Post",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 12),
//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: Container(
//                     height: 150,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade400),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: _selectedImage != null
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(
//                         _selectedImage!,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                         : Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.camera_alt,
//                             size: 40,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             "Tap to select photo",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 _buildTextField(_postController, "Post", Icons.work),
//                 SizedBox(height: 8),
//                 _buildTextField(
//                   _priceController,
//                   "Price",
//                   Icons.attach_money,
//                   keyboardType: TextInputType.number,
//                 ),
//                 SizedBox(height: 8),
//                 _buildTextField(
//                   _categoryController,
//                   "Category",
//                   Icons.category,
//                 ),
//                 SizedBox(height: 8),
//                 _buildTextField(
//                   _locationController,
//                   "Location",
//                   Icons.location_on,
//                   onTap: _openMapAndPickLocation,
//                   readOnly: true,
//                 ),
//                 SizedBox(height: 16),
//                 CustomButton(
//                   name: "Save",
//                   width: 200,
//                   height: 50,
//                   color: Colors.black87,
//                   onPressed: () async {
//                     // Get current user
//                     User? user = FirebaseAuth.instance.currentUser;
//
//                     if (user == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("You must be logged in to post a job"))
//                       );
//                       return;
//                     }
//
//                     // Fetch admin profile for current user
//                     final snapshot = await FirebaseFirestore.instance
//                         .collection("serviceApp")
//                         .doc("appData")
//                         .collection('admins_profile')
//                         .where('userId', isEqualTo: user.uid)
//                         .limit(1)
//                         .get();
//
//                     if (snapshot.docs.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("Admin profile not found"))
//                       );
//                       return;
//                     }
//
//                     final adminData = snapshot.docs.first.data();
//                     final admin = AdminModel.fromMap(adminData);
//
//                     // Upload image if selected
//                     String? imageUrl;
//                     if (_selectedImage != null) {
//                       imageUrl = await _uploadImage(_selectedImage!);
//                     }
//
//                     // Save job post with admin info
//                     await FirebaseFirestore.instance
//                         .collection("serviceApp")
//                         .doc("appData")
//                         .collection('job_posts')
//                         .add({
//                       "category": _categoryController.text,
//                       "post": _postController.text,
//                       "price": _priceController.text,
//                       "location": _locationController.text,
//                       "imageUrl": imageUrl,
//                       "timestamp": FieldValue.serverTimestamp(),
//                       // Admin info
//                       "userId": admin.userId,
//                       "userName": admin.name,
//                       "userEmail": admin.email,
//                       "userProfileImage": admin.imageUrl,
//                     });
//
//                     // Clear form
//                     _postController.clear();
//                     _priceController.clear();
//                     _locationController.clear();
//                     _categoryController.clear();
//                     _selectedImage = null;
//
//                     Navigator.pop(context);
//                   },
//
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       TextEditingController controller,
//       String hint,
//       IconData icon, {
//         TextInputType keyboardType = TextInputType.text,
//         VoidCallback? onTap,
//         bool readOnly = false,
//       }) {
//     return TextField(
//       onTap: onTap,
//       controller: controller,
//       keyboardType: keyboardType,
//       readOnly: readOnly,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.teal),
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }
//
//   // ✅ Job card with delete confirmation
//   Widget _buildJobCard(Map<String, dynamic> job, String jobId) {
//     return Container(
//       margin: EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             spreadRadius: 2,
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//                 child: job["imageUrl"] != null
//                     ? Image.network(
//                   job["imageUrl"],
//                   height: 170,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 )
//                     : Container(
//                   height: 160,
//                   color: Colors.grey[300],
//                   child: Icon(Icons.broken_image,
//                       color: Colors.grey[600]),
//                 ),
//               ),
//               Positioned(
//                 right: 6,
//                 top: 6,
//                 child: GestureDetector(
//                   onTap: () {
//                     _confirmDelete(jobId);
//                   },
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundColor: Colors.red.withOpacity(0.8),
//                     child: Icon(Icons.delete, color: Colors.white, size: 18),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 5),
//           Padding(
//             padding: const EdgeInsets.all(6.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   job["post"],
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   "\$${job["price"]}",
//                   style: TextStyle(
//                     color: Colors.teal,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Icon(Icons.location_on,
//                         size: 14, color: Colors.redAccent),
//                     SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         job["location"],
//                         style: TextStyle(fontSize: 10),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ✅ Confirmation dialog
//   void _confirmDelete(String jobId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Delete Job"),
//         content: Text("Are you sure you want to delete this job post?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () async {
//               await FirebaseFirestore.instance
//                   .collection("serviceApp")
//                   .doc("appData")
//                   .collection("job_posts")
//                   .doc(jobId)
//                   .delete();
//               Navigator.pop(context);
//             },
//             child: Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF7FAFF),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Center(child: Text("Job Posts")),
//         backgroundColor: Colors.transparent,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("serviceApp")
//             .doc("appData")
//             .collection('job_posts')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());
//
//           final jobs = snapshot.data!.docs;
//           if (jobs.isEmpty) return Center(child: Text("No job posts yet"));
//
//           return GridView.builder(
//             itemCount: jobs.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 8,
//               mainAxisSpacing: 8,
//               childAspectRatio: 0.75,
//             ),
//             itemBuilder: (context, index) {
//               final jobData = jobs[index].data() as Map<String, dynamic>;
//               final jobId = jobs[index].id;
//               return _buildJobCard(jobData, jobId);
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddJobDialog,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';
//
// import '../../../../core/widgets/map_picker.dart';
// import '../../Auth/data/model/admin_model.dart';
//
// class JobPostScreen extends StatefulWidget {
//   const JobPostScreen({Key? key}) : super(key: key);
//
//   @override
//   State<JobPostScreen> createState() => _JobPostScreenState();
// }
//
// class _JobPostScreenState extends State<JobPostScreen> {
//   final TextEditingController _postController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();
//
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Get current admin ID
//   String getCurrentAdminId() {
//     return _auth.currentUser?.uid ?? '';
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   // Location picker
//   Future<void> _openMapAndPickLocation() async {
//     LatLng? pickedLocation = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => MapPickerScreen()),
//     );
//
//     if (pickedLocation != null) {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         pickedLocation.latitude,
//         pickedLocation.longitude,
//       );
//
//       Placemark place = placemarks[0];
//       String address =
//           "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//
//       setState(() {
//         _locationController.text = address;
//       });
//     }
//   }
//
//   Future<String?> _uploadImage(File image) async {
//     try {
//       final adminId = getCurrentAdminId();
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       final ref = FirebaseStorage.instance.ref().child('job_images/$adminId/$fileName');
//       await ref.putFile(image);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }
//
//   void _showAddJobDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         insetPadding: EdgeInsets.symmetric(horizontal: 20),
//         child: Container(
//           padding: EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Add Job Post",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 12),
//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: Container(
//                     height: 150,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade400),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: _selectedImage != null
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(
//                         _selectedImage!,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                         : Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.camera_alt,
//                             size: 40,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             "Tap to select photo",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 _buildTextField(_postController, "Post", Icons.work),
//                 SizedBox(height: 8),
//                 _buildTextField(
//                   _priceController,
//                   "Price",
//                   Icons.attach_money,
//                   keyboardType: TextInputType.number,
//                 ),
//                 SizedBox(height: 8),
//                 _buildTextField(
//                   _categoryController,
//                   "Category",
//                   Icons.category,
//                 ),
//                 SizedBox(height: 8),
//                 _buildTextField(
//                   _locationController,
//                   "Location",
//                   Icons.location_on,
//                   onTap: _openMapAndPickLocation,
//                   readOnly: true,
//                 ),
//                 SizedBox(height: 16),
//                 CustomButton(
//                   name: "Save",
//                   width: 200,
//                   height: 50,
//                   color: Colors.black87,
//                   onPressed: () async {
//                     // Get current user
//                     final adminId = getCurrentAdminId();
//                     if (adminId.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("You must be logged in to post a job"))
//                       );
//                       return;
//                     }
//
//                     // Fetch admin profile for current user
//                     final snapshot = await FirebaseFirestore.instance
//                         .collection("serviceApp")
//                         .doc("appData")
//                         .collection('admins_profile')
//                         .where('userId', isEqualTo: adminId)
//                         .limit(1)
//                         .get();
//
//                     if (snapshot.docs.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("Admin profile not found"))
//                       );
//                       return;
//                     }
//
//                     final adminData = snapshot.docs.first.data();
//                     final admin = AdminModel.fromMap(adminData);
//
//                     // Upload image if selected
//                     String? imageUrl;
//                     if (_selectedImage != null) {
//                       imageUrl = await _uploadImage(_selectedImage!);
//                     }
//
//                     // Save job post with admin info - under the admin's collection
//                     await FirebaseFirestore.instance
//                         .collection("serviceApp")
//                         .doc("appData")
//                         .collection("admins")  // Add admins collection
//                         .doc(adminId)          // Document for this specific admin
//                         .collection('job_posts')  // Job posts for this admin
//                         .add({
//                       "category": _categoryController.text,
//                       "post": _postController.text,
//                       "price": _priceController.text,
//                       "location": _locationController.text,
//                       "imageUrl": imageUrl,
//                       "timestamp": FieldValue.serverTimestamp(),
//                       // Admin info
//                       "userId": admin.userId,
//                       "userName": admin.name,
//                       "userEmail": admin.email,
//                       "userProfileImage": admin.imageUrl,
//                     });
//
//                     // Clear form
//                     _postController.clear();
//                     _priceController.clear();
//                     _locationController.clear();
//                     _categoryController.clear();
//                     _selectedImage = null;
//
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       TextEditingController controller,
//       String hint,
//       IconData icon, {
//         TextInputType keyboardType = TextInputType.text,
//         VoidCallback? onTap,
//         bool readOnly = false,
//       }) {
//     return TextField(
//       onTap: onTap,
//       controller: controller,
//       keyboardType: keyboardType,
//       readOnly: readOnly,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.teal),
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }
//
//   // ✅ Job card with delete confirmation
//   Widget _buildJobCard(Map<String, dynamic> job, String jobId) {
//     return Container(
//       margin: EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             spreadRadius: 2,
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//                 child: job["imageUrl"] != null
//                     ? Image.network(
//                   job["imageUrl"],
//                   height: 170,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 )
//                     : Container(
//                   height: 160,
//                   color: Colors.grey[300],
//                   child: Icon(Icons.broken_image,
//                       color: Colors.grey[600]),
//                 ),
//               ),
//               Positioned(
//                 right: 6,
//                 top: 6,
//                 child: GestureDetector(
//                   onTap: () {
//                     _confirmDelete(jobId);
//                   },
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundColor: Colors.red.withOpacity(0.8),
//                     child: Icon(Icons.delete, color: Colors.white, size: 18),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 5),
//           Padding(
//             padding: const EdgeInsets.all(6.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   job["post"],
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   "\$${job["price"]}",
//                   style: TextStyle(
//                     color: Colors.teal,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Icon(Icons.location_on,
//                         size: 14, color: Colors.redAccent),
//                     SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         job["location"],
//                         style: TextStyle(fontSize: 10),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ✅ Confirmation dialog
//   void _confirmDelete(String jobId) async {
//     final adminId = getCurrentAdminId();
//     if (adminId.isEmpty) return;
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Delete Job"),
//         content: Text("Are you sure you want to delete this job post?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () async {
//               try {
//                 await FirebaseFirestore.instance
//                     .collection("serviceApp")
//                     .doc("appData")
//                     .collection("admins")
//                     .doc(adminId)
//                     .collection("job_posts")
//                     .doc(jobId)
//                     .delete();
//                 Navigator.pop(context);
//               } catch (e) {
//                 print("Error deleting job: $e");
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Error deleting job: $e")),
//                 );
//               }
//             },
//             child: Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final adminId = getCurrentAdminId();
//
//     return Scaffold(
//       backgroundColor: Color(0xffF7FAFF),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Center(child: Text("Job Posts")),
//         backgroundColor: Colors.transparent,
//       ),
//       body: adminId.isEmpty
//           ? Center(child: Text("Please log in to view job posts"))
//           : StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("serviceApp")
//             .doc("appData")
//             .collection("admins")
//             .doc(adminId)
//             .collection('job_posts')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No job posts yet"));
//           }
//
//           final jobs = snapshot.data!.docs;
//           return GridView.builder(
//             itemCount: jobs.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 8,
//               mainAxisSpacing: 8,
//               childAspectRatio: 0.75,
//             ),
//             itemBuilder: (context, index) {
//               final jobData = jobs[index].data() as Map<String, dynamic>;
//               final jobId = jobs[index].id;
//               return _buildJobCard(jobData, jobId);
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddJobDialog,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';

import '../../../../core/widgets/map_picker.dart';
import '../../Auth/data/model/admin_model.dart';

class JobPostScreen extends StatefulWidget {
  const JobPostScreen({Key? key}) : super(key: key);

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getCurrentAdminId() => _auth.currentUser?.uid ?? '';

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _openMapAndPickLocation() async {
    LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPickerScreen()),
    );

    if (pickedLocation != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pickedLocation.latitude,
        pickedLocation.longitude,
      );

      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      setState(() {
        _locationController.text = address;
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final adminId = getCurrentAdminId();
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child(
        'job_images/$adminId/$fileName',
      );
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _showAddJobDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add Job Post",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Tap to select photo",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(_postController, "Post", Icons.work),
                const SizedBox(height: 8),
                _buildTextField(
                  _priceController,
                  "Price",
                  Icons.attach_money,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  _categoryController,
                  "Category",
                  Icons.category,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  _locationController,
                  "Location",
                  Icons.location_on,
                  onTap: _openMapAndPickLocation,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  name: "Save",
                  width: 200,
                  height: 50,
                  color: Colors.black87,
                  onPressed: _saveJobPost,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
        VoidCallback? onTap,
        bool readOnly = false,
      }) {
    return TextField(
      onTap: onTap,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _saveJobPost() async {
    final adminId = getCurrentAdminId();
    if (adminId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in to post a job")),
      );
      return;
    }

    // Fetch admin profile
    final snapshot = await FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection('admins_profile')
        .where('userId', isEqualTo: adminId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Admin profile not found")),
      );
      return;
    }

    final adminData = snapshot.docs.first.data();
    final admin = AdminModel.fromMap(adminData);

    // Upload image
    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
    }

    final jobData = {
      "category": _categoryController.text,
      "post": _postController.text,
      "price": _priceController.text,
      "location": _locationController.text,
      "imageUrl": imageUrl,
      "timestamp": FieldValue.serverTimestamp(),
      "userId": admin.userId,
      "userName": admin.name,
      "userEmail": admin.email,
      "userProfileImage": admin.imageUrl,
    };

    // Save in admin’s subcollection
    final adminRef = FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("admins")
        .doc(adminId)
        .collection("job_posts")
        .doc();

    await adminRef.set(jobData);

    // Also save in global collection with adminId
    await FirebaseFirestore.instance
        .collection("all_job_posts")
        .doc(adminRef.id)
        .set({
      ...jobData,
      "adminId": adminId,
    });

    // Clear fields
    _postController.clear();
    _priceController.clear();
    _locationController.clear();
    _categoryController.clear();
    _selectedImage = null;

    Navigator.pop(context);
  }

  Widget _buildJobCard(Map<String, dynamic> job, String jobId) {
    return Container(
      margin: const EdgeInsets.all(6),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: job["imageUrl"] != null
                    ? Image.network(
                  job["imageUrl"],
                  height: 170,
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
              Positioned(
                right: 6,
                top: 6,
                child: GestureDetector(
                  onTap: () => _confirmDelete(jobId),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.red.withOpacity(0.8),
                    child: const Icon(Icons.delete, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job["post"],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  "\$${job["price"]}",
                  style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        job["location"],
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String jobId) async {
    final adminId = getCurrentAdminId();
    if (adminId.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Job"),
        content: const Text("Are you sure you want to delete this job post?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection("serviceApp")
                    .doc("appData")
                    .collection("admins")
                    .doc(adminId)
                    .collection("job_posts")
                    .doc(jobId)
                    .delete();

                await FirebaseFirestore.instance
                    .collection("all_job_posts")
                    .doc(jobId)
                    .delete();

                Navigator.pop(context);
              } catch (e) {
                print("Error deleting job: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error deleting job: $e")),
                );
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminId = getCurrentAdminId();

    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Job Posts")),
        backgroundColor: Colors.transparent,
      ),
      body: adminId.isEmpty
          ? const Center(child: Text("Please log in to view job posts"))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("serviceApp")
            .doc("appData")
            .collection("admins")
            .doc(adminId)
            .collection('job_posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No job posts yet"));
          }

          final jobs = snapshot.data!.docs;
          return GridView.builder(
            itemCount: jobs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final jobData = jobs[index].data() as Map<String, dynamic>;
              final jobId = jobs[index].id;
              return _buildJobCard(jobData, jobId);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddJobDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
