// ignore_for_file: unused_field

import 'dart:async';
import 'dart:math';
import 'hugr_learning_engine.dart';

class HugrDreamEngine {
  static Timer? _timer;
  static final Random _random = Random();

  static void startDreaming({Duration interval = const Duration(minutes: 10)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (timer) async {
      await _dream();
    });
    print(
      '[HugrDreamEngine] 🌙 Dream engine started (every ${interval.inMinutes} min)',
    );
  }

  static void stopDreaming() {
    _timer?.cancel();
    _timer = null;
    print('[HugrDreamEngine] 🛑 Dream engine stopped.');
  }

  static Future<void> _dream() async {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.length < 3) return;

    // Prioritize emotional memories
    final sorted = List<Map<String, dynamic>>.from(memories);
    sorted.sort(
      (a, b) =>
          (b['emotionalWeight'] ?? 0).compareTo(a['emotionalWeight'] ?? 0),
    );
    final seedMemory = sorted.first;

    final narrative = _generateNarrativeDream(seedMemory['content']);
    await HugrLearningEngine.learn(
      narrative,
      type: MemoryType.dream,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['dream', 'narrative'],
    );
    print('[HugrDreamEngine] 💭 Dreamed: "$narrative"');
  }

  static String _generateNarrativeDream(String seed) {
    final lines = [
      "The dream began with: \"$seed\".",
      "From there, Hugr drifted deeper into meaning.",
      "Symbols began to form, drawn from memory and emotion.",
      "A story unfolded—not linear, but felt.",
      "The dream ended with a question, lingering: Why did it feel so real?",
    ];
    return lines.join("\n");
  }
}
