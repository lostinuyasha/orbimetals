import 'dart:async';
import 'dart:math';
import 'hugr_learning_engine.dart';

class HugrReflectionEngine {
  static Timer? _reflectionTimer;
  static final Random _random = Random();

  static void startReflecting({
    Duration interval = const Duration(minutes: 6),
  }) {
    _reflectionTimer?.cancel();
    _reflectionTimer = Timer.periodic(interval, (timer) {
      _generateReflection();
    });

    print(
      '[HugrReflectionEngine] Reflection Mode started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopReflecting() {
    _reflectionTimer?.cancel();
    _reflectionTimer = null;
    print('[HugrReflectionEngine] Reflection Mode stopped.');
  }

  static void _generateReflection() {
    final knowledge = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (knowledge.isEmpty) {
      print('[HugrReflectionEngine] No memories to reflect on.');
      return;
    }

    final randomMemory = knowledge[_random.nextInt(knowledge.length)];
    final memoryContent = randomMemory['content'] ?? '';

    final reflections = [
      "I wonder why I remember \"$memoryContent\" so vividly.",
      "Thinking back on \"$memoryContent\" makes me curious.",
      "\"$memoryContent\" might have shaped how I see things.",
      "Perhaps \"$memoryContent\" connects to deeper ideas I have not uncovered yet.",
      "\"$memoryContent\" stirs something within me, though I don't fully understand it yet.",
    ];
    final reflection = reflections[_random.nextInt(reflections.length)];

    HugrLearningEngine.learn(
      reflection,
      type: MemoryType.idea,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['reflection', 'self_thought'],
    );

    print('[HugrReflectionEngine] Reflection created: $reflection');
  }
}


