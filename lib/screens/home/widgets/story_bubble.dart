// screens/home/widgets/story_bubble.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_connect/config/theme.dart';
import 'package:campus_connect/models/user_model.dart';

class StoryBubble extends StatelessWidget {
  final User user;
  final bool isCurrentUser;
  final bool hasSeen;

  const StoryBubble({
    Key? key,
    required this.user,
    this.isCurrentUser = false,
    this.hasSeen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          // Story circle
          Container(
            height: 68,
            width: 68,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: !hasSeen ? AppTheme.storyGradient : null,
              color: hasSeen ? Colors.grey[300] : null,
            ),
            padding: const EdgeInsets.all(3), // Border width
            child: Container(
              padding: const EdgeInsets.all(2), // Gap between border and avatar
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: isCurrentUser
                  ? _buildCurrentUserStory()
                  : _buildOtherUserStory(),
            ),
          ),

          // Username
          Text(
            isCurrentUser ? 'Your Story' : user.username,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: hasSeen ? Colors.grey : Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserStory() {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(user.profileImage),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              height: 24,
              width: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherUserStory() {
    return CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(user.profileImage),
    );
  }
}
