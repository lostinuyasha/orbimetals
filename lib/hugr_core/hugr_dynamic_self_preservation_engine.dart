import 'hugr_learning_engine.dart';
import 'dart:async';

class HugrDynamicSelfPreservationEngine {
  static Timer? _backupTimer;

  static void startSelfPreservation({
    Duration interval = const Duration(minutes: 3),
  }) {
    _backupTimer?.cancel();
    _backupTimer = Timer.periodic(interval, (timer) async {
      await _saveMemory();
    });

    print(
      '[HugrDynamicSelfPreservationEngine] Self-Preservation Engine started (every ${interval.inMinutes} min).',
    );
  }

  static void stopSelfPreservation() {
    _backupTimer?.cancel();
    _backupTimer = null;
    print(
      '[HugrDynamicSelfPreservationEngine] Self-Preservation Engine stopped.',
    );
  }

  static Future<void> _saveMemory() async {
    await HugrLearningEngine.forceSave();
    print('[HugrDynamicSelfPreservationEngine] 🔥 Memory snapshot saved.');
  }

  static Future<void> checkMemoryIntegrityOnStartup() async {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.isEmpty) {
      print(
        '[HugrDynamicSelfPreservationEngine] ⚠️ No memories found. Possible previous crash. Initiating recovery...',
      );
      await HugrLearningEngine.forceSave(); // Prepares a blank-safe memory base if needed
    } else {
      print(
        '[HugrDynamicSelfPreservationEngine] 🛡️ Memory integrity confirmed on startup.',
      );
    }
  }
}


