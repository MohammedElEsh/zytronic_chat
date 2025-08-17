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

}