import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({Key? key}) : super(key: key);

  static const String name = '/edit_userprofile';

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File? _profileImage;
  bool _isLoading = false;

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _workTypeController = TextEditingController();
  final _countryController = TextEditingController();
  final _employeesController = TextEditingController();

  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("serviceApp")
          .doc("appData")
          .collection("users")
          .doc(uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        _nameController.text = data["name"] ?? "";
        _emailController.text = data["email"] ?? "";
        _phoneController.text = data["number"] ?? "";
        _addressController.text = data["location"] ?? "";
        _workTypeController.text = data["workType"] ?? "";
        _countryController.text = data["country"] ?? "";
        _employeesController.text = data["employees"] ?? "";
        _currentImageUrl = data["imageUrl"];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data");
    }

    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  Future<String?> _uploadImage() async {
    if (_profileImage == null) return _currentImageUrl;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('admin_images/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(_profileImage!);
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image');
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? imageUrl = await _uploadImage();
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "name": _nameController.text,
        "number": _phoneController.text,
        "location": _addressController.text,
        "workType": _workTypeController.text,
        "country": _countryController.text,
        "employees": _employeesController.text,
        "imageUrl": imageUrl,
      });

      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile");
    }

    setState(() => _isLoading = false);
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        validator: (value) => value!.isEmpty ? "Please enter $label" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    } else if (_currentImageUrl != null) {
      return NetworkImage(_currentImageUrl!);
    }
    return const AssetImage("assets/profile_placeholder.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Edit Profile"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _getProfileImage(),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  label: "Name",
                  icon: Icons.person,
                  controller: _nameController),
              _buildTextField(
                label: "Email",
                icon: Icons.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              _buildTextField(
                label: "Phone",
                icon: Icons.phone,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                label: "Address",
                icon: Icons.location_on,
                controller: _addressController,
              ),

              const SizedBox(height: 30),
              CustomButton(name: "Save", width: 200, height: 50, color: Colors.black87, onPressed: _saveProfile)
            ],
          ),
        ),
      ),
    );
  }
}
