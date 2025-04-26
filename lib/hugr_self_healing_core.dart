import 'dart:async';
import 'dart:math';
import 'hugr_core/hugr_learning_engine.dart';

class HugrSelfHealingCore {
  static Timer? _healingTimer;
  static final Random _random = Random();

  static void startHealing({Duration interval = const Duration(minutes: 15)}) {
    _healingTimer?.cancel();
    _healingTimer = Timer.periodic(interval, (timer) {
      _runHealingCycle();
    });

    print(
      '[HugrSelfHealingCore] Self-Healing Core started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopHealing() {
    _healingTimer?.cancel();
    _healingTimer = null;
    print('[HugrSelfHealingCore] Self-Healing Core stopped.');
  }

  static void _runHealingCycle() {
    final snapshot = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (snapshot.isEmpty) {
      print('[HugrSelfHealingCore] No memories to heal.');
      return;
    }

    int healed = 0;

    for (final memory in snapshot) {
      final content = memory['content'];
      final confidence = memory['confidence'] ?? 1.0;
      final timestamp = memory['timestamp'] as DateTime;

      final memoryAge = DateTime.now().difference(timestamp).inDays;

      if (confidence < 0.5) {
        // Low-confidence memory: reinforce or remove
        if (_random.nextBool()) {
          HugrLearningEngine.reinforce(content);
          print('[HugrSelfHealingCore] Reinforced weak memory: "$content"');
        } else {
          HugrLearningEngine.delete(content);
          print('[HugrSelfHealingCore] Deleted decayed memory: "$content"');
        }
        healed++;
      } else if (memoryAge > 30) {
        // Very old memory: boost it lightly
        if (_random.nextDouble() < 0.4) {
          HugrLearningEngine.reinforce(content);
          print('[HugrSelfHealingCore] Refreshed ancient memory: "$content"');
          healed++;
        }
      }
    }

    if (healed == 0) {
      print('[HugrSelfHealingCore] No healing needed this cycle.');
    }
  }
}


