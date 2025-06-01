class Chat {
  final String id;
  final List<String> participants;
  final DateTime lastMessageTime;
  final String? lastMessage;

  Chat({
    required this.id,
    required this.participants,
    required this.lastMessageTime,
    this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json, String chatId) {
    print('Creating Chat object from JSON: $json');
    
    // Handle the Timestamp conversion for lastMessageTime
    DateTime lastMessageTime;
    final timestamp = json['last_message_time'];
    if (timestamp == null) {
      lastMessageTime = DateTime.now();
    } else if (timestamp is DateTime) {
      lastMessageTime = timestamp;
    } else {
      // Convert Firestore Timestamp to DateTime
      lastMessageTime = timestamp.toDate();
    }

    return Chat(
      id: chatId,
      participants: List<String>.from(json['participants'] ?? []),
      lastMessageTime: lastMessageTime,
      lastMessage: json['last_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'last_message_time': lastMessageTime,
      'last_message': lastMessage,
    };
  }
}

class Message {
  final String id;
  final String senderId;
  final String? text;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isRead;
  final String chatId;

  Message({
    required this.id,
    required this.senderId,
    this.text,
    this.imageUrl,
    required this.createdAt,
    required this.isRead,
    required this.chatId,
  });

  factory Message.fromJson(Map<String, dynamic> json, String messageId) {
    print('Creating Message from JSON: $json');
    // Handle the Timestamp conversion
    DateTime createdAt;
    final timestamp = json['created_at'];
    if (timestamp == null) {
      createdAt = DateTime.now();
    } else if (timestamp is DateTime) {
      createdAt = timestamp;
    } else {
      // Convert Firestore Timestamp to DateTime
      createdAt = timestamp.toDate();
    }

    return Message(
      id: messageId,
      senderId: json['sender_id'] ?? '',
      text: json['text'],
      imageUrl: json['image_url'],
      createdAt: createdAt,
      isRead: json['is_read'] ?? false,
      chatId: json['chat_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'text': text,
      'image_url': imageUrl,
      'created_at': createdAt,
      'is_read': isRead,
      'chat_id': chatId,
    };
  }
} 