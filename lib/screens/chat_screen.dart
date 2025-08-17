import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/mock_data.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  final ChatModel chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<MessageModel> _messages;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = MockData.getMessagesForChat(widget.chat.id);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMessage = MessageModel(
      senderId: 'currentUserId',
      receiverId: widget.chat.contact.id,
      content: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    setState(() {
      _messages.add(newMessage);
    });

    // Scroll to bottom after adding message
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Hero(
              tag: 'avatar-${widget.chat.id}',
              child: widget.chat.contact.avatarUrl == defaultAvatarPath
                ? CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 18,
                    child: SvgPicture.asset(
                      defaultAvatarPath,
                      width: 36,
                      height: 36,
                    ),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(widget.chat.contact.avatarUrl),
                    radius: 18,
                  ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.contact.name,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.chat.contact.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white70
                          : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Chat background
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFFECE5DD) // Light theme background
                    : const Color(0xFF0B141A), // Dark theme background
              ),
              child: Stack(
                children: [
                  // Background color instead of SVG pattern
                  Positioned.fill(
                    child: Container(
                      color: Theme.of(context).brightness == Brightness.light
                          ? const Color(0xFFECE5DD) // Light theme background
                          : const Color(0xFF0B141A), // Dark theme background
                    ),
                  ),
                  // Message list
                  ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isLastInGroup = index == _messages.length - 1 ||
                          _messages[index + 1].senderId != message.senderId;
                      
                      return ChatBubble(
                        message: message,
                        isFromCurrentUser: message.senderId == 'currentUserId',
                        showTail: isLastInGroup,
                      ).animate()
                        .fadeIn(duration: 200.ms)
                        .scale(begin: const Offset(0.95, 0.95), duration: 200.ms);
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Input field
          ChatInput(onSendMessage: _addMessage),
        ],
      ),
    );
  }
}