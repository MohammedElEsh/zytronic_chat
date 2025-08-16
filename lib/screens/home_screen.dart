import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/chat_model.dart';
import '../models/mock_data.dart';
import '../theme/theme_provider.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/story_circle.dart';
import 'chat_screen.dart';
import 'story_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ChatModel> _chats = MockData.getChats();
  final List<Tab> _tabs = const [
    Tab(text: 'CHATS'),
    Tab(text: 'STATUS'),
    Tab(text: 'CALLS'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightMode = theme.brightness == Brightness.light;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(isLightMode ? Icons.dark_mode : Icons.light_mode),
            tooltip: isLightMode ? 'Switch to dark mode' : 'Switch to light mode',
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {},
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new_group',
                child: Text('New group'),
              ),
              const PopupMenuItem(
                value: 'new_broadcast',
                child: Text('New broadcast'),
              ),
              const PopupMenuItem(
                value: 'linked_devices',
                child: Text('Linked devices'),
              ),
              const PopupMenuItem(
                value: 'starred_messages',
                child: Text('Starred messages'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Chats Tab
          _buildChatsList(),
          
          // Status Tab
          _buildStatusTab(),
          
          // Calls Tab (placeholder)
          const Center(child: Text('Calls')),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildChatsList() {
    return ListView.separated(
      itemCount: _chats.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final chat = _chats[index];
        return ChatListItem(
          chat: chat,
          onTap: () => _navigateToChatScreen(chat),
        );
      },
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildStatusTab() {
    final stories = MockData.getStories();
    final myStory = stories.firstWhere((story) => story.user.id == 'currentUserId');
    final otherStories = stories.where((story) => story.user.id != 'currentUserId').toList();
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // My Status
          ListTile(
            leading: StoryCircle(
              story: myStory,
              radius: 26,
              onTap: () => _navigateToStoryScreen(myStory),
            ),
            title: const Text('My Status'),
            subtitle: const Text('Tap to add status update'),
            onTap: () => _navigateToStoryScreen(myStory),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Recent updates', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          
          // Other Stories
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: otherStories.length,
            itemBuilder: (context, index) {
              final story = otherStories[index];
              return ListTile(
                leading: StoryCircle(
                  story: story,
                  radius: 26,
                  onTap: () => _navigateToStoryScreen(story),
                ),
                title: Text(story.user.name),
                subtitle: Text(
                  '${MockData.formatMessageTime(story.lastUpdated)}',
                  style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                ),
                onTap: () => _navigateToStoryScreen(story),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildFloatingActionButton() {

      // Chat tab FAB
      return FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat),
      );

  }

  void _navigateToChatScreen(ChatModel chat) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ChatScreen(chat: chat),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void _navigateToStoryScreen(dynamic story) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => StoryScreen(story: story),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}