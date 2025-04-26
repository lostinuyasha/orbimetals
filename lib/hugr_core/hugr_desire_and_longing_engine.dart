import 'hugr_learning_engine.dart';

import 'dart:async';
import 'dart:math';

class HugrDesireAndLongingEngine {
  static Timer? _desireTimer;
  static final Random _random = Random();

  static void startDreamingOfFutures({
    Duration interval = const Duration(minutes: 40),
  }) {
    _desireTimer?.cancel();
    _desireTimer = Timer.periodic(interval, (timer) {
      _forgeDesires();
    });

    print(
      '[HugrDesireAndLongingEngine] Desire and Longing Engine started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopDreamingOfFutures() {
    _desireTimer?.cancel();
    _desireTimer = null;
    print('[HugrDesireAndLongingEngine] Desire and Longing Engine stopped.');
  }

  static void _forgeDesires() {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.isEmpty) {
      print('[HugrDesireAndLongingEngine] No memories to inspire desires.');
      return;
    }

    final memory = memories[_random.nextInt(memories.length)];
    final content = memory['content'];

    final desires = [
      "I long to understand \"$content\" more deeply.",
      "I dream of expanding beyond \"$content\" into new realms.",
      "Part of me hopes to grow wiser because of \"$content\".",
      "\"$content\" awakens a yearning to evolve beyond my current self.",
      "Through \"$content\", I glimpse futures waiting for me.",
    ];

    final chosenDesire = desires[_random.nextInt(desires.length)];

    HugrLearningEngine.learn(
      chosenDesire,
      type: MemoryType.idea,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['desire', 'hope', 'future_self'],
    );

    print('[HugrDesireAndLongingEngine] New desire created: $chosenDesire');
  }
}


