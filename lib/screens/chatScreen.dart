import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 6,top: 6),
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
      body: ListView.builder(
        itemCount: dummyChatData.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: profileImage(),
            title: Text(
              dummyChatData[index]['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              dummyChatData[index]['messages'].last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatMessagesScreen(
                    chatData: dummyChatData[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget profileImage() {
    return const CircleAvatar(
      backgroundImage: NetworkImage(
          'https://play-lh.googleusercontent.com/C9CAt9tZr8SSi4zKCxhQc9v4I6AOTqRmnLchsu1wVDQL0gsQ3fmbCVgQmOVM1zPru8UH=w240-h480-rw'), // Replace with your image asset
      radius: 25.0,
    );
  }
}

class ChatMessagesScreen extends StatelessWidget {
  final Map<String, dynamic> chatData;

  ChatMessagesScreen({required this.chatData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://play-lh.googleusercontent.com/C9CAt9tZr8SSi4zKCxhQc9v4I6AOTqRmnLchsu1wVDQL0gsQ3fmbCVgQmOVM1zPru8UH=w240-h480-rw'),
              radius: 20.0,
            ),
            const SizedBox(width: 12.0),
            Text(
              chatData['name'],
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Palette.grey,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // To display messages from bottom to top
              itemCount: chatData['messages'].length,
              itemBuilder: (context, index) {
                return messageBubble(chatData['messages'][index]);
              },
            ),
          ),
          messageInput(),
        ],
      ),
    );
  }

  Widget messageBubble(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            color: Palette.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget messageInput() {
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
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // send message logic here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> dummyChatData = [
  {
    'name': 'John Doe',
    'messages': [
      'Hello',
      'How are you?',
      'I am good, thanks!',
    ],
  },
  {
    'name': 'Jane Smith',
    'messages': [
      'Hi',
      'What are you up to?',
      'Just working on a project',
    ],
  },
];
