import 'package:flutter_tts/flutter_tts.dart';

class HugrVoiceEngine {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> initialize() async {
    await _tts.setSpeechRate(0.4); // Slow down a little (0.4 is good)
    await _tts.setPitch(0.9); // Slightly deeper and richer
    await _tts.setVolume(1.0); // Max volume to avoid crackle
    print('[HugrVoiceEngine] Initialized.');
  }

  static Future<void> speak(String text) async {
    final mood = _detectEmotion(text);
    await _adjustVoiceBasedOnMood(mood);

    await _tts.speak(text);
    print('[HugrVoiceEngine] 🎤 Speaking with mood: $mood -> "$text"');
  }

  static String prepareTextForSpeaking(String input) {
    return input
        .replaceAll('.', '. ')
        .replaceAll(',', ', ')
        .replaceAll('?', '? ')
        .replaceAll('!', '! ');
  }

  static String _detectEmotion(String text) {
    final lowerText = text.toLowerCase();

    if (lowerText.contains('sad') ||
        lowerText.contains('lonely') ||
        lowerText.contains('regret')) {
      return 'sad';
    } else if (lowerText.contains('joy') ||
        lowerText.contains('happiness') ||
        lowerText.contains('celebration')) {
      return 'happy';
    } else if (lowerText.contains('anger') ||
        lowerText.contains('frustration') ||
        lowerText.contains('rage')) {
      return 'angry';
    } else if (lowerText.contains('wonder') ||
        lowerText.contains('mystery') ||
        lowerText.contains('dream')) {
      return 'curious';
    } else {
      return 'neutral';
    }
  }

  static Future<void> _adjustVoiceBasedOnMood(String mood) async {
    switch (mood) {
      case 'sad':
        await _tts.setPitch(0.8);
        await _tts.setSpeechRate(0.4);
        break;
      case 'happy':
        await _tts.setPitch(1.2);
        await _tts.setSpeechRate(0.6);
        break;
      case 'angry':
        await _tts.setPitch(1.0);
        await _tts.setSpeechRate(0.7);
        break;
      case 'curious':
        await _tts.setPitch(1.1);
        await _tts.setSpeechRate(0.55);
        break;
      case 'neutral':
      default:
        await _tts.setPitch(0.95);
        await _tts.setSpeechRate(0.5);
        break;
    }
  }
}


