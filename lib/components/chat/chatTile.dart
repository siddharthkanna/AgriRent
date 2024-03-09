import 'package:agrirent/screens/chat/chatScreen.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String chatId;
  final String name;
  final String lastMessage;
  final String userPhotoUrl;

  const ChatTile({
    super.key,
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
