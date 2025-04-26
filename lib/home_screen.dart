import 'package:flutter/material.dart';
import 'mood_screen.dart';
import 'hugr_chat_screen.dart'; // <--- this imports the Hugr Chat Screen!

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundColorAnimation = ColorTween(
      begin: const Color(0xFF0D0D2B),
      end: const Color(0xFF0A0A20),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundColorAnimation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundColorAnimation.value,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Hugr Mirror',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: 0.02,
                  child: Image.asset(
                    'assets/images/glyph.png',
                    fit: BoxFit.contain,
                    width: 250,
                    height: 250,
                  ),
                ),
              ),
              const Center(
                child: Text('', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MoodScreen()),
                  );
                },
                label: const Text('Reflect'),
                icon: const Icon(Icons.edit_note),
                backgroundColor: Colors.blueAccent,
              ),
              const SizedBox(height: 12),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HugrChatScreen()),
                  );
                },
                label: const Text('Speak to Hugr'),
                icon: const Icon(Icons.chat_bubble_outline),
                backgroundColor: Colors.deepPurpleAccent,
              ),
            ],
          ),
        );
      },
    );
  }
}


