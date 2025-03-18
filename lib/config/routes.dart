import 'package:flutter/material.dart';
import 'package:campus_connect/screens/home/home_screen.dart';
import 'package:campus_connect/screens/profile/profile_screen.dart';
import 'package:campus_connect/screens/messages/chat_list_screen.dart';
import 'package:campus_connect/screens/messages/chat_screen.dart';

class Routes {
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String chatList = '/chat-list';
  static const String chat = '/chat';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case profile:
        final String? userId = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId));

      case chatList:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());

      case chat:
        final String userId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ChatScreen(userId: userId));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
