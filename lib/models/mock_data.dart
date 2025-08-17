import 'package:intl/intl.dart';
import 'user_model.dart';
import 'message_model.dart';
import 'chat_model.dart';
import 'story_model.dart';

// Default avatar path
const String defaultAvatarPath = 'assets/images/default_avatar.svg';

class MockData {
  // Current user
  static final UserModel currentUser = UserModel(
    id: 'currentUserId',
    name: 'Me',
    avatarUrl: defaultAvatarPath,
    isOnline: true,
    status: 'Available',
  );

  // Sample users
  static final List<UserModel> users = [
    UserModel(
      id: 'user1',
      name: 'Mostafa',
      avatarUrl: defaultAvatarPath,
      isOnline: true,
      status: 'At work',
    ),
    UserModel(
      id: 'user2',
      name: 'Hazem',
      avatarUrl: defaultAvatarPath,
      isOnline: false,
      status: 'Busy',
    ),
    UserModel(
      id: 'user3',
      name: 'Malak',
      avatarUrl: defaultAvatarPath,
      isOnline: true,
      status: 'Available',
    ),
    UserModel(
      id: 'user4',
      name: 'Esraa',
      avatarUrl: defaultAvatarPath,
      isOnline: false,
      status: 'At the movies',
    ),
    UserModel(
      id: 'user5',
      name: 'David',
      avatarUrl: defaultAvatarPath,
      isOnline: true,
      status: 'In a meeting',
    ),
    UserModel(
      id: 'user6',
      name: 'Abdelrahman',
      avatarUrl: defaultAvatarPath,
      isOnline: false,
      status: 'Sleeping',
    ),
    UserModel(
      id: 'user7',
      name: 'Shady',
      avatarUrl: defaultAvatarPath,
      isOnline: true,
      status: 'At the gym',
    ),
  ];

  // Sample messages
  static List<MessageModel> getMessagesForChat(String chatId) {
    final now = DateTime.now();
    
    switch (chatId) {
      case 'chat1':
        return [
          MessageModel(
            senderId: 'user1',
            receiverId: 'currentUserId',
            content: 'Hey, how are you?',
            timestamp: now.subtract(const Duration(days: 0, hours: 1, minutes: 30)),
            status: MessageStatus.read,
          ),
          MessageModel(
            senderId: 'currentUserId',
            receiverId: 'user1',
            content: 'I\'m good, thanks! How about you?',
            timestamp: now.subtract(const Duration(days: 0, hours: 1, minutes: 25)),
            status: MessageStatus.read,
          ),
          MessageModel(
            senderId: 'user1',
            receiverId: 'currentUserId',
            content: 'Doing well. Are we still meeting tomorrow?',
            timestamp: now.subtract(const Duration(days: 0, hours: 1, minutes: 20)),
            status: MessageStatus.read,
          ),
          MessageModel(
            senderId: 'currentUserId',
            receiverId: 'user1',
            content: 'Yes, 2 PM at the coffee shop works for me.',
            timestamp: now.subtract(const Duration(days: 0, hours: 1, minutes: 15)),
            status: MessageStatus.read,
          ),
          MessageModel(
            senderId: 'user1',
            receiverId: 'currentUserId',
            content: 'Perfect! See you then.',
            timestamp: now.subtract(const Duration(days: 0, hours: 1, minutes: 10)),
            status: MessageStatus.read,
          ),
        ];
      case 'chat2':
        return [
          MessageModel(
            senderId: 'user2',
            receiverId: 'currentUserId',
            content: 'Did you finish the project?',
            timestamp: now.subtract(const Duration(days: 0, hours: 3, minutes: 45)),
            status: MessageStatus.read,
          ),
          MessageModel(
            senderId: 'currentUserId',
            receiverId: 'user2',
            content: 'Almost done, just need to fix a few bugs.',
            timestamp: now.subtract(const Duration(days: 0, hours: 3, minutes: 40)),
            status: MessageStatus.read,
          ),
          MessageModel(
            senderId: 'user2',
            receiverId: 'currentUserId',
            content: 'Great! Let me know when it\'s ready for review.',
            timestamp: now.subtract(const Duration(days: 0, hours: 3, minutes: 35)),
            status: MessageStatus.read,
          ),
          MessageModel(
            senderId: 'currentUserId',
            receiverId: 'user2',
            content: 'Will do. Should be ready by end of day.',
            timestamp: now.subtract(const Duration(days: 0, hours: 3, minutes: 30)),
            status: MessageStatus.delivered,
          ),
        ];
      case 'chat3':
        return [
          MessageModel(
            senderId: 'user3',
            receiverId: 'currentUserId',
            content: 'Are you coming to the party this weekend?',
            timestamp: now.subtract(const Duration(days: 1, hours: 2)),
            status: MessageStatus.read,
          ),
          MessageModel(
            senderId: 'currentUserId',
            receiverId: 'user3',
            content: 'Yes, I\'ll be there! What time does it start?',
            timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 55)),
            status: MessageStatus.read,
          ),
          MessageModel(
            senderId: 'user3',
            receiverId: 'currentUserId',
            content: '8 PM at John\'s place. Bring some drinks if you can!',
            timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 50)),
            status: MessageStatus.read,
          ),
          MessageModel(
            senderId: 'currentUserId',
            receiverId: 'user3',
            content: 'Got it. See you there!',
            timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 45)),
            status: MessageStatus.read,
          ),
        ];
      default:
        return [
          MessageModel(
            senderId: chatId.replaceAll('chat', 'user'),
            receiverId: 'currentUserId',
            content: 'Hello there!',
            timestamp: now.subtract(const Duration(days: 2)),
            status: MessageStatus.read,
          ),
          MessageModel(
            senderId: 'currentUserId',
            receiverId: chatId.replaceAll('chat', 'user'),
            content: 'Hi! How are you?',
            timestamp: now.subtract(const Duration(days: 2)).add(const Duration(minutes: 5)),
            status: MessageStatus.read,
          ),
        ];
    }
  }

  // Sample chats
  static List<ChatModel> getChats() {
    final now = DateTime.now();
    
    return [
      ChatModel(
        id: 'chat1',
        contact: users[0],
        lastMessage: MessageModel(
          senderId: 'user1',
          receiverId: 'currentUserId',
          content: 'Perfect! See you then.',
          timestamp: now.subtract(const Duration(days: 0, hours: 1, minutes: 10)),
          status: MessageStatus.read,
        ),
        unreadCount: 0,
        lastUpdated: now.subtract(const Duration(days: 0, hours: 1, minutes: 10)),
      ),
      ChatModel(
        id: 'chat2',
        contact: users[1],
        lastMessage: MessageModel(
          senderId: 'currentUserId',
          receiverId: 'user2',
          content: 'Will do. Should be ready by end of day.',
          timestamp: now.subtract(const Duration(days: 0, hours: 3, minutes: 30)),
          status: MessageStatus.delivered,
        ),
        unreadCount: 0,
        lastUpdated: now.subtract(const Duration(days: 0, hours: 3, minutes: 30)),
      ),
      ChatModel(
        id: 'chat3',
        contact: users[2],
        lastMessage: MessageModel(
          senderId: 'currentUserId',
          receiverId: 'user3',
          content: 'Got it. See you there!',
          timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 45)),
          status: MessageStatus.read,
        ),
        unreadCount: 0,
        lastUpdated: now.subtract(const Duration(days: 1, hours: 1, minutes: 45)),
      ),
      ChatModel(
        id: 'chat4',
        contact: users[3],
        lastMessage: MessageModel(
          senderId: 'user4',
          receiverId: 'currentUserId',
          content: 'Can you send me the document we discussed?',
          timestamp: now.subtract(const Duration(days: 2, hours: 5)),
          status: MessageStatus.read,
        ),
        unreadCount: 0,
        lastUpdated: now.subtract(const Duration(days: 2, hours: 5)),
      ),
      ChatModel(
        id: 'chat5',
        contact: users[4],
        lastMessage: MessageModel(
          senderId: 'user5',
          receiverId: 'currentUserId',
          content: 'The meeting is rescheduled to next Monday.',
          timestamp: now.subtract(const Duration(days: 3)),
          status: MessageStatus.read,
        ),
        unreadCount: 0,
        lastUpdated: now.subtract(const Duration(days: 3)),
      ),
      ChatModel(
        id: 'chat6',
        contact: users[5],
        lastMessage: MessageModel(
          senderId: 'currentUserId',
          receiverId: 'user6',
          content: 'Thanks for the information!',
          timestamp: now.subtract(const Duration(days: 4, hours: 12)),
          status: MessageStatus.read,
        ),
        unreadCount: 0,
        lastUpdated: now.subtract(const Duration(days: 4, hours: 12)),
      ),
      ChatModel(
        id: 'chat7',
        contact: users[6],
        lastMessage: MessageModel(
          senderId: 'user7',
          receiverId: 'currentUserId',
          content: 'Let\'s catch up soon!',
          timestamp: now.subtract(const Duration(days: 5, hours: 8)),
          status: MessageStatus.read,
        ),
        unreadCount: 0,
        lastUpdated: now.subtract(const Duration(days: 5, hours: 8)),
      ),
    ];
  }

  // Format timestamp for display
  static String formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return DateFormat.jm().format(timestamp); // Today: 3:30 PM
    } else if (messageDate == yesterday) {
      return 'Yesterday'; // Yesterday
    } else if (now.difference(timestamp).inDays < 7) {
      return DateFormat.E().format(timestamp); // Day of week: Mon, Tue, etc.
    } else {
      return DateFormat.yMd().format(timestamp); // Date: 10/21/2023
    }
  }

  // Sample stories
  static List<StoryModel> getStories() {
    final now = DateTime.now();
    
    return [
      StoryModel(
        user: currentUser,
        items: [
          StoryItem(
            content: 'https://picsum.photos/id/1/400/800',
            type: StoryType.image,
            timestamp: now.subtract(const Duration(hours: 2)),
          ),
        ],
        lastUpdated: now.subtract(const Duration(hours: 2)),
      ),
      StoryModel(
        user: users[0],
        items: [
          StoryItem(
            content: 'https://picsum.photos/id/10/400/800',
            type: StoryType.image,
            timestamp: now.subtract(const Duration(hours: 3)),
          ),
          StoryItem(
            content: 'https://picsum.photos/id/11/400/800',
            type: StoryType.image,
            timestamp: now.subtract(const Duration(hours: 2)),
          ),
        ],
        lastUpdated: now.subtract(const Duration(hours: 2)),
      ),
      StoryModel(
        user: users[1],
        items: [
          StoryItem(
            content: 'https://picsum.photos/id/20/400/800',
            type: StoryType.image,
            timestamp: now.subtract(const Duration(hours: 5)),
            viewedBy: ['currentUserId'],
          ),
        ],
        lastUpdated: now.subtract(const Duration(hours: 5)),
      ),
      StoryModel(
        user: users[2],
        items: [
          StoryItem(
            content: 'https://picsum.photos/id/30/400/800',
            type: StoryType.image,
            timestamp: now.subtract(const Duration(hours: 6)),
          ),
          StoryItem(
            content: 'https://picsum.photos/id/31/400/800',
            type: StoryType.image,
            timestamp: now.subtract(const Duration(hours: 5)),
          ),
          StoryItem(
            content: 'https://picsum.photos/id/32/400/800',
            type: StoryType.image,
            timestamp: now.subtract(const Duration(hours: 4)),
          ),
        ],
        lastUpdated: now.subtract(const Duration(hours: 4)),
      ),
      StoryModel(
        user: users[3],
        items: [
          StoryItem(
            content: 'Having a great day!',
            type: StoryType.text,
            timestamp: now.subtract(const Duration(hours: 7)),
            viewedBy: ['currentUserId'],
          ),
        ],
        lastUpdated: now.subtract(const Duration(hours: 7)),
      ),
      StoryModel(
        user: users[4],
        items: [
          StoryItem(
            content: 'https://picsum.photos/id/40/400/800',
            type: StoryType.image,
            timestamp: now.subtract(const Duration(hours: 8)),
          ),
        ],
        lastUpdated: now.subtract(const Duration(hours: 8)),
      ),
      StoryModel(
        user: users[5],
        items: [
          StoryItem(
            content: 'https://picsum.photos/id/50/400/800',
            type: StoryType.image,
            timestamp: now.subtract(const Duration(hours: 10)),
            viewedBy: ['currentUserId'],
          ),
        ],
        lastUpdated: now.subtract(const Duration(hours: 10)),
      ),
      StoryModel(
        user: users[6],
        items: [
          StoryItem(
            content: 'https://picsum.photos/id/60/400/800',
            type: StoryType.image,
            timestamp: now.subtract(const Duration(hours: 12)),
          ),
        ],
        lastUpdated: now.subtract(const Duration(hours: 12)),
      ),
    ];
  }
}