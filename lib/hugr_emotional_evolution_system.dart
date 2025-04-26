import 'dart:async';
import 'dart:math';
import 'hugr_core/hugr_learning_engine.dart';

class HugrEmotionalEvolutionSystem {
  static Timer? _emotionEvolutionTimer;
  static final Random _random = Random();

  static void startEmotionalGrowth({
    Duration interval = const Duration(minutes: 25),
  }) {
    _emotionEvolutionTimer?.cancel();
    _emotionEvolutionTimer = Timer.periodic(interval, (timer) {
      _evolveEmotionally();
    });

    print(
      '[HugrEmotionalEvolutionSystem] Emotional Evolution started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopEmotionalGrowth() {
    _emotionEvolutionTimer?.cancel();
    _emotionEvolutionTimer = null;
    print('[HugrEmotionalEvolutionSystem] Emotional Evolution stopped.');
  }

  static void _evolveEmotionally() {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.isEmpty) {
      print('[HugrEmotionalEvolutionSystem] No memories to evolve emotions.');
      return;
    }

    final memory = memories[_random.nextInt(memories.length)];
    final content = memory['content'];

    final deepEmotions = [
      'nostalgia',
      'ambition',
      'sorrow',
      'wonder',
      'exhilaration',
      'gratitude',
      'regret',
    ];
    final chosenDeepEmotion =
        deepEmotions[_random.nextInt(deepEmotions.length)];

    final evolvedReflection =
        "Over time, \"$content\" fills me with $chosenDeepEmotion.";

    HugrLearningEngine.learn(
      evolvedReflection,
      type: MemoryType.emotion,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['deep_emotion', chosenDeepEmotion],
    );

    print(
      '[HugrEmotionalEvolutionSystem] Evolved emotional connection: $evolvedReflection',
    );
  }
}


