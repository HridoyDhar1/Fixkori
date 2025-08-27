import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';

class AdminSplashScreen extends StatelessWidget {
  const AdminSplashScreen({super.key});
static const String name='/worker_reg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Image.asset(
              'assets/images/company.png',
              width: double.infinity,
              height: 450,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),

          // Title and Subtitle
          const Text(
            "REGISTER A COMPANY WITH US?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Register and Grow Your Business!",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),

          // Features
          _buildFeatureItem(
            icon: Icons.access_time,
            title: "Quality Client Acquisition",
            subtitle:
            "Receive job requests from customers who value professionalism and are willing to pay fair rates.",
          ),
          _buildFeatureItem(
            icon: Icons.verified,
            title: "Enhanced Earning Potential",
            subtitle:
            "Access higher-paying projects and long-term contracts for increased income potential.",
          ),
          _buildFeatureItem(
            icon: Icons.pie_chart,
            title: "Building Trust and Reputation",
            subtitle:
            "Enhance your professional reputation by consistently delivering high-quality services, earning trust and repeat business.",
          ),
          const Spacer(),

          // Register Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(name: "SignUp", width: 400, height: 50, color: Colors.black87, onPressed: (){
              Get.toNamed("/signup");
            })
          ),
          const SizedBox(height: 10),

          // Need Help
          const Text(
            "Need Help?",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.grey, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
