import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/message_model.dart';
import '../theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isFromCurrentUser;
  final bool showTail;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isFromCurrentUser,
    this.showTail = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Determine bubble color based on sender and theme
    final bubbleColor = isFromCurrentUser
        ? (isDarkMode ? AppColors.darkOutgoingBubble : AppColors.lightOutgoingBubble)
        : (isDarkMode ? AppColors.darkIncomingBubble : AppColors.lightIncomingBubble);
    
    // Determine text color based on sender and theme
    final textColor = isFromCurrentUser
        ? (isDarkMode ? AppColors.darkOutgoingText : AppColors.lightOutgoingText)
        : (isDarkMode ? AppColors.darkIncomingText : AppColors.lightIncomingText);
    
    // Format timestamp
    final time = TimeOfDay.fromDateTime(message.timestamp).format(context);
    
    // Determine message status icon
    Widget? statusIcon;
    if (isFromCurrentUser) {
      if (message.status == MessageStatus.sent) {
        statusIcon = const Icon(Icons.check, size: 12, color: Colors.grey);
      } else if (message.status == MessageStatus.delivered) {
        statusIcon = const Icon(Icons.done_all, size: 12, color: Colors.grey);
      } else if (message.status == MessageStatus.read) {
        statusIcon = Icon(Icons.done_all, size: 12, color: Colors.blue[400]);
      }
    }

    return Align(
      alignment: isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Card(
          color: bubbleColor,
          margin: EdgeInsets.only(
            top: 5,
            bottom: 5,
            right: isFromCurrentUser ? 8 : 50,
            left: isFromCurrentUser ? 50 : 8,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 20),
                child: _buildMessageContent(context, textColor),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                    if (statusIcon != null) ...[const SizedBox(width: 3), statusIcon],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 150.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildMessageContent(BuildContext context, Color textColor) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(color: textColor),
        );
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                message.content,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (message.content.isNotEmpty) ...[  
              const SizedBox(height: 5),
              Text(
                'Photo',
                style: TextStyle(color: textColor),
              ),
            ],
          ],
        );
      case MessageType.voice:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow, color: textColor),
            const SizedBox(width: 5),
            Expanded(
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Voice message',
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
            ),
          ],
        );
      case MessageType.video:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    message.content,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              'Video',
              style: TextStyle(color: textColor),
            ),
          ],
        );
      }
  }
}