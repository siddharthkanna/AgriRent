import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:agrirent/models/chat.model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  StreamSubscription? _messageSubscription;

  // Initialize FCM
  Future<void> initialize() async {
    // Request permission for notifications
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // Listen to token refresh
    _messaging.onTokenRefresh.listen((token) {
      print('FCM Token refreshed: $token');
      // TODO: Update token in user's document
    });
  }

  // Get or create a chat between two users
  Future<String> getOrCreateChat(String currentUserId, String otherUserId) async {
    try {
      print('Getting/Creating chat for users: $currentUserId and $otherUserId');
      
      // Query for existing chat
      final querySnapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContainsAny: [currentUserId])
          .get();

      // Check if chat exists
      QueryDocumentSnapshot<Map<String, dynamic>>? existingChat;
      try {
        existingChat = querySnapshot.docs.firstWhere(
          (doc) {
            final participants = List<String>.from(doc.data()['participants'] ?? []);
            return participants.contains(currentUserId) && 
                   participants.contains(otherUserId);
          },
        );
      } catch (_) {
        existingChat = null;
      }

      if (existingChat != null) {
        print('Found existing chat: ${existingChat.id}');
        return existingChat.id;
      }

      // Create new chat
      final chatRef = await _firestore.collection('chats').add({
        'participants': [currentUserId, otherUserId],
        'last_message_time': FieldValue.serverTimestamp(),
        'created_at': FieldValue.serverTimestamp(),
      });

      print('Created new chat: ${chatRef.id}');
      return chatRef.id;
    } catch (e) {
      print('Error in getOrCreateChat: $e');
      rethrow;
    }
  }

  // Get all chats for a user
  Stream<List<Chat>> getUserChats(String userId) {
    try {
      print('Getting chats for user: $userId');
      
      return _firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .orderBy('last_message_time', descending: true)
          .snapshots()
          .handleError((error) {
            print('Error in getUserChats: $error');
            // If the error is about missing index, return empty list
            if (error.toString().contains('failed-precondition') ||
                error.toString().contains('requires an index')) {
              return [];
            }
            throw error;
          })
          .map((snapshot) {
            print('Received ${snapshot.docs.length} chats');
            return snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return Chat.fromJson(data, doc.id);
            }).toList();
          });
    } catch (e) {
      print('Error in getUserChats: $e');
      rethrow;
    }
  }

  // Get messages for a specific chat
  Stream<List<Message>> getChatMessages(String chatId) {
    try {
      return _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return Message.fromJson(data, doc.id);
            }).toList();
          });
    } catch (e) {
      print('Error in getChatMessages: $e');
      rethrow;
    }
  }

  // Send a text message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    try {
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages');

      await messageRef.add({
        'sender_id': senderId,
        'text': text,
        'created_at': FieldValue.serverTimestamp(),
        'is_read': false,
      });

      // Update both last message time and the message text
      await _firestore
          .collection('chats')
          .doc(chatId)
          .update({
            'last_message_time': FieldValue.serverTimestamp(),
            'last_message': text,
          });
      
      // Get recipient's FCM token and send notification
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();
      final participants = List<String>.from(chatDoc.data()?['participants'] ?? []);
      final recipientId = participants.firstWhere((id) => id != senderId);
      
      // TODO: Get recipient's FCM token from their user document
      // TODO: Send FCM notification
    } catch (e) {
      print('Error in sendMessage: $e');
      rethrow;
    }
  }

  // Send an image message
  Future<void> sendImageMessage({
    required String chatId,
    required String senderId,
    required File imageFile,
  }) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final String storagePath = 'chat_images/$chatId/$fileName';

      // Upload image to Firebase Storage
      final storageRef = _storage.ref().child(storagePath);
      await storageRef.putFile(imageFile);

      // Get download URL
      final String imageUrl = await storageRef.getDownloadURL();

      // Save message with image URL
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'sender_id': senderId,
            'image_url': imageUrl,
            'created_at': FieldValue.serverTimestamp(),
            'is_read': false,
          });

      // Update last message time and indicate it's an image
      await _firestore
          .collection('chats')
          .doc(chatId)
          .update({
            'last_message_time': FieldValue.serverTimestamp(),
            'last_message': '📷 Image',
          });
    } catch (e) {
      print('Error in sendImageMessage: $e');
      rethrow;
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('is_read', isEqualTo: false)
          .where('sender_id', isNotEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'is_read': true});
      }
      await batch.commit();
    } catch (e) {
      print('Error in markMessagesAsRead: $e');
      rethrow;
    }
  }

  // Helper method to update last message time
  Future<void> _updateLastMessageTime(String chatId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .update({
            'last_message_time': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error in _updateLastMessageTime: $e');
      rethrow;
    }
  }

  // Clean up resources
  void dispose() {
    _messageSubscription?.cancel();
  }
} 