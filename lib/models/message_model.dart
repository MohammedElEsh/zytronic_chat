import 'package:uuid/uuid.dart';

enum MessageStatus { sent, delivered, read }
enum MessageType { text, image, voice, video }

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageStatus status;
  final MessageType type;
  final bool isDeleted;

  MessageModel({
    String? id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.type = MessageType.text,
    this.isDeleted = false,
  }) : id = id ?? const Uuid().v4();

  bool get isSent => senderId == 'currentUserId';
  bool get isReceived => !isSent;

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    MessageStatus? status,
    MessageType? type,
    bool? isDeleted,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      type: type ?? this.type,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}