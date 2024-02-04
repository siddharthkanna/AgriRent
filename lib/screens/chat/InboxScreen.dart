import 'package:agrirent/api/user_api.dart';
import 'package:agrirent/config/chat/message_notifier.dart';
import 'package:agrirent/constants/chatLoading.dart';
import 'package:agrirent/screens/chat/chatScreen.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final CollectionReference _chatsCollection =
      FirebaseFirestore.instance.collection('chats');

  @override
  void initState() {
    super.initState();

    MessageNotifier.messageStream.listen((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserID == null) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Chats',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: const Center(
            child: Text('User not authenticated'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 6, top: 6),
          child: Text(
            'Chats',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatsCollection
            .where('participants', arrayContains: currentUserID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chatData = snapshot.data!.docs;

          if (chatData.isEmpty) {
            return const Center(
              child: Text(
                'Your chats appear here',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: chatData.length,
            itemBuilder: (context, index) {
              final chat = chatData[index].data() as Map<String, dynamic>;
              final chatId = chatData[index].id;
              final receiverID = (chat['participants'] as List)
                  .firstWhere((id) => id != currentUserID);

              return FutureBuilder<Map<String, dynamic>>(
                // Fetch user data using the user API
                future: UserApi().getUserData(receiverID),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return SkeletonChatLoading();
                  }

                  final user = userSnapshot.data;

                  // Check if 'user' is not null before accessing data
                  final userName = user?['displayName'] ?? 'Default Name';
                  final String firstName = userName.split(' ')[0];
                  final userPhotoUrl = user?['photoURL'] ?? '';

                  return FutureBuilder<QuerySnapshot>(
                    // Fetch last message using the correct reference
                    future: _chatsCollection
                        .doc(chatId)
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .limit(1)
                        .get(),
                    builder: (context, messageSnapshot) {
                      if (messageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SkeletonChatLoading();
                      }

                      final List<DocumentSnapshot> messageDocs =
                          messageSnapshot.data!.docs;
                      final List<Map<String, dynamic>> messages = messageDocs
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();

                      final lastMessage = messages.isNotEmpty
                          ? messages.first['text'].toString()
                          : 'No messages';

                      return ChatTile(
                        chatId: chatId,
                        name: firstName,
                        lastMessage: lastMessage,
                        userPhotoUrl: userPhotoUrl,
                      );
                    },
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

class ChatTile extends StatelessWidget {
  final String chatId;
  final String name;
  final String lastMessage;
  final String userPhotoUrl;

  const ChatTile({
    required this.chatId,
    required this.name,
    required this.lastMessage,
    required this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: Palette.white,
      closedElevation: 0,
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (context, action) => ChatMessagesScreen(
        chatId: chatId,
        userName: name,
        userPhotoUrl: userPhotoUrl,
      ),
      closedBuilder: (context, action) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(userPhotoUrl),
          radius: 23.0,
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
