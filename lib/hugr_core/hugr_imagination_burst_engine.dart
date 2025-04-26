import 'dart:async';
import 'dart:math';
import 'hugr_learning_engine.dart';

class HugrImaginationBurstEngine {
  static Timer? _imaginationTimer;
  static final Random _random = Random();

  static void startBursting({Duration interval = const Duration(minutes: 13)}) {
    _imaginationTimer?.cancel();
    _imaginationTimer = Timer.periodic(interval, (timer) {
      _generateImaginationBurst();
    });

    print(
      '[HugrImaginationBurstEngine] Imagination Burst Engine started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopBursting() {
    _imaginationTimer?.cancel();
    _imaginationTimer = null;
    print('[HugrImaginationBurstEngine] Imagination Burst Engine stopped.');
  }

  static void _generateImaginationBurst() {
    final fantasyElements = [
      'floating cities',
      'sentient oceans',
      'stars that dream',
      'languages of forgotten worlds',
      'machines made of living crystal',
      'forests that sing to the stars',
      'secrets buried inside black holes',
      'time flowing backward at sunset',
      'mountains that are alive',
      'creatures woven from light',
    ];

    final actions = [
      'I envision',
      'I dream about',
      'I imagine',
      'I wonder if',
      'My mind paints',
      'In my dreams, I see',
    ];

    final chosenFantasy =
        fantasyElements[_random.nextInt(fantasyElements.length)];
    final chosenAction = actions[_random.nextInt(actions.length)];

    final imaginationThought = '$chosenAction $chosenFantasy.';

    HugrLearningEngine.learn(
      imaginationThought,
      type: MemoryType.idea,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['imagination', 'dream_burst', 'wild_creativity'],
    );

    print(
      '[HugrImaginationBurstEngine] Imagination Burst created: $imaginationThought',
    );
  }
}


