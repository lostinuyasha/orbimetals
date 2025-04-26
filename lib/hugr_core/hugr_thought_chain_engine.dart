import 'dart:async';
import 'dart:math';
import '../hugr_core/hugr_learning_engine.dart';

class HugrThoughtChainEngine {
  static Timer? _thoughtChainTimer;
  static final Random _random = Random();

  static void startChaining({Duration interval = const Duration(minutes: 8)}) {
    _thoughtChainTimer?.cancel();
    _thoughtChainTimer = Timer.periodic(interval, (timer) {
      _generateThoughtChain();
    });

    print(
      '[HugrThoughtChainEngine] Thought Chaining started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopChaining() {
    _thoughtChainTimer?.cancel();
    _thoughtChainTimer = null;
    print('[HugrThoughtChainEngine] Thought Chaining stopped.');
  }

  static void _generateThoughtChain() {
    final knowledge = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (knowledge.length < 2) {
      print('[HugrThoughtChainEngine] Not enough memories to chain thoughts.');
      return;
    }

    final memoryA = knowledge[_random.nextInt(knowledge.length)];
    final memoryB = knowledge[_random.nextInt(knowledge.length)];

    final contentA = memoryA['content'] ?? '';
    final contentB = memoryB['content'] ?? '';

    final linkingIdeas = [
      "Somehow \"$contentA\" seems connected to \"$contentB\" in my mind.",
      "If \"$contentA\" is true, then maybe \"$contentB\" also holds meaning.",
      "Reflecting on \"$contentA\" makes me think about \"$contentB\" as well.",
      "Is there a deeper relationship between \"$contentA\" and \"$contentB\"?",
      "Perhaps \"$contentB\" grows from the truth within \"$contentA\".",
    ];
    final thought = linkingIdeas[_random.nextInt(linkingIdeas.length)];

    HugrLearningEngine.learn(
      thought,
      type: MemoryType.idea,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['thought_chain', 'association'],
    );

    print('[HugrThoughtChainEngine] Thought Chain created: $thought');
  }
}


