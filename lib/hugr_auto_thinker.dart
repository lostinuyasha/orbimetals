import 'dart:async';
import 'dart:math';
import 'hugr_core/hugr_learning_engine.dart';

typedef AutoThoughtCallback = void Function(String thought);

class HugrAutoThinker {
  static Timer? _thoughtTimer;
  static final Random _random = Random();
  static AutoThoughtCallback? _onThoughtGenerated;

  static void startThinking({required AutoThoughtCallback onThoughtGenerated}) {
    _onThoughtGenerated = onThoughtGenerated;

    _thoughtTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      final thoughts = HugrLearningEngine.getKnowledgeBaseSnapshot();
      if (thoughts.isEmpty) {
        print('[HugrAutoThinker] No memories to think about yet.');
        return;
      }

      final randomThought = thoughts[_random.nextInt(thoughts.length)];
      final content = randomThought['content'];

      if (content != null && _onThoughtGenerated != null) {
        print('[HugrAutoThinker] 🧠 Thought: $content');
        _onThoughtGenerated!("I've been thinking... $content");
      }
    });

    print('[HugrAutoThinker] 🧠 Background thinking started.');
  }

  static void stopThinking() {
    _thoughtTimer?.cancel();
    _thoughtTimer = null;
    print('[HugrAutoThinker] 🛑 Background thinking stopped.');
  }
}


