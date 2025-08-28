
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widget/chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  final VoidCallback? onChatsViewed;

  const ChatListScreen({super.key, this.onChatsViewed});

  static const String name = '/chats';

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChatsViewed?.call();
    });
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7FAFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Messages')),
        backgroundColor: Colors.transparent,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.refresh),
          //   onPressed: () {
          //     setState(() {
          //       _isLoading = true;
          //     });
          //     Future.delayed(const Duration(milliseconds: 500), () {
          //       setState(() => _isLoading = false);
          //     });
          //   },
          // ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Please log in to view messages'))
          : _isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("serviceApp")
            .doc("appData")
            .collection("chats")
            .where("participants.${user!.uid}", isNull: false)
        // 🔽 removed orderBy (no index needed now)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
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

          final chats = snapshot.data!.docs;

          // 🔽 sort locally in memory by lastMessageTime
          chats.sort((a, b) {
            final aTime = (a['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime(1970);
            final bTime = (b['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime(1970);
            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final data = chat.data() as Map<String, dynamic>;

              final participants = Map<String, dynamic>.from(data["participants"] ?? {});
              participants.remove(user!.uid);

              if (participants.isEmpty) return const SizedBox();

              final otherParticipantId = participants.keys.first;
              final otherParticipant = participants.values.first;

              return ChatListItem(
                chatId: chat.id,
                participantId: otherParticipantId,
                participantName: otherParticipant["name"] ?? "Unknown",
                participantImage: otherParticipant["imageUrl"],
                lastMessage: data["lastMessage"] ?? "",
                lastMessageTime: data["lastMessageTime"],
                isProvider: otherParticipant["isProvider"] ?? false,
                unreadCount: 0,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserChatScreen(
                        chatId: chat.id,
                        otherUserId: otherParticipantId,
                        otherUserName: otherParticipant["name"] ?? "Unknown",
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final String chatId;
  final String participantId;
  final String participantName;
  final String? participantImage;
  final String lastMessage;
  final dynamic lastMessageTime;
  final bool isProvider;
  final int unreadCount;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.chatId,
    required this.participantId,
    required this.participantName,
    this.participantImage,
    required this.lastMessage,
    this.lastMessageTime,
    required this.isProvider,
    this.unreadCount = 0,
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
                      if (isProvider)
                        const Padding(
                          padding: EdgeInsets.only(left: 6.0),
                          child: Icon(Icons.work, size: 14, color: Colors.teal),
                        ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (lastMessageTime != null)
                  Text(
                    _formatTime(lastMessageTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                if (unreadCount > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(dynamic timestamp) {
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
      final yesterday = today.subtract(const Duration(days: 1));

      if (time.isAfter(today)) {
        return DateFormat('HH:mm').format(time);
      } else if (time.isAfter(yesterday)) {
        return 'Yesterday';
      } else {
        return DateFormat('MMM dd').format(time);
      }
    } catch (_) {
      return "";
    }
  }
}
