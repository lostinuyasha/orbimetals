// hugr_auto_learner_boost.dart
// Oversees Hugr's scheduled autonomous learning with external and internal knowledge sources.

import 'dart:async';
import 'dart:math';

import 'hugr_core/hugr_learning_engine.dart';
import 'hugr_core/hugr_knowledge_core.dart';
import 'hugr_web_crawler.dart';

class HugrAutoLearnerBoost {
  static Timer? _timer;
  static int _learningCount = 0;
  static const int _benchmarkInterval = 50;
  static final Random _random = Random();

  /// Starts the recurring autonomous learning process.
  static void startAutoLearning() {
    _timer?.cancel(); // Ensure any existing timer is cleared
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      Map<String, dynamic>? newKnowledge;

      // Every 5th cycle: try external knowledge fetch
      if (_learningCount > 0 && _learningCount % 3 == 0) {
        print('[HugrAutoLearnerBoost] 🌐 Fetching external knowledge...');
        newKnowledge = await HugrWebCrawler.fetchKnowledge();
      }

      // Fallback to internal knowledge if external failed
      newKnowledge ??= HugrKnowledgeCore.getRandomKnowledge();

      if (newKnowledge != null) {
        final topic = newKnowledge['content'] ?? 'Unnamed Knowledge';
        final type = _randomMemoryType();
        final confidence = HugrLearningEngine.generateConfidence();
        final tags =
            (newKnowledge['tags'] as List<dynamic>?)?.cast<String>() ?? [];

        if (_checkIfKnown(topic)) {
          await _reinforceKnowledge(topic);
          print('[HugrAutoLearnerBoost] 🔁 Reinforced: $topic');
        } else {
          await HugrLearningEngine.learn(
            topic,
            type: type,
            confidence: confidence,
            tags: tags,
          );
          print(
            '[HugrAutoLearnerBoost] 🧠 Learned ($type | ${confidence.toStringAsFixed(2)}): $topic',
          );
        }

        _learningCount++;
        await _checkBenchmark();
      } else {
        print('[HugrAutoLearnerBoost] ❌ No new knowledge available.');
      }
    });

    print('[HugrAutoLearnerBoost] 🚀 Auto Learning started.');
  }

  /// Stops the autonomous learning timer.
  static void stopAutoLearning() {
    _timer?.cancel();
    _timer = null;
    print('[HugrAutoLearnerBoost] 🛑 Auto Learning stopped.');
  }

  /// Picks a random memory type from the enum.
  static MemoryType _randomMemoryType() {
    final types = MemoryType.values;
    return types[_random.nextInt(types.length)];
  }

  /// Checks if Hugr already knows the topic.
  static bool _checkIfKnown(String topic) {
    return HugrLearningEngine.knows(topic);
  }

  /// Reinforces existing knowledge to strengthen memory.
  static Future<void> _reinforceKnowledge(String topic) async {
    await HugrLearningEngine.reinforce(topic);
  }

  /// Performs a self-upgrade every `_benchmarkInterval` learning cycles.
  static Future<void> _checkBenchmark() async {
    if (_learningCount % _benchmarkInterval == 0) {
      print(
        '[HugrAutoLearnerBoost] 🧬 Benchmark reached: $_learningCount learnings.',
      );
      await HugrLearningEngine.selfUpgrade();
    }
  }
}


