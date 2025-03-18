import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:campus_connect/config/theme.dart';
import 'package:campus_connect/models/user_model.dart';
import 'package:campus_connect/models/post_model.dart';
import 'package:campus_connect/providers/feed_provider.dart';
import 'package:campus_connect/screens/profile/widgets/profile_header.dart';
import 'package:campus_connect/screens/profile/widgets/profile_post_grid.dart';
import 'package:campus_connect/utils/placeholder_data.dart';
import 'package:campus_connect/widgets/app_bar.dart';
import 'package:campus_connect/widgets/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({Key? key, this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late User _user;
  late List<Post> _userPosts;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        // If userId is not provided, show current user profile
        if (widget.userId == null || widget.userId == 'current_user') {
          _user = PlaceholderData.getCurrentUser();
        } else {
          // Find user by id from generated users
          // In a real app, this would be an API call
          _user = PlaceholderData.getRandomUser(id: widget.userId);
        }

        // Get posts by user
        _userPosts = Provider.of<FeedProvider>(context, listen: false)
            .getUserPosts(_user.id);

        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrentUser = widget.userId == null ||
        widget.userId == 'current_user' ||
        widget.userId == PlaceholderData.getCurrentUser().id;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: _isLoading ? 'Profile' : _user.username,
        centerTitle: true,
        showBackButton: !isCurrentUser,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.ellipsisVertical, size: 20),
            onPressed: () {
              // Show profile options
              _showProfileOptions(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: ProfileHeader(
                      user: _user,
                      isCurrentUser: isCurrentUser,
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        labelColor: AppTheme.primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppTheme.primaryColor,
                        indicatorWeight: 2,
                        tabs: const [
                          Tab(icon: Icon(Icons.grid_on, size: 24)),
                          Tab(icon: Icon(FontAwesomeIcons.bookmark, size: 20)),
                          Tab(icon: Icon(FontAwesomeIcons.tag, size: 20)),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  // Posts grid
                  ProfilePostGrid(posts: _userPosts),
                  // Saved posts (empty placeholder)
                  const Center(
                    child: Text(
                      'No saved posts yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  // Tagged posts (empty placeholder)
                  const Center(
                    child: Text(
                      'No tagged posts',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showProfileOptions(BuildContext context) {
    final bool isCurrentUser = widget.userId == null ||
        widget.userId == 'current_user' ||
        widget.userId == PlaceholderData.getCurrentUser().id;

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
              children: isCurrentUser
                  ? [
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to settings
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.bookmark_border),
                        title: const Text('Saved'),
                        onTap: () {
                          Navigator.pop(context);
                          _tabController.animateTo(1);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: const Text('Your Activity'),
                        onTap: () {
                          Navigator.pop(context);
                          // Show activity
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.qr_code),
                        title: const Text('QR Code'),
                        onTap: () {
                          Navigator.pop(context);
                          // Show QR code
                        },
                      ),
                    ]
                  : [
                      ListTile(
                        leading: const Icon(Icons.person_add_outlined),
                        title: const Text('Follow'),
                        onTap: () {
                          Navigator.pop(context);
                          // Follow user
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.message_outlined),
                        title: const Text('Message'),
                        onTap: () {
                          Navigator.pop(context);
                          // Message user
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text('Share Profile'),
                        onTap: () {
                          Navigator.pop(context);
                          // Share profile
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.block),
                        title: const Text('Block'),
                        onTap: () {
                          Navigator.pop(context);
                          // Block user
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.report_outlined),
                        title: const Text('Report'),
                        onTap: () {
                          Navigator.pop(context);
                          // Report user
                        },
                      ),
                    ],
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
