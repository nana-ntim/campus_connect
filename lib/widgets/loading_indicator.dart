// widgets/loading_indicator.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:campus_connect/config/theme.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppTheme.primaryColor,
        strokeWidth: 3,
      ),
    );
  }
}

class ShimmerLoadingCard extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerLoadingCard({
    Key? key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class PostShimmerLoading extends StatelessWidget {
  const PostShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar and name
              Row(
                children: [
                  const ShimmerLoadingCard(
                    height: 40,
                    width: 40,
                    borderRadius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerLoadingCard(height: 14, width: 120),
                        const SizedBox(height: 4),
                        const ShimmerLoadingCard(height: 10, width: 80),
                      ],
                    ),
                  ),
                  const ShimmerLoadingCard(height: 20, width: 20),
                ],
              ),
              const SizedBox(height: 12),
              // Post image
              const ShimmerLoadingCard(height: 300),
              const SizedBox(height: 12),
              // Action buttons
              Row(
                children: [
                  const ShimmerLoadingCard(height: 20, width: 20),
                  const SizedBox(width: 16),
                  const ShimmerLoadingCard(height: 20, width: 20),
                  const SizedBox(width: 16),
                  const ShimmerLoadingCard(height: 20, width: 20),
                  const Spacer(),
                  const ShimmerLoadingCard(height: 20, width: 20),
                ],
              ),
              const SizedBox(height: 12),
              // Likes count
              const ShimmerLoadingCard(height: 14, width: 100),
              const SizedBox(height: 8),
              // Caption
              const ShimmerLoadingCard(height: 12, width: double.infinity),
              const SizedBox(height: 4),
              const ShimmerLoadingCard(height: 12, width: 200),
              const SizedBox(height: 8),
              // Comments
              const ShimmerLoadingCard(height: 12, width: 150),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatShimmerLoading extends StatelessWidget {
  const ChatShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const ShimmerLoadingCard(
            height: 56,
            width: 56,
            borderRadius: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerLoadingCard(height: 16, width: 120),
                const SizedBox(height: 8),
                const ShimmerLoadingCard(height: 12, width: 200),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const ShimmerLoadingCard(height: 12, width: 50),
              const SizedBox(height: 8),
              const ShimmerLoadingCard(
                height: 16,
                width: 16,
                borderRadius: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
