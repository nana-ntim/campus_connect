class Constants {
  // App information
  static const String appName = 'CampusConnect';
  static const String appVersion = '1.0.0';

  // API URLs (for future integration)
  static const String baseApiUrl = 'https://api.campusconnect.com';
  static const String apiVersion = 'v1';

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String feedEndpoint = '/feed';
  static const String usersEndpoint = '/users';
  static const String messagesEndpoint = '/messages';

  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String rememberMeKey = 'remember_me';

  // Assets paths
  static const String placeholderAvatarPath =
      'assets/images/placeholder_avatar.png';
  static const String appLogoPath = 'assets/icons/app_icon.png';

  // Error messages
  static const String networkErrorMessage =
      'Network error. Please check your internet connection.';
  static const String generalErrorMessage =
      'Something went wrong. Please try again.';
  static const String authErrorMessage =
      'Authentication failed. Please check your credentials.';

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration normalAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
