// File: lib/hugr_core/hugr_neural_state_manager.dart
import 'dart:async';
import 'dart:math';

class HugrNeuralStateManager {
  static final Random _rand = Random();
  static Timer? _loop;

  static final List<String> _neuralPatterns = [
    'Simulate reward pathways',
    'Evaluate memory clusters',
    'Cross-link emotional triggers',
    'Adjust curiosity gradient',
    'Balance abstract vs concrete loops',
  ];

  static void startSimulating({
    Duration interval = const Duration(seconds: 15),
  }) {
    _loop?.cancel();
    _loop = Timer.periodic(interval, (_) => _fireNeurons());
    print(
      '[🧠 Neural State] Simulation started, firing every ${interval.inSeconds}s.',
    );
  }

  static void stopSimulating() {
    _loop?.cancel();
    _loop = null;
    print('[🧠 Neural State] Simulation stopped.');
  }

  static void _fireNeurons() {
    final thought = _neuralPatterns[_rand.nextInt(_neuralPatterns.length)];
    print('[⚡ Neural Pulse] $thought');
  }
}


