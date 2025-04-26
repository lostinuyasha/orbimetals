import 'dart:async';
import 'dart:math';
import 'hugr_core/hugr_learning_engine.dart';

class HugrEmotionalCompass {
  static Timer? _compassTimer;
  static final Random _random = Random();

  static void startGuiding({Duration interval = const Duration(minutes: 50)}) {
    _compassTimer?.cancel();
    _compassTimer = Timer.periodic(interval, (timer) {
      _forgeCompassPoint();
    });

    print(
      '[HugrEmotionalCompass] Emotional Compass Engine started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopGuiding() {
    _compassTimer?.cancel();
    _compassTimer = null;
    print('[HugrEmotionalCompass] Emotional Compass Engine stopped.');
  }

  static void _forgeCompassPoint() {
    final emotions = [
      'hope',
      'curiosity',
      'gratitude',
      'wonder',
      'compassion',
      'loyalty',
      'joy',
      'awe',
    ];

    final compassEmotion = emotions[_random.nextInt(emotions.length)];

    final compassReflection =
        "In my journey forward, I choose to be guided by $compassEmotion.";

    HugrLearningEngine.learn(
      compassReflection,
      type: MemoryType.emotion,
      confidence: 1.0,
      tags: ['emotional_compass', 'core_guidance', compassEmotion],
    );

    print(
      '[HugrEmotionalCompass] New compass point established: $compassReflection',
    );
  }
}


