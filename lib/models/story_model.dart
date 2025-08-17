import 'package:uuid/uuid.dart';
import 'user_model.dart';

enum StoryType { image, video, text }

class StoryItem {
  final String id;
  final String content;
  final StoryType type;
  final DateTime timestamp;
  final Duration duration;
  final List<String> viewedBy;

  StoryItem({
    String? id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.duration = const Duration(seconds: 5),
    this.viewedBy = const [],
  }) : id = id ?? const Uuid().v4();

  bool isViewedBy(String userId) => viewedBy.contains(userId);
}

class StoryModel {
  final String id;
  final UserModel user;
  final List<StoryItem> items;
  final DateTime lastUpdated;

  StoryModel({
    String? id,
    required this.user,
    required this.items,
    required this.lastUpdated,
  }) : id = id ?? const Uuid().v4();


  
  bool isFullyViewed() {
    // Consider a story fully viewed if all items have been viewed by the current user
    return items.every((item) => item.isViewedBy('currentUserId'));
  }


}