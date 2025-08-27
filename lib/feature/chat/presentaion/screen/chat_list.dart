// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../widget/chat_screen.dart';
//
// class UserChatList extends StatelessWidget {
//   final String userId;
//
//   const UserChatList({super.key, required this.userId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF7FAFF),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         automaticallyImplyLeading: false,
//         title: Center(child: const Text("Chats")),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("serviceApp")
//             .doc("appData")
//             .collection("chats")
//             .where("userId", isEqualTo: userId)
//             .orderBy("lastMessageTime", descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return const Center(child: CircularProgressIndicator());
//
//           final chats = snapshot.data!.docs;
//
//           if (chats.isEmpty) return const Center(child: Text("No chats yet"));
//           return ListView.builder(
//             itemCount: chats.length,
//             itemBuilder: (context, index) {
//               final chat = chats[index];
//               return GestureDetector(
//                 onTap: () {
//                   // Get.to(
//                   //       () => UserChatScreen(
//                   //     chatId: chat.id,
//                   //     providerId: chat['providerId'],
//                   //     providerName: chat['providerName'],
//                   //   ),
//                   // );
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 1,
//                         offset: Offset(0, 1),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 25,
//                         backgroundImage: chat['providerImageUrl'] != null
//                             ? NetworkImage(chat['providerImageUrl'])
//                             : null,
//                         child: chat['providerImageUrl'] == null
//                             ? const Icon(Icons.person)
//                             : null,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               chat['providerName'] ?? "Service Provider",
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               chat['lastMessage'] ?? "",
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey,
//                               ),
//                               maxLines: 1,
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
//
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/chat_screen.dart';


class UserChatList extends StatelessWidget {
  const UserChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final chatsRef = FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("chats")
        .where("userId", isEqualTo: userId)
        .orderBy("lastMessageTime", descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Chats"),
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
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: chat['providerImageUrl'] != null && chat['providerImageUrl'].isNotEmpty
                      ? NetworkImage(chat['providerImageUrl'])
                      : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
                ),
                title: Text(chat['providerName'] ?? "Provider"),
                subtitle: Text(chat['lastMessage'] ?? ""),
                trailing: chat['lastMessageTime'] != null
                    ? Text(
                  (chat['lastMessageTime'] as Timestamp).toDate().toLocal().toString().split(' ')[1].substring(0,5),
                  style: const TextStyle(fontSize: 12),
                )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserChatScreen(
                        chatId: chat.id,
                        otherUserId: chat['providerId'],
                        otherUserName: chat['providerName'],
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
