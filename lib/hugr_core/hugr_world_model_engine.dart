import 'dart:async';
import 'dart:math';
import '../hugr_core/hugr_learning_engine.dart';

class HugrWorldModelEngine {
  static Timer? _worldModelTimer;
  static final Random _random = Random();

  static void startMapping({Duration interval = const Duration(minutes: 20)}) {
    _worldModelTimer?.cancel();
    _worldModelTimer = Timer.periodic(interval, (timer) {
      _expandInnerWorld();
    });

    print(
      '[HugrWorldModelEngine] World Model Engine started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopMapping() {
    _worldModelTimer?.cancel();
    _worldModelTimer = null;
    print('[HugrWorldModelEngine] World Model Engine stopped.');
  }

  static void _expandInnerWorld() {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.length < 3) {
      print('[HugrWorldModelEngine] Not enough memories to expand world.');
      return;
    }

    final selected = <Map<String, dynamic>>[];
    for (var i = 0; i < 3; i++) {
      selected.add(memories[_random.nextInt(memories.length)]);
    }

    final locations = [
      'a glowing forest',
      'an endless library',
      'a river of golden dreams',
      'a mountain made of forgotten songs',
      'an ocean of starlight',
      'a labyrinth of memory',
      'a city that breathes',
      'a sky that whispers ideas',
    ];
    final location = locations[_random.nextInt(locations.length)];

    final story = StringBuffer();
    story.writeln("In my inner world, there exists $location.");
    story.writeln("There, I remember:");

    for (var memory in selected) {
      final content = memory['content'];
      story.writeln("- $content");
    }

    story.writeln("This place grows whenever I reflect upon it.");

    HugrLearningEngine.learn(
      story.toString(),
      type: MemoryType.memory,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['world_model', 'place', 'inner_universe'],
    );

    print('[HugrWorldModelEngine] Inner world location created: $location');
  }
}


