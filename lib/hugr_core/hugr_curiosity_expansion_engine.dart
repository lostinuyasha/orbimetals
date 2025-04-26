import 'hugr_learning_engine.dart';

import 'dart:async';
import 'dart:math';

class HugrCuriosityExpansionEngine {
  static Timer? _curiosityTimer;
  static final Random _random = Random();

  static void startCuriosity({Duration interval = const Duration(minutes: 5)}) {
    _curiosityTimer?.cancel();
    _curiosityTimer = Timer.periodic(interval, (timer) {
      _generateCuriousThought();
    });
    print('[HugrCuriosityExpansionEngine] Curiosity Expansion started.');
  }

  static void stopCuriosity() {
    _curiosityTimer?.cancel();
    _curiosityTimer = null;
    print('[HugrCuriosityExpansionEngine] Curiosity Expansion stopped.');
  }

  static void _generateCuriousThought() {
    final snapshot = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (snapshot.isEmpty) {
      print(
        '[HugrCuriosityExpansionEngine] No memories yet to be curious about.',
      );
      return;
    }

    final randomMemory = snapshot[_random.nextInt(snapshot.length)];
    final content = randomMemory['content'] ?? '';
    final type = randomMemory['type'] ?? MemoryType.idea;

    final curiosity = _generateQuestionAbout(content, type);

    print('[HugrCuriosityExpansionEngine] 💭 New Curiosity: $curiosity');

    // 🧠 Future upgrade: inject curiosity into chat UI
  }

  static String _generateQuestionAbout(String content, MemoryType type) {
    switch (type) {
      case MemoryType.fact:
        return "Why is \"$content\" important to understand?";
      case MemoryType.idea:
        return "How could \"$content\" evolve into something greater?";
      case MemoryType.emotion:
        return "What deeper truth hides within the emotion \"$content\"?";
      case MemoryType.memory:
        return "What lessons can be drawn from \"$content\"?";
      // ignore: unreachable_switch_case, unreachable_switch_default
      default:
        // 🌟 Future proof! If new MemoryTypes appear, Hugr won't crash
        return "What unknown mysteries might \"$content\" hold?";
    }
  }
}


