import 'package:flutter/material.dart';

class HomeCarouselCard extends StatelessWidget {
  const HomeCarouselCard({
    super.key,
    required this.title,
    required this.buttonText,
    required this.imageAssetPath,
  });

  final String title;
  final String buttonText;
  final String imageAssetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Remove image from decoration because Image.asset will be a child
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageAssetPath,
              fit: BoxFit.cover,
            ),
            // Container(
            //   padding: const EdgeInsets.all(15),
            //   alignment: Alignment.bottomLeft,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.teal,
            //       minimumSize: Size(100, 50),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     onPressed: () {},
            //     child: Text(buttonText),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

