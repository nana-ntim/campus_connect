import 'package:flutter/foundation.dart';
import 'package:campus_connect/models/message_model.dart';
import 'package:campus_connect/models/user_model.dart';
import 'package:campus_connect/utils/placeholder_data.dart';

class MessageProvider with ChangeNotifier {
  // Get current user
  final User _currentUser = PlaceholderData.getCurrentUser();

  // All chats
  final List<Chat> _chats =
      PlaceholderData.getRandomChats(20, currentUserId: 'current_user');

  // Getter for current user
  User get currentUser => _currentUser;

  // Getter for all chats
  List<Chat> get chats => _chats;

  // Get a specific chat by user ID
  Chat? getChatByUserId(String userId) {
    try {
      return _chats.firstWhere((chat) => chat.user.id == userId);
    } catch (e) {
      return null;
    }
  }

  // Send a new message to a chat
  void sendMessage(String userId, String content) {
    final chatIndex = _chats.indexWhere((chat) => chat.user.id == userId);

    if (chatIndex == -1) return;

    final chat = _chats[chatIndex];
    final newMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: _currentUser.id,
      receiverId: userId,
      content: content,
      timestamp: DateTime.now(),
      isRead: false,
      type: MessageType.text,
    );

    final updatedMessages = List<Message>.from(chat.messages)..add(newMessage);

    _chats[chatIndex] = Chat(
      user: chat.user,
      messages: updatedMessages,
      lastMessageTime: DateTime.now(),
      hasUnreadMessages: false, // Since the current user sent it
    );

    notifyListeners();
  }

  // Mark all messages in a chat as read
  void markChatAsRead(String userId) {
    final chatIndex = _chats.indexWhere((chat) => chat.user.id == userId);

    if (chatIndex == -1) return;

    final chat = _chats[chatIndex];

    // Update messages that are from the other user and unread
    final updatedMessages = chat.messages.map((message) {
      if (message.senderId == userId && !message.isRead) {
        return Message(
          id: message.id,
          senderId: message.senderId,
          receiverId: message.receiverId,
          content: message.content,
          timestamp: message.timestamp,
          isRead: true,
          type: message.type,
        );
      }
      return message;
    }).toList();

    _chats[chatIndex] = Chat(
      user: chat.user,
      messages: updatedMessages,
      lastMessageTime: chat.lastMessageTime,
      hasUnreadMessages: false,
    );

    notifyListeners();
  }

  // Get unread message count
  int getUnreadCount() {
    return _chats.where((chat) => chat.hasUnreadMessages).length;
  }
}
