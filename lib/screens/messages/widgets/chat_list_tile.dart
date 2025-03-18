// screens/messages/widgets/chat_list_tile.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_connect/config/theme.dart';
import 'package:campus_connect/models/message_model.dart';

class ChatListTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatListTile({
    Key? key,
    required this.chat,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastMessage = chat.messages.isNotEmpty ? chat.messages.last : null;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // User avatar with online indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        CachedNetworkImageProvider(chat.user.profileImage),
                  ),

                  // Online indicator (randomly assigned based on user ID)
                  if (chat.user.id.hashCode % 3 == 0)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Chat info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username and time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              chat.user.username,
                              style: TextStyle(
                                fontWeight: chat.hasUnreadMessages
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            if (chat.user.isVerified)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          _formatTime(
                              lastMessage?.timestamp ?? chat.lastMessageTime),
                          style: TextStyle(
                            color: chat.hasUnreadMessages
                                ? AppTheme.primaryColor
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Last message and unread indicator
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage != null
                                ? _getLastMessagePreview(lastMessage)
                                : 'Start chatting',
                            style: TextStyle(
                              color: chat.hasUnreadMessages
                                  ? Colors.black
                                  : Colors.grey[600],
                              fontSize: 14,
                              fontWeight: chat.hasUnreadMessages
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Unread indicator
                        if (chat.hasUnreadMessages)
                          Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLastMessagePreview(Message message) {
    switch (message.type) {
      case MessageType.image:
        return '📷 Photo';
      case MessageType.file:
        return '📎 File';
      case MessageType.text:
      default:
        return message.content;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      // Format as date for older messages
      return '${dateTime.month}/${dateTime.day}';
    } else if (difference.inDays >= 1) {
      // Show day of week for messages within the last week
      final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final dayOfWeek = dayNames[dateTime.weekday - 1];
      return dayOfWeek;
    } else {
      // Show time for today's messages
      final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour < 12 ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }
  }
}
