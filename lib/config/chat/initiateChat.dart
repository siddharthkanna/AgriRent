import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> initiateChat(String ownerId) async {
  try {
    // Get current user ID
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Check for existing chat initiated by ownerId
    final chatsRef = FirebaseFirestore.instance.collection('chats');
    final existingChat = await chatsRef.where('participants',
        arrayContainsAny: [
          currentUserId,
          ownerId
        ]).where('creatorId', whereIn: [currentUserId, ownerId]).get();

    String chatId;

    if (existingChat.docs.isNotEmpty) {
      chatId = existingChat.docs.first.id;
    } else {
      // Create new chat document
      final newChatDoc = chatsRef.doc();
      await newChatDoc.set({
        'participants': [currentUserId, ownerId],
        'messages': [],
        'creatorId': currentUserId, 
      });
      chatId = newChatDoc.id;
    }

    return chatId;
  } catch (error) {
    // Handle errors gracefully
    return Future.error(error);
  }
}
