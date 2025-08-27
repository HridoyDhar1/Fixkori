import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = 'splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Text(
              "Best Helping\nHands for you",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              "With Our On-Demand Services App,We Give Better Services To You.",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Image.asset("assets/images/Mask group.png"),
            const SizedBox(height: 100),
            CustomButton(
              name: "Company",
              width: 400,
              height: 50,
              color: Colors.black87,
              onPressed: () {
                Get.toNamed("/navigation");
              },
            ),
            const SizedBox(height: 50),
            CustomButton(
              name: "Customer",
              width: 400,
              height: 50,
              color: Colors.black87,
              onPressed: () {

                Get.toNamed("/user_navigation");
              },
            ),
          ],
        ),
      ),
    );
  }
}
