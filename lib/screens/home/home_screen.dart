import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:campus_connect/config/theme.dart';
import 'package:campus_connect/providers/feed_provider.dart';
import 'package:campus_connect/screens/home/widgets/post_card.dart';
import 'package:campus_connect/screens/home/widgets/story_bubble.dart';
import 'package:campus_connect/widgets/app_bar.dart';
import 'package:campus_connect/widgets/loading_indicator.dart';
import 'package:campus_connect/utils/placeholder_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Provider.of<FeedProvider>(context, listen: false).refreshFeed();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Provider.of<FeedProvider>(context, listen: false).loadMorePosts();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'CampusConnect',
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.paperPlane, size: 20),
            onPressed: () {
              // Navigate to direct messages
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Placeholder(),
                ),
              );
            },
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(
          waterDropColor: AppTheme.primaryColor,
          complete: Icon(Icons.check, color: AppTheme.primaryColor),
        ),
        footer: CustomFooter(
          builder: (context, mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("Pull up to load more");
            } else if (mode == LoadStatus.loading) {
              body = const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.primaryColor,
              );
            } else if (mode == LoadStatus.failed) {
              body = const Text("Failed to load. Tap to retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("Release to load more");
            } else {
              body = const Text("No more posts");
            }
            return SizedBox(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Consumer<FeedProvider>(
          builder: (context, feedProvider, child) {
            return CustomScrollView(
              slivers: [
                // Stories section
                SliverToBoxAdapter(
                  child: _buildStoriesSection(),
                ),

                // Posts section
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  sliver: feedProvider.posts.isEmpty && feedProvider.isLoading
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => const PostShimmerLoading(),
                            childCount: 3,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index < feedProvider.posts.length) {
                                return PostCard(
                                    post: feedProvider.posts[index]);
                              } else if (feedProvider.hasMore) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                            childCount: feedProvider.posts.length +
                                (feedProvider.hasMore ? 1 : 0),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStoriesSection() {
    // Generate random users for stories
    final storyUsers = PlaceholderData.getRandomUsers(10);

    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: storyUsers.length + 1, // +1 for current user
        itemBuilder: (context, index) {
          if (index == 0) {
            // Current user's story (add option)
            return StoryBubble(
              user: PlaceholderData.getCurrentUser(),
              isCurrentUser: true,
            );
          } else {
            // Other users' stories
            return StoryBubble(user: storyUsers[index - 1]);
          }
        },
      ),
    );
  }
}
