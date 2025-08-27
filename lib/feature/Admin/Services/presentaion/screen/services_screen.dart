// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../../../../../core/widgets/custom_elevatedbutton.dart';
// import '../../../../../core/widgets/text_field.dart';
// import '../widget/servent_profile.dart';
//
// class ServiceDetailScreen extends StatefulWidget {
//   final String serviceTitle;
//
//   const ServiceDetailScreen({required this.serviceTitle, Key? key})
//       : super(key: key);
//
//   @override
//   _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
// }
//
// class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
//   final List<Map<String, dynamic>> persons = [];
//   final picker = ImagePicker();
//   late String adminUid;
//
//   @override
//   void initState() {
//     super.initState();
//     final currentAdmin = FirebaseAuth.instance.currentUser;
//     if (currentAdmin != null) {
//       adminUid = currentAdmin.uid;
//       loadPersons();
//     }
//   }
//
//   /// Load data from Firestore (for current admin only)
//   void loadPersons() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection("serviceApp")
//         .doc("admins")
//         .collection(adminUid)
//         .doc("services")
//         .collection(widget.serviceTitle)
//         .get();
//
//     setState(() {
//       persons.clear();
//       for (var doc in snapshot.docs) {
//         persons.add(doc.data());
//       }
//     });
//   }
//
//   /// Upload image to Firebase Storage
//   Future<String?> uploadImage(File image, String id) async {
//     try {
//       final ref =
//       FirebaseStorage.instance.ref().child('service_images/$adminUid/$id.jpg');
//       await ref.putFile(image);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       return null;
//     }
//   }
//
//   /// Show add person dialog
//   void _showServiceDialog() {
//     File? dialogPickedImage;
//
//     final nameCtrl = TextEditingController();
//     final roleCtrl = TextEditingController();
//     final numberCtrl = TextEditingController();
//     final idCtrl = TextEditingController();
//     String? experience;
//     String? country;
//
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//         child: StatefulBuilder(
//           builder: (context, setStateDialog) {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "Add Person",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 15),
//                   GestureDetector(
//                     onTap: () async {
//                       final XFile? image = await picker.pickImage(
//                         source: ImageSource.gallery,
//                       );
//                       if (image != null) {
//                         setStateDialog(() {
//                           dialogPickedImage = File(image.path);
//                         });
//                       }
//                     },
//                     child: CircleAvatar(
//                       radius: 45,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage: dialogPickedImage != null
//                           ? FileImage(dialogPickedImage!)
//                           : null,
//                       child: dialogPickedImage == null
//                           ? const Icon(
//                         Icons.camera_alt,
//                         size: 28,
//                         color: Colors.white,
//                       )
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   CustomTextField(
//                     controller: nameCtrl,
//                     label: "Name",
//                     icon: Icons.person,
//                   ),
//                   const SizedBox(height: 10),
//                   CustomTextField(
//                     controller: idCtrl,
//                     label: "ID",
//                     icon: Icons.card_membership,
//                   ),
//                   const SizedBox(height: 10),
//                   CustomTextField(
//                     controller: roleCtrl,
//                     label: "Work Type",
//                     icon: Icons.work,
//                   ),
//                   const SizedBox(height: 10),
//                   CustomTextField(
//                     controller: numberCtrl,
//                     label: "Number",
//                     icon: Icons.phone,
//                     keyboardType: TextInputType.phone,
//                   ),
//                   const SizedBox(height: 10),
//                   CustomDropdown(
//                     value: experience,
//                     label: "Experience",
//                     icon: Icons.timeline,
//                     items: ["1 year", "2 years", "3 years", "5+ years"],
//                     onChanged: (value) {
//                       setStateDialog(() => experience = value);
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   CustomDropdown(
//                     value: country,
//                     label: "Country",
//                     icon: Icons.public,
//                     items: ["Bangladesh", "India", "USA", "UK"],
//                     onChanged: (value) {
//                       setStateDialog(() => country = value);
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   CustomButton(
//                     name: "Save",
//                     width: 200,
//                     height: 50,
//                     color: Colors.black87,
//                     onPressed: () async {
//                       if (nameCtrl.text.isNotEmpty &&
//                           roleCtrl.text.isNotEmpty &&
//                           numberCtrl.text.isNotEmpty &&
//                           country != null) {
//                         String? imageUrl;
//                         if (dialogPickedImage != null) {
//                           imageUrl =
//                           await uploadImage(dialogPickedImage!, idCtrl.text);
//                         }
//
//                         final personData = {
//                           "name": nameCtrl.text,
//                           "experience": experience,
//                           "workType": roleCtrl.text,
//                           "number": numberCtrl.text,
//                           "country": country,
//                           "id": idCtrl.text,
//                           "imageUrl": imageUrl,
//                         };
//
//                         // Save to Firestore (under current admin)
//                         await FirebaseFirestore.instance
//                             .collection("serviceApp")
//                             .doc("admins")
//                             .collection(adminUid)
//                             .doc("services")
//                             .collection(widget.serviceTitle)
//                             .doc(idCtrl.text)
//                             .set(personData);
//
//                         setState(() {
//                           persons.add(personData);
//                         });
//
//                         Navigator.pop(context);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   /// Delete person (only current admin’s data)
//   void deletePerson(String id) async {
//     await FirebaseFirestore.instance
//         .collection("serviceApp")
//         .doc("admins")
//         .collection(adminUid)
//         .doc("services")
//         .collection(widget.serviceTitle)
//         .doc(id)
//         .delete();
//
//     setState(() {
//       persons.removeWhere((element) => element['id'] == id);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final total = persons.length;
//     return Scaffold(
//       backgroundColor: const Color(0xffF7FAFF),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: Text("${widget.serviceTitle} ($total)"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child:persons.isEmpty
//             ? const Center(child: Text('No persons added yet.'))
//             : ListView.builder(
//           itemCount: total,
//           itemBuilder: (context, index) {
//             final person = persons[index];
//             final number = index + 1;
//             return Card(
//               color: Colors.white,
//               child: ListTile(
//                 leading: person['imageUrl'] != null
//                     ? CircleAvatar(
//                   backgroundImage: NetworkImage(person['imageUrl']),
//                 )
//                     : null,
//                 title: Text("$number. ${person['name'] ?? 'Unnamed'}"),
//                 subtitle: Text(
//                   "${person['workType'] ?? ''}, ${person['experience'] ?? ''}",
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () {
//                     deletePerson(person['id']);
//                   },
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           PersonDetailsPage(person: person),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFFFFEB99),
//         onPressed: _showServiceDialog,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/widgets/custom_elevatedbutton.dart';
import '../../../../../core/widgets/text_field.dart';
import '../widget/servent_profile.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceTitle;

  const ServiceDetailScreen({required this.serviceTitle, Key? key})
      : super(key: key);

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final List<Map<String, dynamic>> persons = [];
  final picker = ImagePicker();
  late String adminUid;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final currentAdmin = FirebaseAuth.instance.currentUser;
    if (currentAdmin != null) {
      adminUid = currentAdmin.uid;
      loadPersons();
    } else {
      isLoading = false;
    }
  }

  /// Load data from Firestore (for current admin only)
  void loadPersons() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("admins")
          .collection(adminUid)
          .doc("services")
          .collection(widget.serviceTitle)
          .get();

      setState(() {
        persons.clear();
        for (var doc in snapshot.docs) {
          persons.add({...doc.data(), 'id': doc.id});
        }
        isLoading = false;
      });
    } catch (e) {
      print("Error loading persons: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Upload image to Firebase Storage
  Future<String?> uploadImage(File image, String id) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('service_images/$adminUid/${widget.serviceTitle}/$id.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  /// Show add person dialog
  void _showServiceDialog() {
    File? dialogPickedImage;

    final nameCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final numberCtrl = TextEditingController();
    final idCtrl = TextEditingController();
    String? experience;
    String? country;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: StatefulBuilder(
          builder: (context, setStateDialog) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Person",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        setStateDialog(() {
                          dialogPickedImage = File(image.path);
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: dialogPickedImage != null
                          ? FileImage(dialogPickedImage!)
                          : null,
                      child: dialogPickedImage == null
                          ? const Icon(
                        Icons.camera_alt,
                        size: 28,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: nameCtrl,
                    label: "Name",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: idCtrl,
                    label: "ID",
                    icon: Icons.card_membership,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: roleCtrl,
                    label: "Work Type",
                    icon: Icons.work,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: numberCtrl,
                    label: "Number",
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  CustomDropdown(
                    value: experience,
                    label: "Experience",
                    icon: Icons.timeline,
                    items: ["1 year", "2 years", "3 years", "5+ years"],
                    onChanged: (value) {
                      setStateDialog(() => experience = value);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomDropdown(
                    value: country,
                    label: "Country",
                    icon: Icons.public,
                    items: ["Bangladesh", "India", "USA", "UK"],
                    onChanged: (value) {
                      setStateDialog(() => country = value);
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    name: "Save",
                    width: 200,
                    height: 50,
                    color: Colors.black87,
                    onPressed: () async {
                      if (nameCtrl.text.isNotEmpty &&
                          roleCtrl.text.isNotEmpty &&
                          numberCtrl.text.isNotEmpty &&
                          country != null &&
                          idCtrl.text.isNotEmpty) {

                        String? imageUrl;
                        if (dialogPickedImage != null) {
                          imageUrl = await uploadImage(dialogPickedImage!, idCtrl.text);
                        }

                        final personData = {
                          "name": nameCtrl.text,
                          "experience": experience,
                          "workType": roleCtrl.text,
                          "number": numberCtrl.text,
                          "country": country,
                          "imageUrl": imageUrl,
                          "createdAt": FieldValue.serverTimestamp(),
                        };

                        try {
                          // Save to Firestore with your preferred structure
                          await FirebaseFirestore.instance
                              .collection("serviceApp")
                              .doc("admins")
                              .collection(adminUid)
                              .doc("services")
                              .collection(widget.serviceTitle)
                              .doc(idCtrl.text)
                              .set(personData);

                          setState(() {
                            persons.add({...personData, 'id': idCtrl.text});
                          });

                          Navigator.pop(context);
                        } catch (e) {
                          print("Error saving person: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to save: $e")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill all fields")),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Delete person (only current admin's data)
  void deletePerson(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("admins")
          .collection(adminUid)
          .doc("services")
          .collection(widget.serviceTitle)
          .doc(id)
          .delete();

      // Also delete the associated image from storage
      try {
        await FirebaseStorage.instance
            .ref()
            .child('service_images/$adminUid/${widget.serviceTitle}/$id.jpg')
            .delete();
      } catch (e) {
        print("Error deleting image (might not exist): $e");
      }

      setState(() {
        persons.removeWhere((element) => element['id'] == id);
      });
    } catch (e) {
      print("Error deleting person: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = persons.length;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("${widget.serviceTitle} ($total)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: persons.isEmpty
            ? const Center(child: Text('No persons added yet.'))
            : ListView.builder(
          itemCount: total,
          itemBuilder: (context, index) {
            final person = persons[index];
            final number = index + 1;
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: person['imageUrl'] != null
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(person['imageUrl']),
                )
                    : const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text("$number. ${person['name'] ?? 'Unnamed'}"),
                subtitle: Text(
                  "${person['workType'] ?? ''}, ${person['experience'] ?? ''}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    deletePerson(person['id']);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PersonDetailsPage(person: person),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFEB99),
        onPressed: _showServiceDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Custom Dropdown Widget
class CustomDropdown extends StatelessWidget {
  final String? value;
  final String label;
  final IconData icon;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}