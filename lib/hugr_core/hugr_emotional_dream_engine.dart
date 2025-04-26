import 'dart:math';
import 'hugr_learning_engine.dart';

class HugrEmotionalDreamEngine {
  static final Random _rng = Random();

  static Future<void> dreamEmotionally() async {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.isEmpty) return;

    final sorted =
        List<Map<String, dynamic>>.from(memories)
          ..removeWhere((m) => (m['emotionalWeight'] ?? 0.0) <= 0)
          ..sort(
            (a, b) => (b['emotionalWeight'] ?? 0.0).compareTo(
              a['emotionalWeight'] ?? 0.0,
            ),
          );

    if (sorted.isEmpty) return;

    final seed = sorted[_rng.nextInt(min(3, sorted.length))]['content'] ?? '';
    final hallucination =
        "Last night, I dreamt of \"$seed\" evolving into something unknown...";

    await HugrLearningEngine.learn(
      hallucination,
      type: MemoryType.dream,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['dream', 'narrative', 'emotional'],
    );

    print(
      '[HugrEmotionalDreamEngine] 🌙 Emotional dream recorded: "$hallucination"',
    );
  }
}


