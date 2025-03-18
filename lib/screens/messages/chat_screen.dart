import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_connect/config/theme.dart';
import 'package:campus_connect/models/user_model.dart';
import 'package:campus_connect/providers/message_provider.dart';
import 'package:campus_connect/screens/messages/widgets/chat_bubble.dart';
import 'package:campus_connect/screens/profile/profile_screen.dart';
import 'package:campus_connect/widgets/loading_indicator.dart';

class ChatScreen extends StatefulWidget {
  final String userId;

  const ChatScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showAttachmentOptions = false;

  @override
  void initState() {
    super.initState();
    // Mark messages as read when opening the chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessageProvider>(context, listen: false)
          .markChatAsRead(widget.userId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    Provider.of<MessageProvider>(context, listen: false)
        .sendMessage(widget.userId, text);

    _messageController.clear();

    // Scroll to the bottom after sending a message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildChatAppBar(),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          final chat = messageProvider.getChatByUserId(widget.userId);

          if (chat == null) {
            return const Center(
              child: LoadingIndicator(),
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          return Column(
            children: [
              // Chat messages
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Dismiss attachment options when tapping outside
                    if (_showAttachmentOptions) {
                      setState(() {
                        _showAttachmentOptions = false;
                      });
                    }
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chat.messages.length,
                    itemBuilder: (context, index) {
                      final message = chat.messages[index];
                      final bool isMe =
                          message.senderId == messageProvider.currentUser.id;

                      return ChatBubble(
                        message: message,
                        isMe: isMe,
                        showAvatar: !isMe &&
                            (index == 0 ||
                                chat.messages[index - 1].senderId !=
                                    message.senderId),
                        userImage: chat.user.profileImage,
                      );
                    },
                  ),
                ),
              ),

              // Attachment options
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _showAttachmentOptions ? 120 : 0,
                color: Colors.white,
                child: _showAttachmentOptions
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildAttachmentOption(
                              icon: Icons.photo_library,
                              label: 'Gallery',
                              color: Colors.purple,
                              onTap: () {
                                // Handle gallery
                                setState(() {
                                  _showAttachmentOptions = false;
                                });
                              },
                            ),
                            _buildAttachmentOption(
                              icon: Icons.camera_alt,
                              label: 'Camera',
                              color: Colors.blue,
                              onTap: () {
                                // Handle camera
                                setState(() {
                                  _showAttachmentOptions = false;
                                });
                              },
                            ),
                            _buildAttachmentOption(
                              icon: Icons.insert_drive_file,
                              label: 'Document',
                              color: Colors.orange,
                              onTap: () {
                                // Handle document
                                setState(() {
                                  _showAttachmentOptions = false;
                                });
                              },
                            ),
                            _buildAttachmentOption(
                              icon: Icons.location_on,
                              label: 'Location',
                              color: Colors.green,
                              onTap: () {
                                // Handle location
                                setState(() {
                                  _showAttachmentOptions = false;
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    : null,
              ),

              // Message input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      // Attachment button
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: _showAttachmentOptions
                              ? AppTheme.primaryColor
                              : Colors.grey[600],
                          size: 28,
                        ),
                        onPressed: () {
                          setState(() {
                            _showAttachmentOptions = !_showAttachmentOptions;
                          });
                        },
                      ),

                      // Text input
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Message...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            onTap: () {
                              if (_showAttachmentOptions) {
                                setState(() {
                                  _showAttachmentOptions = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      // Send button
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildChatAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          final chat = messageProvider.getChatByUserId(widget.userId);

          if (chat == null) {
            return AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Chat'),
            );
          }

          return AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userId: chat.user.id),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        CachedNetworkImageProvider(chat.user.profileImage),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          chat.user.username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _getOnlineStatus(chat.user),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.phone, size: 22),
                onPressed: () {
                  // Handle voice call
                },
              ),
              IconButton(
                icon: const Icon(Icons.videocam, size: 22),
                onPressed: () {
                  // Handle video call
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 22),
                onPressed: () {
                  _showChatOptions(context, chat.user);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  String _getOnlineStatus(User user) {
    // In a real app, this would check the actual online status
    // For this demo, we'll randomly show some users as online
    final isOnline = user.id.hashCode % 3 == 0;
    return isOnline ? 'Online' : 'Last seen recently';
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showChatOptions(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('View Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userId: user.id),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Search in Conversation'),
                  onTap: () {
                    Navigator.pop(context);
                    // Search in conversation
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_off),
                  title: const Text('Mute Notifications'),
                  onTap: () {
                    Navigator.pop(context);
                    // Mute notifications
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.red),
                  title: const Text(
                    'Block User',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Block user
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
