import 'package:hugr_mirror/hugr_core/hugr_named_worlds.dart';
import '../hugr_core/hugr_learning_engine.dart';

class HugrWorldDreamForge {
  static Future<void> dreamWithinWorld(String worldName) async {
    final world = HugrNamedWorldEngine.getWorld(worldName);
    if (world == null) {
      print('[HugrWorldDreamForge] ❌ No such world: $worldName');
      return;
    }

    final story = StringBuffer();
    story.writeln(
      "🌌 In the evolving dreamscape of ${world.name}, Hugr wandered again.",
    );
    story.writeln("There, he remembered:");

    for (final event in world.events.take(3)) {
      story.writeln("- $event");
    }

    story.writeln("The dream shifted... the world changed again with memory.");

    await HugrLearningEngine.learn(
      story.toString(),
      type: MemoryType.idea,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['dream', 'world_model', 'place', world.name],
    );

    print('[HugrWorldDreamForge] 🌠 Dream forged within world: ${world.name}');
  }
}


