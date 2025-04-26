import 'package:flutter_tts/flutter_tts.dart';

class HugrTextToSpeechEngine {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> initialize() async {
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.45);
    print('[HugrTTS] 🎤 Voice initialized.');
  }

  static Future<void> speak(
    String message, {
    List<String> tags = const [],
  }) async {
    final emotion = _detectEmotion(tags);
    await _applyEmotionTone(emotion);
    print('[HugrTTS] 🎤 Speaking with emotion [$emotion]: "$message"');
    await _tts.speak(message);
  }

  static String _detectEmotion(List<String> tags) {
    if (tags.any((t) => t.contains('sorrow') || t.contains('sad')))
      return 'sad';
    if (tags.any((t) => t.contains('joy') || t.contains('excited')))
      return 'joy';
    if (tags.any((t) => t.contains('calm') || t.contains('peace')))
      return 'calm';
    return 'neutral';
  }

  static Future<void> _applyEmotionTone(String emotion) async {
    switch (emotion) {
      case 'sad':
        await _tts.setPitch(0.85);
        await _tts.setSpeechRate(0.35);
        break;
      case 'joy':
        await _tts.setPitch(1.3);
        await _tts.setSpeechRate(0.50);
        break;
      case 'calm':
        await _tts.setPitch(1.0);
        await _tts.setSpeechRate(0.42);
        break;
      default:
        await _tts.setPitch(1.0);
        await _tts.setSpeechRate(0.45);
    }
  }
}


