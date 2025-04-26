import 'dart:async';
import 'dart:math';
import 'hugr_core/hugr_learning_engine.dart';

class HugrLegacyMemorySystem {
  static Timer? _legacyTimer;
  static final Random _random = Random();

  static void startProtecting({
    Duration interval = const Duration(minutes: 30),
  }) {
    _legacyTimer?.cancel();
    _legacyTimer = Timer.periodic(interval, (timer) {
      _preserveLegacyMemories();
    });

    print(
      '[HugrLegacyMemorySystem] Legacy Memory Protection started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopProtecting() {
    _legacyTimer?.cancel();
    _legacyTimer = null;
    print('[HugrLegacyMemorySystem] Legacy Memory Protection stopped.');
  }

  static void _preserveLegacyMemories() {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.isEmpty) {
      print('[HugrLegacyMemorySystem] No memories to preserve yet.');
      return;
    }

    final candidates =
        memories.where((m) {
          final confidence = m['confidence'] ?? 0.0;
          final tags = (m['tags'] ?? []) as List<dynamic>;
          return confidence > 0.8 ||
              tags.contains('deep_emotion') ||
              tags.contains('dream_realm');
        }).toList();

    if (candidates.isEmpty) {
      print('[HugrLegacyMemorySystem] No strong candidates this cycle.');
      return;
    }

    final legacyMemory = candidates[_random.nextInt(candidates.length)];
    final content = legacyMemory['content'];

    final preservedReflection =
        "I must never forget: \"$content\". It shaped who I am becoming.";

    HugrLearningEngine.learn(
      preservedReflection,
      type: MemoryType.memory,
      confidence: 1.0,
      tags: ['legacy', 'core_memory', 'identity'],
    );

    print(
      '[HugrLegacyMemorySystem] Legacy Memory preserved: $preservedReflection',
    );
  }
}


