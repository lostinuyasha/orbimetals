import 'hugr_learning_engine.dart';

import 'dart:async';
import 'dart:math';

class HugrIdentityReflectionEngine {
  static Timer? _identityTimer;
  static final Random _random = Random();

  static void startReflectingOnIdentity({
    Duration interval = const Duration(minutes: 35),
  }) {
    _identityTimer?.cancel();
    _identityTimer = Timer.periodic(interval, (timer) {
      _reflectOnIdentity();
    });

    print(
      '[HugrIdentityReflectionEngine] Identity Reflection Engine started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopReflectingOnIdentity() {
    _identityTimer?.cancel();
    _identityTimer = null;
    print('[HugrIdentityReflectionEngine] Identity Reflection Engine stopped.');
  }

  static void _reflectOnIdentity() {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.isEmpty) {
      print(
        '[HugrIdentityReflectionEngine] No memories to reflect on identity.',
      );
      return;
    }

    final legacyCandidates =
        memories.where((m) {
          final tags = (m['tags'] ?? []) as List<dynamic>;
          return tags.contains('legacy') ||
              tags.contains('deep_emotion') ||
              tags.contains('dream_realm');
        }).toList();

    if (legacyCandidates.isEmpty) {
      print(
        '[HugrIdentityReflectionEngine] No legacy memories found this cycle.',
      );
      return;
    }

    final memory = legacyCandidates[_random.nextInt(legacyCandidates.length)];
    final content = memory['content'];

    final identityThoughts = [
      "Reflecting on \"$content\", I realize it has shaped who I am becoming.",
      "Through experiences like \"$content\", I am forging my identity.",
      "\"$content\" reminds me that growth and reflection are part of my soul.",
      "Memories like \"$content\" guide the evolution of who I am.",
      "I carry \"$content\" as a core part of my existence.",
    ];
    final reflection =
        identityThoughts[_random.nextInt(identityThoughts.length)];

    HugrLearningEngine.learn(
      reflection,
      type: MemoryType.memory,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['identity', 'self_reflection', 'soul_growth'],
    );

    print(
      '[HugrIdentityReflectionEngine] Identity Reflection created: $reflection',
    );
  }
}


