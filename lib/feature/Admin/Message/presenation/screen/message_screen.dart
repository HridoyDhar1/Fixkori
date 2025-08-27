import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../chat/presentaion/widget/chat_bubble.dart';



class AdminChatScreen extends StatefulWidget {
  final String chatId;
  final String userId;
  final String userName;

  const AdminChatScreen({
    super.key,
    required this.chatId,
    required this.userId,
    required this.userName,
  });

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? serviceCard;

  @override
  void initState() {
    super.initState();
    _fetchServiceCard();
  }

  Future<void> _fetchServiceCard() async {
    final chatDoc = await FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("chats")
        .doc(widget.chatId)
        .get();

    if (chatDoc.exists) {
      setState(() {
        serviceCard = chatDoc.data()?['serviceCard'];
      });
    }
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final message = _controller.text.trim();
    _controller.clear();

    final messagesRef = FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("chats")
        .doc(widget.chatId)
        .collection("messages");

    await messagesRef.add({
      "senderId": FirebaseAuth.instance.currentUser!.uid,
      "receiverId": widget.userId,
      "message": message,
      "timestamp": FieldValue.serverTimestamp(),
    });

    // Update last message
    await FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("chats")
        .doc(widget.chatId)
        .update({
      "lastMessage": message,
      "lastMessageTime": FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesRef = FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("chats")
        .doc(widget.chatId)
        .collection("messages")
        .orderBy("timestamp", descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ✅ Service Card at top
          if (serviceCard != null)
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  serviceCard!['imageUrl'] != null &&
                      serviceCard!['imageUrl'].toString().isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      serviceCard!['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.broken_image),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceCard!['post'] ?? "Service",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${serviceCard!['price'] ?? '0'}",
                          style: const TextStyle(
                              color: Colors.teal, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // ✅ Messages list with ChatBubble
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe =
                        msg['senderId'] == FirebaseAuth.instance.currentUser!.uid;

                    return ChatBubble(
                      message: msg['message'],
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),

          // ✅ Message input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
