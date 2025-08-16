import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/story_model.dart';
import '../models/mock_data.dart';

class StoryCircle extends StatelessWidget {
  final StoryModel story;
  final double radius;
  final VoidCallback onTap;

  const StoryCircle({
    super.key,
    required this.story,
    this.radius = 30.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasUnviewedStories = !story.isFullyViewed();
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: hasUnviewedStories
              ? const LinearGradient(
                  colors: [
                    Colors.purple,
                    Colors.pink,
                    Colors.orange,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: !hasUnviewedStories
              ? Border.all(color: Colors.grey.withOpacity(0.5), width: 2)
              : null,
        ),
        padding: const EdgeInsets.all(2),
        child: story.user.avatarUrl == defaultAvatarPath
          ? CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: radius - 2,
              child: SvgPicture.asset(
                defaultAvatarPath,
                width: (radius - 2) * 2,
                height: (radius - 2) * 2,
              ),
            )
          : CircleAvatar(
              backgroundImage: NetworkImage(story.user.avatarUrl),
              radius: radius - 2,
            ),
      ),
    );
  }
}