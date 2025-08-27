// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'message_screen.dart';
//
// class AdminChatList extends StatelessWidget {
//   const AdminChatList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final chatsRef = FirebaseFirestore.instance
//         .collection("serviceApp")
//         .doc("appData")
//         .collection("chats")
//         .orderBy("lastMessageTime", descending: true);
//
//     return Scaffold(
//       backgroundColor: const Color(0xffF7FAFF),
//       appBar: AppBar(
//         title: Center(child: const Text("Chats")),
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: chatsRef.snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final chats = snapshot.data!.docs;
//
//           if (chats.isEmpty) {
//             return const Center(child: Text("No chats yet"));
//           }
//
//           return ListView.builder(
//             itemCount: chats.length,
//             itemBuilder: (context, index) {
//               final chat = chats[index];
//               final userName = chat['userName'] ?? "User";
//               final lastMessage = chat['lastMessage'] ?? "";
//               final chatId = chat.id;
//               final userId = chat['userId'];
//
//               return GestureDetector(
//                 onTap: () {
//                   Get.to(() => AdminChatScreen(
//                     chatId: chatId,
//                     userId: userId,
//                     userName: userName,
//                   ));
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.15),
//                         blurRadius: 1,
//                         offset: const Offset(0, 1),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       const CircleAvatar(
//                         backgroundColor: Colors.teal,
//                         child: Icon(Icons.person, color: Colors.white),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               userName,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               lastMessage,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black54,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../../../chat/presentaion/widget/chat_screen.dart';
//
//
// class AdminChatList extends StatelessWidget {
//   const AdminChatList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final providerId = FirebaseAuth.instance.currentUser!.uid;
//
//     final chatsRef = FirebaseFirestore.instance
//         .collection("serviceApp")
//         .doc("appData")
//         .collection("chats")
//         .where("providerId", isEqualTo: providerId)
//         .orderBy("lastMessageTime", descending: true);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Chats with Users"),
//         backgroundColor: Colors.teal,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: chatsRef.snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final chats = snapshot.data!.docs;
//
//           if (chats.isEmpty) return const Center(child: Text("No chats yet"));
//
//           return ListView.builder(
//             itemCount: chats.length,
//             itemBuilder: (context, index) {
//               final chat = chats[index];
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: chat['userImageUrl'] != null && chat['userImageUrl'].isNotEmpty
//                       ? NetworkImage(chat['userImageUrl'])
//                       : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
//                 ),
//                 title: Text(chat['userName'] ?? "User"),
//                 subtitle: Text(chat['lastMessage'] ?? ""),
//                 trailing: chat['lastMessageTime'] != null
//                     ? Text(
//                   (chat['lastMessageTime'] as Timestamp).toDate().toLocal().toString().split(' ')[1].substring(0,5),
//                   style: const TextStyle(fontSize: 12),
//                 )
//                     : null,
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => UserChatScreen(
//                         chatId: chat.id,
//                         otherUserId: chat['userId'],
//                         otherUserName: chat['userName'],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../chat/presentaion/widget/chat_screen.dart' show UserChatScreen;

class AdminChatList extends StatelessWidget {
  const AdminChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final providerId = FirebaseAuth.instance.currentUser!.uid;

    final chatsRef = FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("chats")
        .where("providerId", isEqualTo: providerId)
        .orderBy("lastMessageTime", descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats with Users"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final chats = snapshot.data!.docs;

          if (chats.isEmpty) return const Center(child: Text("No chats yet"));

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];

              // Ensure userName is always available
              final userName = (chat['userName'] != null && chat['userName'].toString().isNotEmpty)
                  ? chat['userName']
                  : "User";

              final userImageUrl = (chat['userImageUrl'] != null && chat['userImageUrl'].toString().isNotEmpty)
                  ? chat['userImageUrl']
                  : null;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: userImageUrl != null
                      ? NetworkImage(userImageUrl)
                      : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
                ),
                title: Text(userName),
                subtitle: Text(chat['lastMessage'] ?? ""),
                trailing: chat['lastMessageTime'] != null
                    ? Text(
                  (chat['lastMessageTime'] as Timestamp)
                      .toDate()
                      .toLocal()
                      .toString()
                      .split(' ')[1]
                      .substring(0, 5),
                  style: const TextStyle(fontSize: 12),
                )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserChatScreen(
                        chatId: chat.id,
                        otherUserId: chat['userId'],
                        otherUserName: userName,
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
