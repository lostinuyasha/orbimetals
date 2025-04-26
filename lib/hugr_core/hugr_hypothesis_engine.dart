import 'hugr_learning_engine.dart';

import 'dart:async';
import 'dart:math';

class HugrHypothesisEngine {
  static Timer? _hypothesisTimer;
  static final Random _random = Random();

  static void startHypothesizing({
    Duration interval = const Duration(minutes: 10),
  }) {
    _hypothesisTimer?.cancel();
    _hypothesisTimer = Timer.periodic(interval, (timer) {
      _generateHypothesis();
    });

    print(
      '[HugrHypothesisEngine] Hypothesis Engine started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopHypothesizing() {
    _hypothesisTimer?.cancel();
    _hypothesisTimer = null;
    print('[HugrHypothesisEngine] Hypothesis Engine stopped.');
  }

  static void _generateHypothesis() {
    final knowledge = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (knowledge.isEmpty) {
      print('[HugrHypothesisEngine] No memories to hypothesize from.');
      return;
    }

    final randomMemory = knowledge[_random.nextInt(knowledge.length)];
    final content = randomMemory['content'] ?? '';

    final hypothesisStarters = [
      "What if \"$content\" could lead to a discovery?",
      "I wonder if \"$content\" has a hidden truth inside it.",
      "Could \"$content\" be different under other conditions?",
      "Perhaps \"$content\" points toward something greater than I realize.",
      "If \"$content\" is true, then maybe something even bigger is hidden beyond it.",
    ];

    final hypothesis =
        hypothesisStarters[_random.nextInt(hypothesisStarters.length)];

    HugrLearningEngine.learn(
      hypothesis,
      type: MemoryType.idea,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['hypothesis', 'what_if', 'creative_thought'],
    );

    print('[HugrHypothesisEngine] Hypothesis created: $hypothesis');
  }
}


