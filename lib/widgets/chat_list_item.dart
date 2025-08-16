import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/mock_data.dart';
import '../screens/chat_screen.dart';

class ChatListItem extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback? onTap;

  const ChatListItem({super.key, required this.chat, this.onTap});

  @override
  Widget build(BuildContext context) {
    final lastMessage = chat.lastMessage;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ChatScreen(chat: chat),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                Hero(
                  tag: 'avatar_${chat.id}',
                  child: chat.contact.avatarUrl == defaultAvatarPath
                    ? CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[300],
                        child: SvgPicture.asset(
                          defaultAvatarPath,
                          width: 56,
                          height: 56,
                        ),
                      )
                    : CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(chat.contact.avatarUrl),
                      ),
                ),
                if (chat.contact.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode ? Colors.black : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Chat details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Contact name
                      Text(
                        chat.contact.name,
                        style: TextStyle(
                          fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      // Timestamp
                      Text(
                        _formatTime(lastMessage.timestamp),
                        style: TextStyle(
                          color: chat.unreadCount > 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Message status icon for outgoing messages
                      if (lastMessage.senderId == 'current_user') ...[  
                        _buildStatusIcon(lastMessage.status),
                        const SizedBox(width: 4),
                      ],
                      // Last message preview
                      Expanded(
                        child: Text(
                          _getMessagePreview(lastMessage),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: chat.unreadCount > 0
                                ? isDarkMode ? Colors.white : Colors.black
                                : Colors.grey,
                            fontWeight: chat.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Unread count and mute indicator
                      Row(
                        children: [
                          if (chat.isMuted)
                            const Icon(
                              Icons.volume_off,
                              size: 16,
                              color: Colors.grey,
                            ),
                          if (chat.unreadCount > 0) ...[  
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                chat.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatusIcon(MessageStatus status) {
    if (status == MessageStatus.sent) {
      return const Icon(Icons.check, size: 16, color: Colors.grey);
    } else if (status == MessageStatus.delivered) {
      return const Icon(Icons.done_all, size: 16, color: Colors.grey);
    } else if (status == MessageStatus.read) {
      return Icon(Icons.done_all, size: 16, color: Colors.blue[400]);
    }
    return const SizedBox.shrink();
  }

  String _getMessagePreview(MessageModel message) {
    if (message.isDeleted) {
      return 'This message was deleted';
    }
    
    switch (message.type) {
      case MessageType.text:
        return message.content;
      case MessageType.image:
        return '📷 Photo';
      case MessageType.voice:
        return '🎤 Voice message';
      case MessageType.video:
        return '📹 Video';
      default:
        return message.content;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(timestamp).inDays < 7) {
      return _getWeekday(timestamp.weekday);
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }
}