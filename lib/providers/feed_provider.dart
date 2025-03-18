import 'package:flutter/foundation.dart';
import 'package:campus_connect/models/post_model.dart';
import 'package:campus_connect/utils/placeholder_data.dart';

class FeedProvider with ChangeNotifier {
  // All available posts (simulating backend)
  final List<Post> _allPosts = PlaceholderData.getRandomPosts(30);

  // Posts currently loaded in the feed
  final List<Post> _posts = [];

  // Current page for pagination
  int _currentPage = 0;

  // Posts per page
  final int _postsPerPage = 5;

  // Loading state
  bool _isLoading = false;

  // Getter for posts
  List<Post> get posts => _posts;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Getter to check if there are more posts
  bool get hasMore => _currentPage * _postsPerPage < _allPosts.length;

  // Constructor that loads initial page
  FeedProvider() {
    loadMorePosts();
  }

  // Load more posts with pagination
  Future<void> loadMorePosts() async {
    if (_isLoading || !hasMore) return;

    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final startIndex = _currentPage * _postsPerPage;
    final endIndex = startIndex + _postsPerPage;
    final nextPosts = _allPosts.sublist(
        startIndex, endIndex > _allPosts.length ? _allPosts.length : endIndex);

    _posts.addAll(nextPosts);
    _currentPage++;
    _isLoading = false;
    notifyListeners();
  }

  // Refresh feed (reload from the beginning)
  Future<void> refreshFeed() async {
    _isLoading = true;
    _posts.clear();
    _currentPage = 0;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    await loadMorePosts();
  }

  // Toggle like on a post
  void toggleLike(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedPost = Post(
        id: post.id,
        user: post.user,
        imageUrl: post.imageUrl,
        caption: post.caption,
        createdAt: post.createdAt,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        comments: post.comments,
        tags: post.tags,
        isLiked: !post.isLiked,
        isBookmarked: post.isBookmarked,
      );

      _posts[postIndex] = updatedPost;

      // Also update in allPosts
      final allPostIndex = _allPosts.indexWhere((post) => post.id == postId);
      if (allPostIndex != -1) {
        _allPosts[allPostIndex] = updatedPost;
      }

      notifyListeners();
    }
  }

  // Toggle bookmark on a post
  void toggleBookmark(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedPost = Post(
        id: post.id,
        user: post.user,
        imageUrl: post.imageUrl,
        caption: post.caption,
        createdAt: post.createdAt,
        likes: post.likes,
        comments: post.comments,
        tags: post.tags,
        isLiked: post.isLiked,
        isBookmarked: !post.isBookmarked,
      );

      _posts[postIndex] = updatedPost;

      // Also update in allPosts
      final allPostIndex = _allPosts.indexWhere((post) => post.id == postId);
      if (allPostIndex != -1) {
        _allPosts[allPostIndex] = updatedPost;
      }

      notifyListeners();
    }
  }

  // Get user's posts
  List<Post> getUserPosts(String userId) {
    return _allPosts.where((post) => post.user.id == userId).toList();
  }
}
