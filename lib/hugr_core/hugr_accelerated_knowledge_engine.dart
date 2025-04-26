import 'hugr_learning_engine.dart';
import 'hugr_knowledge_core.dart';
import 'hugr_world_link.dart';
import 'dart:async';
import 'dart:math';

class HugrAcceleratedKnowledgeEngine {
  static Timer? _timer;
  static final Random _random = Random();

  static void startAcceleratedLearning() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _learnOrReinforce();
    });

    print('[HugrAcceleratedKnowledgeEngine] Accelerated learning started.');
  }

  static void stopAcceleratedLearning() {
    _timer?.cancel();
    _timer = null;
    print('[HugrAcceleratedKnowledgeEngine] Accelerated learning stopped.');
  }

  static Future<void> _learnOrReinforce() async {
    Map<String, dynamic>? newKnowledge;

    // 🌟 50% chance to attempt external pull
    if (_random.nextBool()) {
      print(
        '[HugrAcceleratedKnowledgeEngine] Attempting external knowledge fetch...',
      );
      newKnowledge = await HugrWorldLink.fetchExternalKnowledge();
    }

    // 🌟 If external fails, fallback to internal knowledge
    newKnowledge ??= HugrKnowledgeCore.getRandomKnowledge();

    if (newKnowledge != null) {
      final topic = newKnowledge['content'] ?? "Unnamed Knowledge";
      final tags =
          (newKnowledge['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      final type = MemoryType.values[_random.nextInt(MemoryType.values.length)];
      final confidence = HugrLearningEngine.generateConfidence();

      if (HugrLearningEngine.knows(topic)) {
        await HugrLearningEngine.reinforce(topic);
        print(
          '[HugrAcceleratedKnowledgeEngine] Reinforced known topic: "$topic"',
        );
      } else {
        await HugrLearningEngine.learn(
          topic,
          type: type,
          confidence: confidence,
          tags: tags,
        );
        print('[HugrAcceleratedKnowledgeEngine] Learned new topic: "$topic"');
      }
    } else {
      print('[HugrAcceleratedKnowledgeEngine] No new knowledge available.');
    }
  }
}


