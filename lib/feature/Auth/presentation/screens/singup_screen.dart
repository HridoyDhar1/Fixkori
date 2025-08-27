
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';

import '../../../../core/widgets/map_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const String name = '/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _numberController=TextEditingController();
  final String role = Get.arguments?["role"] ?? "User";

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

// Call this when location field is tapped
  Future<void> _openMapAndPickLocation() async {
    LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(), // your map picker widget
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),

            // Profile Avatar
            SvgPicture.asset("assets/images/Sign up-cuate.svg",height: 300),
            const SizedBox(height: 50),


            // Signup Form
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_nameController, 'Full Name', Icons.person),
                    const SizedBox(height: 15),
                    _buildTextField(
                      _emailController,
                      'Email',
                      Icons.email,
                      TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      _numberController,
                      'Number',
                      Icons.email,
                      TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      _locationController,
                      'Location',
                      Icons.location_on,
                      TextInputType.text,
                      _openMapAndPickLocation,
                      true,
                    ),

                    const SizedBox(height: 15),
                    _buildPasswordField(
                      _passwordController,
                      'Password',
                      _obscurePassword,
                          () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 15),
                    _buildPasswordField(
                      _confirmPasswordController,
                      'Confirm Password',
                      _obscureConfirmPassword,
                          () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      confirmPasswordCheck: true,
                    ),
                    const SizedBox(height: 30),

                    // Signup Button
                    CustomButton(
                      name: "Sign Up",
                      width: 200,
                      height: 50,
                      color: Colors.black87,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            // Create Firebase Auth User
                            UserCredential userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim());

                            String uid = userCredential.user!.uid;

                            // Prepare user data
                            Map<String, dynamic> userData = {
                              "uid": uid,
                              "name": _nameController.text.trim(),
                              "email": _emailController.text.trim(),
                              "location": _locationController.text.trim(),
                              "number":_numberController.text.trim(),
                              "role": role,
                              "createdAt": FieldValue.serverTimestamp(),
                            };

                            // Store in separate collections based on role
                            if (role == "Admin") {
                              await FirebaseFirestore.instance
                                  .collection("serviceApp")
                                  .doc("appData")
                                  .collection("admins")
                                  .doc(uid)
                                  .set(userData);
                              Get.toNamed("/admin_profile");

                            } else {
                              await FirebaseFirestore.instance .collection("serviceApp")
                                  .doc("appData")
                                  .collection("users")
                                  .doc(uid)
                                  .set(userData);
                              Get.toNamed("/user_navigation");
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sign Up Successful!')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                    ),


                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Link to Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Get.toNamed("/login");
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Text Field
  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, [
        TextInputType type = TextInputType.text,
        VoidCallback? onTap,
        bool readOnly = false,
      ]) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Enter $label' : null,
    );
  }

  // Password Field with toggle
  Widget _buildPasswordField(
      TextEditingController controller,
      String label,
      bool obscureText,
      VoidCallback toggleVisibility, {
        bool confirmPasswordCheck = false,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Enter $label';
        if (confirmPasswordCheck && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
