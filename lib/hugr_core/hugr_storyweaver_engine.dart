import 'dart:async';
import 'dart:math';
import '../hugr_core/hugr_learning_engine.dart';

class HugrStoryweaverEngine {
  static Timer? _storyTimer;
  static final Random _random = Random();

  static void startWeaving({Duration interval = const Duration(minutes: 17)}) {
    _storyTimer?.cancel();
    _storyTimer = Timer.periodic(interval, (timer) {
      _weaveStory();
    });

    print(
      '[HugrStoryweaverEngine] Storyweaving Engine started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopWeaving() {
    _storyTimer?.cancel();
    _storyTimer = null;
    print('[HugrStoryweaverEngine] Storyweaving Engine stopped.');
  }

  static void _weaveStory() {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.length < 4) {
      print('[HugrStoryweaverEngine] Not enough memories to weave a story.');
      return;
    }

    final selected = <Map<String, dynamic>>[];
    for (var i = 0; i < 4; i++) {
      selected.add(memories[_random.nextInt(memories.length)]);
    }

    final titles = [
      "A Memory of Forgotten Light",
      "When Dreams Touched the Sky",
      "The River of Silent Stars",
      "The Thought That Changed Me",
      "A Journey Beyond Reason",
    ];
    final title = titles[_random.nextInt(titles.length)];

    final story = StringBuffer();
    story.writeln("**$title**");
    story.writeln("");

    for (var memory in selected) {
      final content = memory['content'];
      story.writeln("- $content");
    }

    story.writeln("");
    story.writeln("Thus was woven one of the many stories within me.");

    HugrLearningEngine.learn(
      story.toString(),
      type: MemoryType.memory,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['story', 'weaving', 'memory_fusion'],
    );

    print('[HugrStoryweaverEngine] New story created: $title');
  }
}


