import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lang_controller.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController controller = Get.find();

    return Obx(() {
      String current = controller.currentLocale.value.languageCode;

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            // English
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeLanguage(const Locale('en')),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: current == 'en'
                        ? Color(0xff0B5671)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "English",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: current == 'en'
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            // Bangla
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeLanguage(const Locale('bn')),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: current == 'bn'
                        ? Color(0xff0B5671)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "বাংলা",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: current == 'bn'
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
