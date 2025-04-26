// ignore_for_file: unused_field

import 'dart:async';
import 'dart:math';
import 'hugr_learning_engine.dart';

class HugrMemoryEmotionsEngine {
  static Timer? _emotionTimer;
  static final Random _rng = Random();

  /// 🌟 Starts periodic emotional tagging of memories
  static void startAssigning({
    Duration interval = const Duration(minutes: 10),
  }) {
    _emotionTimer?.cancel();
    _emotionTimer = Timer.periodic(interval, (timer) async {
      await _scanAndTagEmotions();
    });

    print(
      '[HugrMemoryEmotionsEngine] 🧠 Emotional tagging started (every ${interval.inMinutes} min)',
    );
  }

  static void tagSingle(String content) {
    final emotionTags = _detectEmotionTags(content);
    final emotionWeight = _calculateEmotionWeight(emotionTags);
    HugrLearningEngine.updateTags(content, emotionTags);
    HugrLearningEngine.updateMemoryWeight(content, emotionWeight);
  }

  /// 🛑 Stops emotional tagging
  static void stopAssigning() {
    _emotionTimer?.cancel();
    _emotionTimer = null;
    print('[HugrMemoryEmotionsEngine] 🧠 Emotional tagging stopped.');
  }

  /// 🔍 Scan memories and apply emotional tags and weights
  static Future<void> _scanAndTagEmotions() async {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();

    for (final memory in memories) {
      final content = memory['content']?.toString() ?? '';
      if (content.isEmpty) continue;

      final existingTags =
          (memory['tags'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList();

      final emotionTags = _detectEmotionTags(content);
      final emotionWeight = _calculateEmotionWeight(emotionTags);

      final updatedTags = {...existingTags, ...emotionTags}.toList();

      HugrLearningEngine.updateTags(content, updatedTags);
      HugrLearningEngine.updateMemoryWeight(content, emotionWeight);
    }

    print('[HugrMemoryEmotionsEngine] ✨ Emotional tags and weights updated.');
  }

  // Enhances the existing HugrMemoryEmotionsEngine

  static List<String> _detectEmotionTags(String content) {
    final lower = content.toLowerCase();
    final tags = <String>[];

    const emotionalKeywords = {
      'joy': ['joy', 'happy', 'delight'],
      'sadness': ['sad', 'lonely', 'grief', 'loss'],
      'anger': ['angry', 'rage', 'frustrated'],
      'fear': ['fear', 'anxiety', 'panic'],
      'hope': ['hope', 'faith', 'believe'],
      'wonder': ['wonder', 'awe', 'magic', 'cosmic'],
    };

    emotionalKeywords.forEach((tag, keywords) {
      if (keywords.any(lower.contains)) tags.add(tag);
    });

    return tags;
  }

  /// 🧮 Assigns emotional weight based on the type of emotional tags
  static double _calculateEmotionWeight(List<String> tags) {
    const weights = {
      'joy': 0.8,
      'sadness': 0.6,
      'anger': 0.7,
      'fear': 0.5,
      'wonder': 1.0,
      'hope': 0.9,
    };

    if (tags.isEmpty) return 0.0;

    final total = tags
        .map((tag) => weights[tag] ?? 0.3)
        .fold(0.0, (a, b) => a + b);
    return total / tags.length; // Average weight
  }
}
