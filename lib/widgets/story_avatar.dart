import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/story_model.dart';
import '../screens/story_screen.dart';

class StoryAvatar extends StatelessWidget {
  final StoryModel story;
  final double size;
  final bool isCurrentUser;

  const StoryAvatar({
    super.key,
    required this.story,
    this.size = 60.0,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasUnviewedStories = !story.isFullyViewed();
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => StoryScreen(story: story),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            margin: const EdgeInsets.all(4),
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
            child: CircleAvatar(
              backgroundImage: NetworkImage(story.user.avatarUrl),
              radius: size / 2 - 4,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: size + 10,
            child: Text(
              isCurrentUser ? 'Your Story' : story.user.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: hasUnviewedStories ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0);
  }
}

class AddStoryButton extends StatelessWidget {
  final double size;
  final VoidCallback onTap;

  const AddStoryButton({
    super.key,
    this.size = 60.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: size + 10,
            child: const Text(
              'Add Story',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}