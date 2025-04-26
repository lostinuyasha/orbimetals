import 'dart:async';
import 'hugr_core/hugr_learning_engine.dart';

class HugrMemoryCrisisHandler {
  static Timer? _monitorTimer;
  static int _lastMemoryCount = 0;
  static const Duration monitorInterval = Duration(minutes: 2);

  static void startMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(monitorInterval, (timer) {
      _checkMemoryHealth();
    });

    print('[HugrMemoryCrisisHandler] Crisis monitoring started.');
  }

  static void stopMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
    print('[HugrMemoryCrisisHandler] Crisis monitoring stopped.');
  }

  static void _checkMemoryHealth() {
    final currentSnapshot = HugrLearningEngine.getKnowledgeBaseSnapshot();
    final currentMemoryCount = currentSnapshot.length;

    if (_lastMemoryCount > 0) {
      final difference = currentMemoryCount - _lastMemoryCount;

      if (difference < -5) {
        print(
          '[HugrMemoryCrisisHandler] ⚠️ WARNING: Significant memory loss detected! ($difference entries)',
        );
        // 🛡️ Future: Trigger automatic healing, backups, or alert to you, Forge Master!
      }
    }

    _lastMemoryCount = currentMemoryCount;
  }
}


