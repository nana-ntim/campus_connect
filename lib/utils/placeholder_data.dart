import 'dart:math';
import 'package:campus_connect/models/user_model.dart';
import 'package:campus_connect/models/post_model.dart';
import 'package:campus_connect/models/message_model.dart';

class PlaceholderData {
  static final Random _random = Random();

  // List of placeholder profile images
  static const List<String> _profileImages = [
    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1527980965255-d3b416303d12?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=300&q=80',
  ];

  // List of placeholder post images
  static const List<String> _postImages = [
    'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1519070994522-88c6b756330e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1523240795612-9a054b0db644?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1627556704290-2b1f5853ff78?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1606761568499-6d2451b23c66?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1519070994522-88c6b756330e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80',
  ];

  // List of university names
  static const List<String> _universities = [
    'Harvard University',
    'Stanford University',
    'MIT',
    'Princeton University',
    'Yale University',
    'University of Cambridge',
    'University of Oxford',
    'UC Berkeley',
  ];

  // List of possible captions
  static const List<String> _captions = [
    'Just another day on campus! #campuslife',
    'Study session at the library 📚',
    'Coffee break between classes ☕',
    'Made new friends in the lecture today!',
    'Campus views are amazing today 😍',
    'Working on this group project. Wish us luck!',
    'Late night study sessions are becoming a habit.',
    'Finally finished that assignment! Time to relax.',
    'Spring break plans, anyone?',
    'Celebrate small victories. Passed my midterm! 🎉',
  ];

  // List of hashtags
  static const List<String> _hashtags = [
    'campuslife',
    'studentlife',
    'university',
    'college',
    'study',
    'academics',
    'dormlife',
    'fratlife',
    'sororitylife',
    'freshman',
    'sophomore',
    'junior',
    'senior',
    'gradlife',
    'finals'
  ];

  // Generate a random user
  static User getRandomUser({String? id}) {
    final userId = id ?? 'user_${_random.nextInt(1000)}';
    final username = 'user_${_random.nextInt(1000)}';
    final firstName = [
      'Alex',
      'Jamie',
      'Jordan',
      'Taylor',
      'Casey',
      'Riley'
    ][_random.nextInt(6)];
    final lastName = [
      'Smith',
      'Johnson',
      'Williams',
      'Brown',
      'Jones',
      'Garcia'
    ][_random.nextInt(6)];
    final fullName = '$firstName $lastName';
    final profileImage = _profileImages[_random.nextInt(_profileImages.length)];
    final university = _universities[_random.nextInt(_universities.length)];
    final bio = 'Student at $university | ${[
      'Computer Science',
      'Business',
      'Engineering',
      'Medicine',
      'Arts'
    ][_random.nextInt(5)]} major';
    final followers = _random.nextInt(1000) + 100;
    final following = _random.nextInt(500) + 50;
    final posts = _random.nextInt(30) + 5;
    final isVerified = _random.nextBool() && _random.nextBool(); // 25% chance

    return User(
      id: userId,
      username: username,
      fullName: fullName,
      profileImage: profileImage,
      bio: bio,
      followers: followers,
      following: following,
      posts: posts,
      isVerified: isVerified,
    );
  }

  // Generate a list of random users
  static List<User> getRandomUsers(int count) {
    return List.generate(count, (index) => getRandomUser(id: 'user_$index'));
  }

  // Generate random post
  static Post getRandomPost({String? id, User? user}) {
    final postId = id ?? 'post_${_random.nextInt(1000)}';
    final postUser = user ?? getRandomUser();
    final imageUrl = _postImages[_random.nextInt(_postImages.length)];
    final caption = _captions[_random.nextInt(_captions.length)];
    final createdAt = DateTime.now().subtract(
        Duration(days: _random.nextInt(30), hours: _random.nextInt(24)));
    final likes = _random.nextInt(200) + 10;
    final comments = _random.nextInt(50);
    final tags = List.generate(_random.nextInt(4) + 1,
        (index) => _hashtags[_random.nextInt(_hashtags.length)]);

    return Post(
      id: postId,
      user: postUser,
      imageUrl: imageUrl,
      caption: caption,
      createdAt: createdAt,
      likes: likes,
      comments: comments,
      tags: tags,
      isLiked: _random.nextBool(),
      isBookmarked: _random.nextBool(),
    );
  }

  // Generate a list of random posts
  static List<Post> getRandomPosts(int count, {User? user}) {
    return List.generate(
        count, (index) => getRandomPost(id: 'post_$index', user: user));
  }

  // Generate random message
  static Message getRandomMessage({
    required String senderId,
    required String receiverId,
    DateTime? timestamp,
  }) {
    final messageId = 'msg_${_random.nextInt(10000)}';
    final messageContent = [
      'Hey, how are you?',
      'Did you finish the assignment?',
      'Want to grab coffee later?',
      'Have you seen the latest lecture notes?',
      'Are you going to the event tomorrow?',
      'Can we schedule a study session?',
      'Thanks for your help!',
      'Sorry, I was busy. Let\'s catch up later!',
      'Did you understand what the professor said?',
      'I\'m heading to the library, want to join?',
    ][_random.nextInt(10)];

    final messageTimestamp = timestamp ??
        DateTime.now().subtract(Duration(
            days: _random.nextInt(7),
            hours: _random.nextInt(24),
            minutes: _random.nextInt(60)));

    return Message(
      id: messageId,
      senderId: senderId,
      receiverId: receiverId,
      content: messageContent,
      timestamp: messageTimestamp,
      isRead: _random.nextBool(),
      type: MessageType.text,
    );
  }

  // Generate a random chat with messages
  static Chat getRandomChat({User? user, String? currentUserId}) {
    final chatUser = user ?? getRandomUser();
    final userId = currentUserId ?? 'current_user';

    // Generate between 1 and 15 messages for this chat
    final messageCount = _random.nextInt(15) + 1;
    final messages = <Message>[];

    // Start with the oldest message (up to 7 days ago)
    var lastTimestamp =
        DateTime.now().subtract(Duration(days: _random.nextInt(7)));

    for (int i = 0; i < messageCount; i++) {
      // Determine sender (50% chance of being the current user)
      final sender = _random.nextBool() ? userId : chatUser.id;
      final receiver = sender == userId ? chatUser.id : userId;

      // Add a random time increment between messages (0-120 minutes)
      lastTimestamp =
          lastTimestamp.add(Duration(minutes: _random.nextInt(120)));

      messages.add(getRandomMessage(
        senderId: sender,
        receiverId: receiver,
        timestamp: lastTimestamp,
      ));
    }

    // Sort messages by timestamp
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Determine if there are unread messages (only from the other user to the current user)
    final hasUnread = messages
        .where((msg) => msg.senderId == chatUser.id && msg.receiverId == userId)
        .any((msg) => !msg.isRead);

    return Chat(
      user: chatUser,
      messages: messages,
      lastMessageTime: messages.isNotEmpty
          ? messages.last.timestamp
          : DateTime.now().subtract(const Duration(days: 1)),
      hasUnreadMessages: hasUnread,
    );
  }

  // Generate a list of random chats
  static List<Chat> getRandomChats(int count, {String? currentUserId}) {
    final users = getRandomUsers(count);
    return users
        .map((user) => getRandomChat(
              user: user,
              currentUserId: currentUserId ?? 'current_user',
            ))
        .toList();
  }

  // Get a fixed current user for the app
  static User getCurrentUser() {
    return User(
      id: 'current_user',
      username: 'campus_explorer',
      fullName: 'Alex Johnson',
      profileImage:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=300&q=80',
      bio:
          'Computer Science student at MIT | Class of 2025 | Coffee addict | Coding enthusiast',
      followers: 458,
      following: 312,
      posts: 27,
      isVerified: true,
    );
  }
}
