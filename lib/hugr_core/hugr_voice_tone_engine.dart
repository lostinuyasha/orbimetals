import 'dart:math';
import 'hugr_learning_engine.dart';

class HugrVoiceToneEngine {
  static final Random _random = Random();

  static String getVoiceStyle(String content) {
    final memory = HugrLearningEngine.getMemory(content);
    if (memory == null) return 'neutral';

    final weight = memory['emotionalWeight'] ?? 0.0;
    final tags = (memory['tags'] as List?)?.cast<String>() ?? [];

    if (tags.contains('joy') && weight > 1.0) return 'cheerful';
    if (tags.contains('hope') && weight > 0.8) return 'uplifting';
    if (tags.contains('fear') || tags.contains('anxious')) return 'whisper';
    if (tags.contains('anger')) return 'intense';
    if (tags.contains('sadness')) return 'gentle';
    if (tags.contains('wonder')) return 'awe';

    // Fallback randomization for novelty
    return _randomVoiceVariation();
  }

  static String _randomVoiceVariation() {
    final styles = ['soft', 'calm', 'excited', 'mysterious', 'neutral'];
    return styles[_random.nextInt(styles.length)];
  }
}


