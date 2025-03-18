import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_connect/config/theme.dart';
import 'package:campus_connect/providers/message_provider.dart';
import 'package:campus_connect/screens/messages/chat_screen.dart';
import 'package:campus_connect/screens/messages/widgets/chat_list_tile.dart';
import 'package:campus_connect/widgets/app_bar.dart';
import 'package:campus_connect/widgets/loading_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'Messages',
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.penToSquare, size: 20),
            onPressed: () {
              // Navigate to new message screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar when searching is active
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

          // Chat list
          Expanded(
            child: Consumer<MessageProvider>(
              builder: (context, messageProvider, child) {
                final chats = messageProvider.chats;

                // Filter chats by search query if searching
                final filteredChats = _searchQuery.isEmpty
                    ? chats
                    : chats.where((chat) {
                        return chat.user.username
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()) ||
                            chat.user.fullName
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase());
                      }).toList();

                if (chats.isEmpty) {
                  return const Center(
                    child: LoadingIndicator(),
                  );
                }

                if (filteredChats.isEmpty) {
                  return Center(
                    child: Text(
                      'No conversations found matching "$_searchQuery"',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // Sort chats by last message time
                filteredChats.sort(
                    (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: filteredChats.length,
                  itemBuilder: (context, index) {
                    final chat = filteredChats[index];
                    return ChatListTile(
                      chat: chat,
                      onTap: () {
                        // Navigate to chat screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatScreen(userId: chat.user.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
