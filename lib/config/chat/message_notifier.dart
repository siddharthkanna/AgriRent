import 'dart:async';

class MessageNotifier {
  static final StreamController<bool> _messageStreamController =
      StreamController<bool>.broadcast();

  static Stream<bool> get messageStream => _messageStreamController.stream;

  static void notifyNewMessage() {
    _messageStreamController.add(true);
  }
}
