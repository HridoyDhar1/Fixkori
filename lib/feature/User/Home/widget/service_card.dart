import 'package:flutter/material.dart';

class HomeServiceCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;

  const HomeServiceCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image (network or local fallback)
            imageUrl.startsWith("http")
                ? Image.network(
              imageUrl,
              height: 150,
              width: 140,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                "assets/images/placeholder.png",
                height: 100,
                width: 140,
                fit: BoxFit.cover,
              ),
            )
                : Image.asset(
              imageUrl,
              height: 100,
              width: 140,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              price,
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
