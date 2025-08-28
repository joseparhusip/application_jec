// lib/models/chat_message.dart

class ChatMessage {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isFromUser,
    required this.timestamp,
  });

  factory ChatMessage.skeleton() {
    return ChatMessage(
      text: 'loading message',
      isFromUser: false,
      timestamp: DateTime.now(),
    );
  }
}