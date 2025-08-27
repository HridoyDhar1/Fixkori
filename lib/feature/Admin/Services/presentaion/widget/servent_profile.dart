
import 'dart:io';
import 'package:flutter/material.dart';

class PersonDetailsPage extends StatelessWidget {
  final Map<String, dynamic> person;

  const PersonDetailsPage({required this.person, Key? key}) : super(key: key);

  Widget _buildDetailRow(IconData icon, String label, String? value, {bool isArrow = false}) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(value, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
              ],
            ),
          ),
          if (isArrow)
            CircleAvatar(
              backgroundColor: Colors.deepPurple,
              radius: 14,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = person['imageUrl'] as String?;
    final name = person['name'] ?? 'Unnamed';
    final role = person['workType'] ?? 'N/A';
    final id = person['id'] ?? 'N/A';
    final number = person['number'] ?? 'N/A';
    final experience = person['experience'] ?? 'N/A';
    final country = person['country'] ?? 'N/A';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Purple header
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF3F28EB),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 10),
                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                  child: imageUrl == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
                ),
                const SizedBox(height: 12),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(role, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18)),
                const SizedBox(height: 20),
                _buildActionButton(Icons.call_outlined, 'Call'),
              ],
            ),
          ),

          // White details container
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.card_membership, 'ID', id),
                    _buildDetailRow(Icons.phone_outlined, 'Phone number', number),
                    _buildDetailRow(Icons.group_outlined, 'Experience', experience),
                    _buildDetailRow(Icons.public, 'Country', country),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
