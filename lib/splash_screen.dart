import 'package:flutter/material.dart';
import 'hugr_chat_screen.dart'; // The screen Hugr lands on

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simulate a 2-second loading
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HugrChatScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flutter default loading logo (can replace later)
            const FlutterLogo(size: 120),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.deepPurpleAccent),
            const SizedBox(height: 20),
            const Text(
              'Forging Hugr...',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}


