
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../chat/presentaion/widget/chat_screen.dart';

class AdminChatListScreen extends StatefulWidget {
  static const String name = '/admin_chats';

  const AdminChatListScreen({super.key});

  @override
  State<AdminChatListScreen> createState() => _AdminChatListScreenState();
}

class _AdminChatListScreenState extends State<AdminChatListScreen> {
  final User? adminUser = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (adminUser == null) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _errorMessage = 'Please log in as admin to view messages';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        title: const Center(child: Text('Chats')),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              Future.delayed(const Duration(milliseconds: 5), () {
                setState(() => _isLoading = false);
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? _buildErrorWidget()
          : _buildChatList(),
    );
  }

  Widget _buildChatList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("chats")
          .where("participants.${adminUser!.uid}", isNull: false)
          .snapshots(), // Removed orderBy to avoid index
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data?.docs.isEmpty ?? true) {
          return const Center(
            child: Text(
              'No messages yet',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        // Convert to list and sort locally by lastMessageTime descending
        final chats = snapshot.data!.docs.toList();
        chats.sort((a, b) {
          final timeA = a['lastMessageTime'] is Timestamp
              ? (a['lastMessageTime'] as Timestamp).toDate()
              : DateTime.fromMillisecondsSinceEpoch(0);
          final timeB = b['lastMessageTime'] is Timestamp
              ? (b['lastMessageTime'] as Timestamp).toDate()
              : DateTime.fromMillisecondsSinceEpoch(0);
          return timeB.compareTo(timeA);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            final data = chat.data() as Map<String, dynamic>;

            final participants = Map<String, dynamic>.from(data["participants"] ?? {});
            participants.remove(adminUser!.uid);

            if (participants.isEmpty) return const SizedBox();

            final otherParticipantId = participants.keys.first;
            final otherParticipant = participants.values.first;

            return AdminChatListItem(
              chatId: chat.id,
              participantId: otherParticipantId,
              participantName: otherParticipant["name"] ?? "Customer",
              participantImage: otherParticipant["imageUrl"],
              lastMessage: data["lastMessage"] ?? "",
              lastMessageTime: data["lastMessageTime"],
              isProvider: otherParticipant["isProvider"] ?? false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserChatScreen(
                      chatId: chat.id,
                      otherUserId: otherParticipantId,
                      otherUserName: otherParticipant["name"] ?? "Customer",
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Setup Required',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _isLoading = true;
                });
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() => _isLoading = false);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
              ),
              child: const Text('Try Again', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminChatListItem extends StatelessWidget {
  final String chatId;
  final String participantId;
  final String participantName;
  final String? participantImage;
  final String lastMessage;
  final dynamic lastMessageTime;
  final bool isProvider;
  final VoidCallback onTap;

  const AdminChatListItem({
    super.key,
    required this.chatId,
    required this.participantId,
    required this.participantName,
    this.participantImage,
    required this.lastMessage,
    this.lastMessageTime,
    required this.isProvider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: participantImage != null && participantImage!.isNotEmpty
                      ? NetworkImage(participantImage!)
                      : null,
                  child: participantImage == null || participantImage!.isEmpty
                      ? const Icon(Icons.person, size: 25)
                      : null,
                ),
                if (isProvider)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_user, size: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        participantName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (isProvider)
                        const Icon(Icons.work, size: 14, color: Colors.teal),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage.isNotEmpty ? lastMessage : "Start a conversation...",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (lastMessageTime != null)
              Text(
                _formatTime(lastMessageTime),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return "";
    try {
      DateTime time;
      if (timestamp is Timestamp) {
        time = timestamp.toDate();
      } else if (timestamp is DateTime) {
        time = timestamp;
      } else {
        return "";
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);

      if (time.isAfter(today)) {
        return DateFormat('HH:mm').format(time);
      } else if (time.isAfter(yesterday)) {
        return 'Yesterday';
      } else {
        return DateFormat('MMM dd').format(time);
      }
    } catch (e) {
      return "";
    }
  }
}
