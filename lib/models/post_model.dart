import 'package:campus_connect/models/user_model.dart';

class Post {
  final String id;
  final User user;
  final String imageUrl;
  final String caption;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final List<String> tags;
  final bool isLiked;
  final bool isBookmarked;

  Post({
    required this.id,
    required this.user,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.tags,
    this.isLiked = false,
    this.isBookmarked = false,
  });
}
