// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';
// import 'package:serviceapp/core/widgets/text_field.dart';
//
// class AddPersonDialog extends StatelessWidget {
//   final Function(Map<String, dynamic>) onSave;
//
//   const AddPersonDialog({Key? key, required this.onSave}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final nameController = TextEditingController();
//     final roleController = TextEditingController();
//     final numberController = TextEditingController();
//     final idController=TextEditingController();
//     String? selectedExperience;
//
//     String? selectedCountry;
//     File? pickedImage;
//     final picker = ImagePicker();
//
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.9,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: StatefulBuilder(
//             builder: (context, setStateDialog) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "Add Person",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 15),
//                   GestureDetector(
//                     onTap: () async {
//                       final XFile? image =
//                       await picker.pickImage(source: ImageSource.gallery);
//                       if (image != null) {
//                         setStateDialog(() {
//                           pickedImage = File(image.path);
//                         });
//                       }
//                     },
//                     child: CircleAvatar(
//                       radius: 45,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage:
//                       pickedImage != null ? FileImage(pickedImage!) : null,
//                       child: pickedImage == null
//                           ? const Icon(Icons.camera_alt,
//                           size: 28, color: Colors.white)
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   CustomTextField(
//                       controller: nameController,
//                       label: "Name",
//                       icon: Icons.person),
//                   const SizedBox(height: 10),
//                   CustomTextField(
//                       controller: idController,
//                       label: "ID",
//                       icon: Icons.card_membership),
//                   const SizedBox(height: 10),
//                   CustomTextField(
//                       controller: roleController,
//                       label: "Work Type",
//                       icon: Icons.work),
//
//
//                   const SizedBox(height: 10),
//                   CustomTextField(
//                       controller: numberController,
//                       label: "Number",
//                       icon: Icons.phone,
//                       keyboardType: TextInputType.phone),
//
//                   const SizedBox(height: 10),
//                   CustomDropdown(
//                     value: selectedExperience,
//                     label: "Experience",
//                     icon: Icons.timeline,
//                     items: ["1 year", "2 years", "3 years", "5+ years"],
//                     onChanged: (value) {
//                       setStateDialog(() => selectedExperience = value);
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   CustomDropdown(
//                     value: selectedCountry,
//                     label: "Country",
//                     icon: Icons.public,
//                     items: ["Bangladesh", "India", "USA", "UK"],
//                     onChanged: (value) {
//                       setStateDialog(() => selectedCountry = value);
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   CustomButton(
//                     name: "Save",
//                     width: 200,
//                     height: 50,
//                     color: Colors.black87,
//                     onPressed: () {
//                       if (nameController.text.isNotEmpty &&
//                           roleController.text.isNotEmpty &&
//
//                           numberController.text.isNotEmpty &&
//                           selectedCountry != null) {
//                         onSave({
//                           "name": nameController.text,
//                           "experience": selectedExperience,
//                           "workType": roleController,
//                           "number": numberController.text,
//                           "country": selectedCountry,
//                           "image": pickedImage
//                         });
//                         Navigator.pop(context);
//                       }
//                     },
//                   )
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
