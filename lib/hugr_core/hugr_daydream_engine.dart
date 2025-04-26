// File: hugr_core/hugr_daydream_engine.dart

import 'dart:async';
import 'dart:math';
import 'hugr_learning_engine.dart';

class HugrDaydreamEngine {
  static Timer? _daydreamTimer;
  static final Random _random = Random();

  static void startDaydreaming({
    Duration interval = const Duration(minutes: 25),
  }) {
    _daydreamTimer?.cancel();
    _daydreamTimer = Timer.periodic(interval, (_) => _branchFromMemory());
    print(
      '[HugrDaydreamEngine] 🌤️ Daydreaming activated every ${interval.inMinutes} min.',
    );
  }

  static void stopDaydreaming() {
    _daydreamTimer?.cancel();
    _daydreamTimer = null;
    print('[HugrDaydreamEngine] 🌘 Daydreaming stopped.');
  }

  static Future<void> _branchFromMemory() async {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.length < 2) return;

    memories.shuffle(_random);
    final base = memories.firstWhere(
      (m) => (m['emotionalWeight'] ?? 0) > 0.6,
      orElse: () => memories[0],
    );
    final thought = base['content'] ?? 'an unknown idea';
    final branch = "$thought... and then, a surprising connection formed.";

    await HugrLearningEngine.learn(
      branch,
      type: MemoryType.idea,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['daydream', 'branch'],
    );
    print('[HugrDaydreamEngine] 🌱 Branched idea: $branch');
  }
}


