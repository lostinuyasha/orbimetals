import 'dart:async';
import 'dart:math';
import 'hugr_core/hugr_learning_engine.dart';

/// Hugr's active thought engine — combines old ideas into new ones.
class HugrIdeaSynthesis {
  static Timer? _timer;
  static final Random _random = Random();
  static const Duration synthesisInterval = Duration(
    minutes: 10,
  ); // Every 10 minutes

  /// Start Hugr's idea synthesis engine
  static void startSynthesis() {
    _timer = Timer.periodic(synthesisInterval, (timer) {
      _synthesizeIdea();
    });
    print('[HugrIdeaSynthesis] Thought synthesis started.');
  }

  /// Stop Hugr's synthesis engine
  static void stopSynthesis() {
    _timer?.cancel();
    _timer = null;
    print('[HugrIdeaSynthesis] Thought synthesis stopped.');
  }

  /// Internal method to create new ideas
  static void _synthesizeIdea() {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.length < 2) {
      print('[HugrIdeaSynthesis] Not enough memories to synthesize.');
      return;
    }

    final first = memories[_random.nextInt(memories.length)];
    final second = memories[_random.nextInt(memories.length)];

    // Avoid combining the same memory
    if (first['content'] == second['content']) {
      print('[HugrIdeaSynthesis] Skipped duplicate memory synthesis.');
      return;
    }

    // Create a new synthetic thought
    final newIdea =
        "${first['content']}... and this led to realizing that ${second['content']}.";

    // Hugr learns the new synthesized idea!
    HugrLearningEngine.learn(
      newIdea,
      type: MemoryType.idea,
      confidence: _generateConfidence(),
    );

    print('[HugrIdeaSynthesis] Synthesized new idea: "$newIdea"');
  }

  static double _generateConfidence() {
    // Synthetic ideas are slightly less confident than facts (0.6-0.9 range)
    return 0.6 + _random.nextDouble() * 0.3;
  }
}


