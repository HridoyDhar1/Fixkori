
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final Map<String, dynamic>? service;
  const UserChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName, this.service,
  });

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? otherUserData;

  @override
  void initState() {
    super.initState();
    _loadOtherUserData();
    _markMessagesAsRead();
  }

  Future<void> _loadOtherUserData() async {
    try {
      // Try to get user data from users collection
      final userDoc = await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("users")
          .doc(widget.otherUserId)
          .get();

      if (userDoc.exists) {
        setState(() {
          otherUserData = userDoc.data();
        });
        return;
      }

      // If not found in users, try admins_profile
      final adminDoc = await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("admins_profile")
          .doc(widget.otherUserId)
          .get();

      if (adminDoc.exists) {
        setState(() {
          otherUserData = adminDoc.data();
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> _markMessagesAsRead() async {
    if (user == null) return;

    try {
      // Mark all messages from the other user as read
      final messagesSnapshot = await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("chats")
          .doc(widget.chatId)
          .collection("messages")
          .where("senderId", isEqualTo: widget.otherUserId)
          .where("read", isEqualTo: false)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in messagesSnapshot.docs) {
        batch.update(doc.reference, {"read": true, "readAt": FieldValue.serverTimestamp()});
      }

      await batch.commit();
    } catch (e) {
      print("Error marking messages as read: $e");
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || user == null) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    try {
      // Add message to subcollection
      await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("chats")
          .doc(widget.chatId)
          .collection("messages")
          .add({
        "senderId": user!.uid,
        "message": message,
        "timestamp": FieldValue.serverTimestamp(),
        "type": "text",
        "read": false, // Message is unread by default
      });

      // Update last message in chat document
      await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("chats")
          .doc(widget.chatId)
          .update({
        "lastMessage": message,
        "lastMessageTime": FieldValue.serverTimestamp(),
      });

      // Scroll to bottom after sending message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      print("Error sending message: $e");
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to send message"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getOtherUserImage() {
    return otherUserData?["profileImage"] ??
        otherUserData?["imageUrl"] ??
        otherUserData?["photoURL"] ?? "";
  }

  String _getOtherUserRole() {
    if (otherUserData?["isProvider"] == true ||
        otherUserData?["workType"] != null) {
      return "Service Provider";
    }
    return "Customer";
  }
  Widget _buildServiceInfo() {
    if (widget.service == null) return const SizedBox.shrink();

    final service = widget.service!;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          service["imageUrl"] != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              service["imageUrl"],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          )
              : Container(
            width: 60,
            height: 60,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service["post"] ?? "Untitled Service",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${service["price"] ?? '0'}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                if (service["location"] != null)
                  Text(
                    service["location"],
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[200],
              backgroundImage: _getOtherUserImage().isNotEmpty
                  ? NetworkImage(_getOtherUserImage())
                  : null,
              child: _getOtherUserImage().isEmpty
                  ? const Icon(Icons.person, size: 18)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.otherUserName),
                Text(
                  _getOtherUserRole(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          if (widget.service != null) _buildServiceInfo(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("serviceApp")
                  .doc("appData")
                  .collection("chats")
                  .doc(widget.chatId)
                  .collection("messages")
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data?.docs ?? [];

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'Start a conversation...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {

                    final message = messages[index];
                    final data = message.data() as Map<String, dynamic>;
                    final isMe = data["senderId"] == user?.uid;

                    return ChatMessageBubble(
                      message: data["message"] ?? "",
                      isMe: isMe,
                      timestamp: data["timestamp"],
                      isRead: data["read"] ?? false,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.teal,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final dynamic timestamp;
  final bool isRead;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.timestamp,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isMe ? Colors.teal : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (timestamp != null)
                        Text(
                          _formatTime(timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color: isMe ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      if (isMe && isRead)
                        const Icon(Icons.done_all, size: 12, color: Colors.white70),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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

      return DateFormat('HH:mm').format(time);
    } catch (e) {
      return "";
    }
  }
}