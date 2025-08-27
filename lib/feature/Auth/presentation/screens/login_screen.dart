import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:serviceapp/core/lang/lang_switch.dart';
import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';

import '../../../Admin/Auth/data/model/appuser_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String name = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String selectedRole = "User";
  Future<void> login(String email, String password, String role) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;

      // Fetch user/admin document
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(role == "Admin" ? "admins" : "users")
          .doc(uid)
          .get();

      if (!doc.exists) {
        throw Exception("No $role account found for this user.");
      }

      AppUser user = AppUser.fromMap(doc.data() as Map<String, dynamic>);
      print("${user.role} logged in: ${user.name}");

      // Navigate based on role
      if (user.role == "Admin") {
        Get.toNamed("/admin_navigation");
      } else {
        Get.toNamed("/user_navigation");
      }

    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
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
LanguageToggle(),

            // Logo
            SvgPicture.asset("assets/images/Tablet login-cuate.svg",height: 350),
            const SizedBox(height: 30),

            // Login Form Container
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
                    // Role Toggle Inside Form
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _buildRoleButton("User"),
                    //     const SizedBox(width: 10),
                    //     _buildRoleButton("Admin"),
                    //   ],
                    // ),
                    const SizedBox(height: 20),

                    // Email Field
                    _buildTextField(
                      _emailController,
                      selectedRole == "Admin" ? 'Admin Email' : 'User Email',
                      TextInputType.emailAddress,
                      icon: selectedRole == "Admin"
                          ? Icons.admin_panel_settings
                          : Icons.email,
                    ),
                    const SizedBox(height: 15),

                    // Password Field
                    _buildPasswordField(),
                    const SizedBox(height: 30),

                    // Login Button
                    CustomButton(
                      name: "Login".tr,
                      width: 220,
                      height: 50,
                      color: Colors.black87,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          // Check for default superadmin
                          if (email == "superadmin@gmail.com" && password == "supersecretpassword") {
                            Get.toNamed("/admin_dashboard");
                            return;
                          }

                          try {
                            UserCredential userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            String uid = userCredential.user!.uid;

                            DocumentSnapshot userDoc;
                            if (selectedRole == "Admin") {
                              userDoc = await FirebaseFirestore.instance   .collection("serviceApp")
                                  .doc("appData").collection("admins").doc(uid).get();
                            } else {
                              userDoc = await FirebaseFirestore.instance   .collection("serviceApp")
                                  .doc("appData").collection("users").doc(uid).get();
                            }

                            if (userDoc.exists) {
                              Get.toNamed(selectedRole == "Admin" ? "/navigation" : "/user_navigation");
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Role mismatch or user not found.")),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.message ?? "Login failed")),
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
            // Forgot Password & Sign Up
            TextButton(
              onPressed: () {},
              child: const Text("Forgot Password?"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    // Pass the selected role to SignUp screen, defaulting to 'User' if none selected
                    Get.toNamed(
                      "/signup",
                      arguments: {"role": selectedRole ?? "User"},
                    );
                  },
                  child: const Text("Sign Up"),
                ),

              ],
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedRole = "Admin";  // Switch to Admin role
                });
              },
              child: const Text("Admin?"),
            )

          ],
        ),
      ),
    );
  }

  // Role Button Widget
  Widget _buildRoleButton(String role) {
    bool isSelected = selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRole = role;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey : Colors.white,
            borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.grey)
          ),
          alignment: Alignment.center,
          child: Text(
            role,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Text Field Widget
  Widget _buildTextField(
      TextEditingController controller,
      String label,
      TextInputType type, {
        IconData? icon,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
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

  // Password Field Widget
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Enter Password' : null,
    );
  }
}
