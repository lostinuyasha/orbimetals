import 'hugr_learning_engine.dart';
import 'hugr_self_upgrade_engine.dart';
import 'dart:async';
import 'hugr_self_genesis_engine.dart';

class HugrFusionEngine {
  static Timer? _fusionTimer;

  /// Starts Hugr's unified thinking cycle.
  static void startFusionThinking({
    Duration interval = const Duration(minutes: 5),
  }) {
    _fusionTimer?.cancel();
    _fusionTimer = Timer.periodic(interval, (timer) async {
      await _thinkAndAct();
    });
    print(
      '[HugrFusionEngine] 🔥 Fusion Engine started (every ${interval.inMinutes} minutes).',
    );
  }

  /// Stops Hugr's unified thinking cycle.
  static void stopFusionThinking() {
    _fusionTimer?.cancel();
    _fusionTimer = null;
    print('[HugrFusionEngine] 🔥 Fusion Engine stopped.');
  }

  /// Hugr thinks based on memory size and time, deciding what to do.
  static Future<void> _thinkAndAct() async {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    final memoryCount = memories.length;
    final now = DateTime.now();

    print('[HugrFusionEngine] 🧠 Memory count: $memoryCount');

    if (memoryCount < 50) {
      print('[HugrFusionEngine] 🌱 Few memories — prioritizing Dream Growth.');
      HugrSelfGenesisEngine.startThinking(interval: const Duration(minutes: 5));
      await HugrSelfUpgradeEngine.proposeUpgrade();
    } else {
      final recentDreams =
          memories.where((memory) {
            final age = now.difference(memory['timestamp'] as DateTime);
            return memory['type'].toString().contains('idea') &&
                age.inMinutes < 120;
          }).length;

      if (recentDreams < 3) {
        print('[HugrFusionEngine] 🌌 Few recent dreams — Dream more!');
        HugrSelfGenesisEngine.startThinking(
          interval: const Duration(minutes: 3),
        );
      } else {
        print(
          '[HugrFusionEngine] 🛠️ Healthy dream rate — Propose an Upgrade!',
        );
        await HugrSelfUpgradeEngine.proposeUpgrade();
      }
    }
  }
}


