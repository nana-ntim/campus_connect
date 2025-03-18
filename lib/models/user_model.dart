class User {
  final String id;
  final String username;
  final String fullName;
  final String profileImage;
  final String bio;
  final int followers;
  final int following;
  final int posts;
  final bool isVerified;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profileImage,
    required this.bio,
    required this.followers,
    required this.following,
    required this.posts,
    this.isVerified = false,
  });
}
