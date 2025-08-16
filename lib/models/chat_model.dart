import 'message_model.dart';
import 'user_model.dart';

class ChatModel {
  final String id;
  final UserModel contact;
  final MessageModel lastMessage;
  final int unreadCount;
  final bool isMuted;
  final bool isPinned;
  final DateTime lastUpdated;

  ChatModel({
    required this.id,
    required this.contact,
    required this.lastMessage,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
    required this.lastUpdated,
  });

  ChatModel copyWith({
    String? id,
    UserModel? contact,
    MessageModel? lastMessage,
    int? unreadCount,
    bool? isMuted,
    bool? isPinned,
    DateTime? lastUpdated,
  }) {
    return ChatModel(
      id: id ?? this.id,
      contact: contact ?? this.contact,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}