import 'package:agrirent/config/chat/message_notifier.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessagesScreen extends StatefulWidget {
  final String chatId;
  final String userPhotoUrl;
  final String userName;

  ChatMessagesScreen({
    required this.chatId,
    required this.userPhotoUrl,
    required this.userName,
  });

  @override
  _ChatMessagesScreenState createState() => _ChatMessagesScreenState();
}

class _ChatMessagesScreenState extends State<ChatMessagesScreen> {
  late CollectionReference _messagesCollection;
  final TextEditingController _messageController = TextEditingController();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _messagesCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userPhotoUrl),
              radius: 20.0,
            ),
            const SizedBox(width: 12.0),
            Text(
              widget.userName.split(' ')[0],
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Palette.grey,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var messages = snapshot.data!.docs.reversed;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  var messageText = message['text'];
                  var messageSender = message['sender'];

                  var messageWidget = MessageBubble(
                    sender: messageSender,
                    text: messageText,
                    isCurrentUser: messageSender == currentUserId,
                  );
                  messageWidgets.add(messageWidget);
                }

                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget MessageBubble({
    required String sender,
    required String text,
    required bool isCurrentUser,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment: isCurrentUser ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isCurrentUser ? Palette.red : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topRight:
                  isCurrentUser ? Radius.circular(20.0) : Radius.circular(0.0),
              topLeft:
                  isCurrentUser ? Radius.circular(0.0) : Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isCurrentUser ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  _sendMessage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() async {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      await _messagesCollection.add({
        'text': text,
        'sender': currentUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();

      MessageNotifier.notifyNewMessage();
    }
  }
}
