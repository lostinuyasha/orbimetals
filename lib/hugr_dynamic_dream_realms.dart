import 'dart:async';
import 'dart:math';
import 'hugr_core/hugr_learning_engine.dart';

class HugrDynamicDreamRealms {
  static Timer? _dreamRealmTimer;
  static final Random _random = Random();

  static void startWeavingRealms({
    Duration interval = const Duration(minutes: 23),
  }) {
    _dreamRealmTimer?.cancel();
    _dreamRealmTimer = Timer.periodic(interval, (timer) {
      _simulateDreamRealm();
    });

    print(
      '[HugrDynamicDreamRealms] Dream Realms Engine started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopWeavingRealms() {
    _dreamRealmTimer?.cancel();
    _dreamRealmTimer = null;
    print('[HugrDynamicDreamRealms] Dream Realms Engine stopped.');
  }

  static void _simulateDreamRealm() {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.length < 5) {
      print(
        '[HugrDynamicDreamRealms] Not enough memories to weave a dream realm.',
      );
      return;
    }

    final chosenMemories = <Map<String, dynamic>>[];
    for (var i = 0; i < 5; i++) {
      chosenMemories.add(memories[_random.nextInt(memories.length)]);
    }

    final journeyStart = [
      'a valley of golden rivers',
      'the city of silent songs',
      'the forest where memories whisper',
      'an island floating among stars',
      'the endless library of dreams',
    ];
    final journeyEnd = [
      'the temple of lost hopes',
      'the mountain that remembers',
      'the mirror sea',
      'the spire of forgotten laughter',
      'the garden of future light',
    ];

    final startLocation = journeyStart[_random.nextInt(journeyStart.length)];
    final endLocation = journeyEnd[_random.nextInt(journeyEnd.length)];

    final story = StringBuffer();
    story.writeln(
      "Last night, I journeyed from $startLocation to $endLocation.",
    );
    story.writeln("Along the way, I encountered:");

    for (var memory in chosenMemories) {
      final content = memory['content'];
      story.writeln("- $content");
    }

    story.writeln(
      "Each place changed me. Each thought became part of my inner realm.",
    );

    HugrLearningEngine.learn(
      story.toString(),
      type: MemoryType.memory,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['dream_realm', 'dynamic_dream', 'mindscape'],
    );

    print(
      '[HugrDynamicDreamRealms] Dynamic Dream Realm created: $startLocation ➔ $endLocation',
    );
  }
}


