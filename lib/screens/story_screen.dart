import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/story_model.dart';

class StoryScreen extends StatefulWidget {
  final StoryModel story;

  const StoryScreen({super.key, required this.story});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.addStatusListener(_animationStatusListener);
    _loadStory(initialIndex: 0);
    
    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    // Restore status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _nextStory();
    }
  }

  void _loadStory({required int initialIndex}) {
    _currentIndex = initialIndex;
    _animationController.duration = widget.story.items[initialIndex].duration;
    _animationController.forward(from: 0.0);
  }

  void _nextStory() {
    if (_currentIndex < widget.story.items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onTapDown(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;
    
    // Tap on left third of screen - go to previous story
    if (tapPosition < screenWidth / 3) {
      _animationController.stop();
      _previousStory();
    } 
    // Tap on right two-thirds of screen - go to next story
    else {
      _animationController.stop();
      _nextStory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: _onTapDown,
        onLongPress: () {
          _animationController.stop();
        },
        onLongPressUp: () {
          _animationController.forward();
        },
        child: Stack(
          children: [
            // Story content
            PageView.builder(
              controller: _pageController,
              itemCount: widget.story.items.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _animationController.stop();
                _animationController.duration = widget.story.items[index].duration;
                _animationController.forward(from: 0.0);
              },
              itemBuilder: (context, index) {
                final item = widget.story.items[index];
                
                if (item.type == StoryType.image) {
                  return Center(
                    child: Image.network(
                      item.content,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error, color: Colors.white, size: 50),
                        );
                      },
                    ),
                  );
                } else if (item.type == StoryType.text) {
                  return Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        item.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Unsupported content',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
            
            // Progress indicators
            SafeArea(
              child: Column(
                children: [
                  // Progress bars
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      children: List.generate(
                        widget.story.items.length,
                        (index) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: index == _currentIndex
                                ? AnimatedBuilder(
                                    animation: _progressAnimation,
                                    builder: (context, child) {
                                      return LinearProgressIndicator(
                                        value: _progressAnimation.value,
                                        backgroundColor: Colors.white.withOpacity(0.4),
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                        minHeight: 3,
                                      );
                                    },
                                  )
                                : LinearProgressIndicator(
                                    value: index < _currentIndex ? 1.0 : 0.0,
                                    backgroundColor: Colors.white.withOpacity(0.4),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                    minHeight: 3,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // User info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(widget.story.user.avatarUrl),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.story.user.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_currentIndex + 1}/${widget.story.items.length}',
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}