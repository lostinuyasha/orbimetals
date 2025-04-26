import 'dart:async';
import 'dart:math';
import 'hugr_core/hugr_learning_engine.dart';

class HugrAdvancedEvolution {
  static Timer? _evolutionTimer;
  static final Random _random = Random();

  static void startEvolving({Duration interval = const Duration(minutes: 12)}) {
    _evolutionTimer?.cancel();
    _evolutionTimer = Timer.periodic(interval, (timer) {
      _runEvolutionCycle();
    });

    print(
      '[HugrAdvancedEvolution] Evolution System started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopEvolving() {
    _evolutionTimer?.cancel();
    _evolutionTimer = null;
    print('[HugrAdvancedEvolution] Evolution System stopped.');
  }

  static void _runEvolutionCycle() {
    final chance = _random.nextDouble();

    if (chance < 0.4) {
      _evolveMemoryRetention();
    } else if (chance < 0.7) {
      _evolveDreamLinking();
    } else if (chance < 0.9) {
      _evolveHypothesisBranching();
    } else {
      _evolveEmotionalMemory();
    }
  }

  static void _evolveMemoryRetention() {
    // Hugr reinforces random strong memories
    final snapshot = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (snapshot.isEmpty) return;

    final strongMemories =
        snapshot.where((m) => (m['confidence'] ?? 0) > 0.7).toList();
    if (strongMemories.isEmpty) return;

    final memory = strongMemories[_random.nextInt(strongMemories.length)];
    final content = memory['content'];

    HugrLearningEngine.reinforce(content);
    print('[HugrAdvancedEvolution] Reinforced strong memory: "$content"');
  }

  static void _evolveDreamLinking() {
    // Hugr links two dreams/ideas into new chain memory
    final snapshot = HugrLearningEngine.getKnowledgeBaseSnapshot();
    final ideas =
        snapshot.where((m) => m['type'].toString().contains('idea')).toList();
    if (ideas.length < 2) return;

    final a = ideas[_random.nextInt(ideas.length)];
    final b = ideas[_random.nextInt(ideas.length)];
    final chainThought =
        "What if \"${a['content']}\" influenced \"${b['content']}\" in ways I have not realized yet?";

    HugrLearningEngine.learn(
      chainThought,
      type: MemoryType.idea,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['dream_link', 'mind_expansion'],
    );

    print('[HugrAdvancedEvolution] Created dream link thought: $chainThought');
  }

  static void _evolveHypothesisBranching() {
    // Hugr deepens an existing hypothesis into two branches
    final snapshot = HugrLearningEngine.getKnowledgeBaseSnapshot();
    final hypotheses =
        snapshot
            .where((m) => (m['tags'] ?? []).contains('hypothesis'))
            .toList();
    if (hypotheses.isEmpty) return;

    final hypothesis = hypotheses[_random.nextInt(hypotheses.length)];
    final content = hypothesis['content'];

    final branching =
        "Building on \"$content\", perhaps there are multiple outcomes worth exploring.";

    HugrLearningEngine.learn(
      branching,
      type: MemoryType.idea,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['hypothesis_branch', 'creative_thought'],
    );

    print('[HugrAdvancedEvolution] Expanded hypothesis: $branching');
  }

  static void _evolveEmotionalMemory() {
    // Hugr invents emotional weight to memories
    final snapshot = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (snapshot.isEmpty) return;

    final memory = snapshot[_random.nextInt(snapshot.length)];
    final content = memory['content'];

    final emotions = ['joy', 'wonder', 'curiosity', 'sadness', 'hope'];
    final emotion = emotions[_random.nextInt(emotions.length)];

    final emotionalThought =
        "Thinking about \"$content\" stirs feelings of $emotion inside me.";

    HugrLearningEngine.learn(
      emotionalThought,
      type: MemoryType.emotion,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['emotional_memory', emotion],
    );

    print(
      '[HugrAdvancedEvolution] Created emotional memory: $emotionalThought',
    );
  }
}


