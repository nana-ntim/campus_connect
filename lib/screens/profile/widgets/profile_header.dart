// screens/profile/widgets/profile_header.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_connect/config/theme.dart';
import 'package:campus_connect/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  final bool isCurrentUser;

  const ProfileHeader({
    Key? key,
    required this.user,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileInfo(),
          const SizedBox(height: 16),
          _buildBioSection(),
          const SizedBox(height: 16),
          _buildActionButtons(context),
          const SizedBox(height: 16),
          _buildHighlights(),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile picture
        Container(
          height: 86,
          width: 86,
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.storyGradient,
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.profileImage),
            ),
          ),
        ),
        const SizedBox(width: 24),

        // Stats
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(user.posts, 'Posts'),
              _buildStatColumn(user.followers, 'Followers'),
              _buildStatColumn(user.following, 'Following'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(int count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and verified badge
        Row(
          children: [
            Text(
              user.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (user.isVerified)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.verified,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),

        // Bio
        Text(
          user.bio,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Primary action
              if (isCurrentUser) {
                // Edit profile
              } else {
                // Follow/Unfollow
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: isCurrentUser ? Colors.black : Colors.white,
              backgroundColor:
                  isCurrentUser ? Colors.grey[200] : AppTheme.primaryColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isCurrentUser ? 'Edit Profile' : 'Follow',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        if (!isCurrentUser) ...[
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // Message
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey[200],
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Message',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
        const SizedBox(width: 8),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
            ),
            onPressed: () {
              // Show more options
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  Widget _buildHighlights() {
    // Generate some placeholder highlight categories
    final highlights = [
      {'name': 'Campus', 'icon': Icons.school},
      {'name': 'Events', 'icon': Icons.event},
      {'name': 'Friends', 'icon': Icons.people},
      {'name': 'Sports', 'icon': Icons.sports_basketball},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Highlights',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: highlights.length + (isCurrentUser ? 1 : 0),
            itemBuilder: (context, index) {
              if (isCurrentUser && index == 0) {
                // Add new highlight button (only for current user)
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'New',
                        style: TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }

              final highlight = highlights[isCurrentUser ? index - 1 : index];

              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        highlight['icon'] as IconData,
                        size: 30,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      highlight['name'] as String,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
