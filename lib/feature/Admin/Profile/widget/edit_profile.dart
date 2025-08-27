import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
import '../../Auth/data/model/admin_model.dart';

class EditProfileScreen extends StatefulWidget {
  final AdminModel adminData;

  const EditProfileScreen({Key? key, required this.adminData}) : super(key: key);

  static const String name = '/edit_profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File? _profileImage;
  bool _isLoading = false;

  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _workTypeController;
  late final TextEditingController _countryController;
  late final TextEditingController _employeesController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _nameController = TextEditingController(text: widget.adminData.name);
    _emailController = TextEditingController(text: widget.adminData.email);
    _phoneController = TextEditingController(text: widget.adminData.number);
    _addressController = TextEditingController(text: widget.adminData.location);
    _workTypeController = TextEditingController(text: widget.adminData.workType);
    _countryController = TextEditingController(text: widget.adminData.country);
    _employeesController = TextEditingController(text: widget.adminData.employees);
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _workTypeController.dispose();
    _countryController.dispose();
    _employeesController.dispose();
    super.dispose();
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
    if (_profileImage == null) return widget.adminData.imageUrl;

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
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      final imageUrl = await _uploadImage();

      final updatedAdmin = widget.adminData.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        number: _phoneController.text.trim(),
        location: _addressController.text.trim(),
        workType: _workTypeController.text.trim(),
        country: _countryController.text.trim(),
        employees: _employeesController.text.trim(),
        imageUrl: imageUrl,
        userId: user.uid, // Ensure user ID is set
      );

      await _updateAdmin(updatedAdmin);

      Get.back(result: true); // Return success
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateAdmin(AdminModel admin) async {
    try {
      if (admin.id == null || admin.id!.isEmpty) {
        throw Exception('Admin document ID is missing');
      }

      await FirebaseFirestore.instance   .collection("serviceApp")
          .doc("appData")
          .collection('admins_profile')
          .doc(admin.id)
          .update(admin.toMap());
    } catch (e) {
      rethrow;
    }
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
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
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
    } else if (widget.adminData.imageUrl != null) {
      return NetworkImage(widget.adminData.imageUrl!);
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
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: "Name",
                icon: Icons.person,
                controller: _nameController,
              ),
              _buildTextField(
                label: "Email",
                icon: Icons.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true, // Email shouldn't be changed
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
              _buildTextField(
                label: "Work Type",
                icon: Icons.work,
                controller: _workTypeController,
              ),
              _buildTextField(
                label: "Country",
                icon: Icons.flag,
                controller: _countryController,
              ),
              _buildTextField(
                label: "Employees",
                icon: Icons.people,
                controller: _employeesController,
              ),
              const SizedBox(height: 30),
              CustomButton(
                name: "Save Changes",
                width: double.infinity,
                height: 50,
                color: Colors.blue,
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}