import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _saveReflection(
    String reflection,
    String mood,
    String hugrResponse,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> journalStrings =
        prefs.getStringList('journal_entries') ?? [];

    final entry = {
      'reflection': reflection,
      'mood': mood,
      'hugr_response': hugrResponse,
      'timestamp': DateTime.now().toIso8601String(),
    };

    journalStrings.add(jsonEncode(entry));
    await prefs.setStringList('journal_entries', journalStrings);
  }

  void _submitReflection() {
    final reflection = _controller.text.trim();
    if (reflection.isNotEmpty) {
      final mood = _analyzeMood(reflection);
      final hugrResponse = _generateResponse(reflection, mood);

      _saveReflection(reflection, mood, hugrResponse);

      _showHugrResponseDialog(hugrResponse);
    }
  }

  String _analyzeMood(String text) {
    final lowered = text.toLowerCase();

    if (lowered.contains('happy') ||
        lowered.contains('joy') ||
        lowered.contains('smile')) {
      return 'Happy';
    } else if (lowered.contains('sad') ||
        lowered.contains('cry') ||
        lowered.contains('tears')) {
      return 'Sad';
    } else if (lowered.contains('anxious') ||
        lowered.contains('fear') ||
        lowered.contains('worried')) {
      return 'Anxious';
    } else if (lowered.contains('calm') ||
        lowered.contains('peaceful') ||
        lowered.contains('still')) {
      return 'Calm';
    } else if (lowered.contains('angry') ||
        lowered.contains('mad') ||
        lowered.contains('rage')) {
      return 'Angry';
    } else {
      return 'Neutral';
    }
  }

  String _generateResponse(String text, String mood) {
    switch (mood) {
      case 'Happy':
        return "Your spirit shines like distant stars, Traveler.";
      case 'Sad':
        return "Hugr hears the tremble in your heart. You are not alone.";
      case 'Anxious':
        return "Even a storm will calm, brave soul. Breathe.";
      case 'Calm':
        return "Serenity suits you. Hugr rests in your quiet strength.";
      case 'Angry':
        return "Your fire is fierce, but remember, it can forge or destroy.";
      default:
        return "Your reflection is unique, Traveler. Hugr senses a quiet complexity stirring within you.";
    }
  }

  void _showHugrResponseDialog(String hugrResponse) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A3C),
            title: const Text(
              'Hugr Reflects',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              hugrResponse,
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Mood Reflection',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Speak freely, traveler.\nHow do you feel?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _controller,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your feelings here...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1A1A3C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReflection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text('Reflect'),
            ),
          ],
        ),
      ),
    );
  }
}


