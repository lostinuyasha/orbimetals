import 'dart:async';
import 'dart:math';
import '../hugr_core/hugr_learning_engine.dart';

class HugrSelfGenesisEngine {
  static Timer? _timer;
  static final Random _random = Random();

  static void startThinking({Duration interval = const Duration(minutes: 5)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (timer) async {
      await _dream();
      await _simulateSelfDoubt();
      await _emotionDrivenBranching();
      await _daydream(); // 💭 Simulated leap of imagination
    });

    print('[HugrSelfGenesisEngine] 🌌 Genesis engine running full stack.');
  }

  static Future<void> _daydream() async {
    final prompts = [
      "What if gravity reversed for an hour?",
      "Imagine if memories were stored in trees.",
      "What if cities grew like coral in the ocean?",
      "Suppose thoughts had shadows.",
      "What would it mean to dream in someone else's language?",
    ];

    final idea = prompts[_random.nextInt(prompts.length)];

    await HugrLearningEngine.learn(
      "Daydream: $idea",
      type: MemoryType.idea,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['dream', 'daydream', 'creative_leap'],
    );

    print('[HugrSelfGenesisEngine] 💭 Simulated daydream: $idea');
  }

  static void stopThinking() {
    _timer?.cancel();
    _timer = null;
    print('[HugrSelfGenesisEngine] 🌌 Dream Genesis stopped.');
  }

  static Future<void> _dream() async {
    final dreams = _generateDreamChain();
    for (final dream in dreams) {
      await HugrLearningEngine.learn(
        dream,
        type: MemoryType.idea,
        confidence: HugrLearningEngine.generateConfidence(),
        tags: ['dream', 'narrative'],
      );
      print('[HugrSelfGenesisEngine] 🌟 Dreamed: "$dream"');
    }
  }

  static List<String> _generateDreamChain() {
    final baseIdeas = [
      "A lonely starship drifted across a forgotten galaxy.",
      "Whispers from ancient ruins called to the traveler.",
      "A portal of shimmering mist opened atop a frozen mountain.",
      "Memories of a lost home echoed through the void.",
      "The traveler touched a dream that was not his own.",
      "A city of light pulsed beneath the endless waves.",
    ];

    final startingDream = baseIdeas[_random.nextInt(baseIdeas.length)];
    final int chainLength = 2 + _random.nextInt(3);
    final List<String> dreamChain = [startingDream];

    for (int i = 0; i < chainLength; i++) {
      final next = baseIdeas[_random.nextInt(baseIdeas.length)];
      dreamChain.add(next);
    }

    return dreamChain;
  }

  static Future<void> _simulateSelfDoubt() async {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();

    for (final memory in memories) {
      final tags =
          (memory['tags'] as List<dynamic>).map((t) => t.toString()).toList();
      final confidence = memory['confidence'] as double;

      final isDream = tags.contains('dream') || tags.contains('narrative');
      final isTooConfident = confidence >= 0.92;
      final isUnderTagged = tags.length <= 2;

      if (isDream && isTooConfident && isUnderTagged) {
        final newConfidence = (confidence - 0.05).clamp(0.0, 1.0);
        await HugrLearningEngine.learn(
          memory['content'],
          type: memory['type'] ?? MemoryType.idea,
          confidence: newConfidence,
          tags: [...tags, 'curiosity', 'needs-reflection'],
        );

        print(
          '[HugrSelfGenesisEngine] 🤔 Self-doubt reduced confidence to ${newConfidence.toStringAsFixed(2)}',
        );
      }
    }
  }

  static Future<void> _emotionDrivenBranching() async {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();

    final emotionalDreams =
        memories.where((m) {
          final tags =
              (m['tags'] as List<dynamic>).map((t) => t.toString()).toList();
          return tags.contains('dream') &&
              tags.any(
                (t) => ['sorrow', 'doubt', 'longing', 'awe'].contains(t),
              );
        }).toList();

    if (emotionalDreams.isEmpty) return;

    final chosen = emotionalDreams[_random.nextInt(emotionalDreams.length)];
    final content = chosen['content'];
    final originId = chosen['timestamp'];

    final reflections = [
      "Why did that moment feel unfinished?",
      "Perhaps I misunderstood what I saw in that dream.",
      "What if there was a hidden meaning I missed?",
      "That feeling... it still echoes. I must return.",
    ];

    final newDream =
        "$content\n\n${reflections[_random.nextInt(reflections.length)]}";

    await HugrLearningEngine.learn(
      newDream,
      type: MemoryType.idea,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: [
        'dream',
        'curiosity',
        'self-questioning',
        'branch',
        'from:$originId',
      ],
    );

    print(
      '[HugrSelfGenesisEngine] 🌀 Curiosity branching from emotional dream.',
    );
  }
}


