import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agrirent/services/firebase_chat_service.dart';

final chatServiceProvider = Provider((ref) => FirebaseChatService()); 