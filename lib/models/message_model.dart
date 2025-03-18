import 'package:campus_connect/models/user_model.dart';

enum MessageType { text, image, file }

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final MessageType type;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.type = MessageType.text,
  });
}

class Chat {
  final User user;
  final List<Message> messages;
  final DateTime lastMessageTime;
  final bool hasUnreadMessages;

  Chat({
    required this.user,
    required this.messages,
    required this.lastMessageTime,
    this.hasUnreadMessages = false,
  });
}
