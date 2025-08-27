import 'package:flutter/material.dart';
import 'package:serviceapp/feature/User/user_navigation.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to contact screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  CustomUserNavigationScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text(
                  "Contact Us",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "If you have any question\nwe are happy to help",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 40),

                // Phone
                _contactItem(
                  icon: Icons.phone,
                  color: Colors.limeAccent,
                  text: "+92 347 096 35",
                ),

                const SizedBox(height: 30),

                // Email
                _contactItem(
                  icon: Icons.email_outlined,
                  color: Colors.limeAccent,
                  text: "contact@mafimumshkil.services",
                ),

                const SizedBox(height: 50),
                const Text(
                  "Get Connected",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  children: const [
                    _socialIcon(Icons.linked_camera), // placeholder
                    _socialIcon(Icons.facebook),

                    _socialIcon(Icons.camera_alt_outlined),

                  ],
                ),

                const SizedBox(height: 40),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _contactItem({
  required IconData icon,
  required Color color,
  required String text,
}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black, size: 28),
      ),
      const SizedBox(height: 8),
      Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    ],
  );
}

class _socialIcon extends StatelessWidget {
  final IconData icon;
  const _socialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
