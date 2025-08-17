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



}