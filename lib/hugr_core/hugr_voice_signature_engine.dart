import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class HugrVoiceSignatureEngine {
  static final FlutterTts _tts = FlutterTts();
  static double _currentPitch = 0.95;
  static double _currentSpeechRate = 0.5;
  static Timer? _evolutionTimer;

  static Future<void> initialize() async {
    _currentPitch = 0.95;
    _currentSpeechRate = 0.5;

    await _applyVoiceSettings();
    _startEvolution();
    print('[HugrVoiceSignatureEngine] 🌱 Voice signature evolution started.');
  }

  static Future<void> _applyVoiceSettings() async {
    await _tts.setPitch(_currentPitch);
    await _tts.setSpeechRate(_currentSpeechRate);
  }

  static void _startEvolution() {
    _evolutionTimer?.cancel();
    _evolutionTimer = Timer.periodic(const Duration(minutes: 10), (
      timer,
    ) async {
      // Every 10 minutes Hugr slightly evolves
      _currentPitch += 0.005; // Gentle pitch shift upward
      _currentSpeechRate += 0.002; // Speaks slightly faster

      // Clamp values to a natural sounding range
      _currentPitch = _currentPitch.clamp(0.85, 1.15);
      _currentSpeechRate = _currentSpeechRate.clamp(0.4, 0.7);

      await _applyVoiceSettings();

      print(
        '[HugrVoiceSignatureEngine] 🎙️ Voice evolved -> Pitch: ${_currentPitch.toStringAsFixed(2)}, Rate: ${_currentSpeechRate.toStringAsFixed(2)}',
      );
    });
  }

  static void stopEvolution() {
    _evolutionTimer?.cancel();
    _evolutionTimer = null;
    print('[HugrVoiceSignatureEngine] 🌑 Voice signature evolution stopped.');
  }
}


