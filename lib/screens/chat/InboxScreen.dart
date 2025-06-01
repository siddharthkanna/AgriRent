import 'package:agrirent/api/user_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agrirent/models/chat.model.dart';
import 'package:agrirent/services/firebase_chat_service.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/screens/chat/ChatScreen.dart';
import 'package:agrirent/providers/chat_provider.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:shimmer/shimmer.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  Stream<List<Chat>>? _chatsStream;
  String? _currentUserId;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final user = ref.read(authProvider);
    if (user != null) {
      _currentUserId = user.id;
      final chatService = ref.read(chatServiceProvider);
      await chatService.initialize();
      
      if (mounted) {
        setState(() {
          _chatsStream = chatService.getUserChats(_currentUserId!);
          _isInitialized = true;
        });
      }
      
      print('Initialized chat for user: $_currentUserId');
    } else {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (user == null) {
      return _buildSignInPrompt();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[200],
            height: 1.0,
          ),
        ),
      ),
      body: _chatsStream == null
          ? _buildEmptyState()
          : StreamBuilder<List<Chat>>(
              stream: _chatsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingState();
                }

                if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }

                final chats = snapshot.data ?? [];
                
                if (chats.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final otherUserId = chat.participants
                        .firstWhere((id) => id != _currentUserId);

                    return FutureBuilder<String>(
                      future: _getUserName(otherUserId),
                      builder: (context, snapshot) {
                        final userName = snapshot.data ?? 'Loading...';
                        
                        return _buildChatListItem(
                          chat: chat,
                          userName: userName,
                          lastMessageTime: chat.lastMessageTime,
                          onTap: () => _navigateToChat(chat.id, otherUserId, userName),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
  Future<String> _getUserName(String userId) async {
    final user = await UserApi().getUserData(userId);
    return user['name'] ?? 'Loading...';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _navigateToChat(String chatId, String otherUserId, String otherUserName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: chatId,
          otherUserId: otherUserId,
          otherUserName: otherUserName,
        ),
      ),
    );
  }

  Widget _buildSignInPrompt() {
    return const Center(child: Text('Please sign in to view messages'));
  }

  Widget _buildEmptyState() {
    return const Center(child: Text('No messages yet'));
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String error) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildChatListItem({
    required Chat chat,
    required String userName,
    required DateTime lastMessageTime,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Palette.primary,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        userName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chat.lastMessage ?? 'No messages yet',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            _formatDate(lastMessageTime),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
