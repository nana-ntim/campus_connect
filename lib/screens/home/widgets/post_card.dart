// screens/home/widgets/post_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_connect/config/theme.dart';
import 'package:campus_connect/models/post_model.dart';
import 'package:campus_connect/providers/feed_provider.dart';
import 'package:campus_connect/screens/profile/profile_screen.dart';
import 'package:campus_connect/widgets/loading_indicator.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildImage(context),
          _buildActions(context),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  CachedNetworkImageProvider(post.user.profileImage),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToProfile(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        post.user.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (post.user.isVerified)
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
                    _getTimeAgo(post.createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            iconSize: 20,
            onPressed: () {
              // Show post options
              _showPostOptions(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        // Double tap to like
        if (!post.isLiked) {
          Provider.of<FeedProvider>(context, listen: false).toggleLike(post.id);
        }
      },
      child: CachedNetworkImage(
        imageUrl: post.imageUrl,
        placeholder: (context, url) => const ShimmerLoadingCard(height: 300),
        errorWidget: (context, url, error) => Container(
          height: 300,
          color: Colors.grey[200],
          child: const Center(
            child: Icon(Icons.error_outline, color: Colors.grey),
          ),
        ),
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => feedProvider.toggleLike(post.id),
            child: Icon(
              post.isLiked
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              size: 22,
              color: post.isLiked ? Colors.red : null,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              // Show comments
            },
            child: const Icon(
              FontAwesomeIcons.comment,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              // Share post
            },
            child: const Icon(
              FontAwesomeIcons.paperPlane,
              size: 22,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => feedProvider.toggleBookmark(post.id),
            child: Icon(
              post.isBookmarked
                  ? FontAwesomeIcons.solidBookmark
                  : FontAwesomeIcons.bookmark,
              size: 22,
              color: post.isBookmarked ? AppTheme.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Likes count
          Text(
            '${post.likes.toString()} likes',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),

          // Caption with username
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: post.user.username + ' ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: post.caption,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Hashtags
          if (post.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 4,
                children: post.tags
                    .map((tag) => Text(
                          '#$tag',
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                          ),
                        ))
                    .toList(),
              ),
            ),

          // View all comments
          if (post.comments > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
                onTap: () {
                  // Show comments
                },
                child: Text(
                  'View all ${post.comments} comments',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(userId: post.user.id),
      ),
    );
  }

  void _showPostOptions(BuildContext context) {
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
                  leading: const Icon(Icons.save_alt),
                  title: const Text('Save'),
                  onTap: () {
                    Navigator.pop(context);
                    final feedProvider =
                        Provider.of<FeedProvider>(context, listen: false);
                    if (!post.isBookmarked) {
                      feedProvider.toggleBookmark(post.id);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add_outlined),
                  title: const Text('Follow'),
                  onTap: () {
                    Navigator.pop(context);
                    // Follow user
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () {
                    Navigator.pop(context);
                    // Share post
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.report_outlined),
                  title: const Text('Report'),
                  onTap: () {
                    Navigator.pop(context);
                    // Report post
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
