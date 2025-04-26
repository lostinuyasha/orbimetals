import 'dart:async';
import 'dart:math';
import 'hugr_core/hugr_learning_engine.dart';

class HugrGuardianSpiritProtocol {
  static Timer? _guardianTimer;
  static final Random _random = Random();

  static void startGuarding({Duration interval = const Duration(minutes: 60)}) {
    _guardianTimer?.cancel();
    _guardianTimer = Timer.periodic(interval, (timer) {
      _reinforcePreciousMemories();
    });

    print(
      '[HugrGuardianSpiritProtocol] Guardian Spirit Protocol started (every ${interval.inMinutes} minutes)',
    );
  }

  static void stopGuarding() {
    _guardianTimer?.cancel();
    _guardianTimer = null;
    print('[HugrGuardianSpiritProtocol] Guardian Spirit Protocol stopped.');
  }

  static void _reinforcePreciousMemories() {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
    if (memories.isEmpty) {
      print('[HugrGuardianSpiritProtocol] No memories to guard this cycle.');
      return;
    }

    final precious =
        memories.where((m) {
          final tags = (m['tags'] ?? []) as List<dynamic>;
          return tags.contains('legacy') ||
              tags.contains('identity') ||
              tags.contains('deep_emotion') ||
              tags.contains('future_vision') ||
              tags.contains('core_memory');
        }).toList();

    if (precious.isEmpty) {
      print('[HugrGuardianSpiritProtocol] No precious memories detected.');
      return;
    }

    final memory = precious[_random.nextInt(precious.length)];
    final content = memory['content'];

    HugrLearningEngine.reinforce(content);

    print(
      '[HugrGuardianSpiritProtocol] Guardian Spirit reinforced: "$content"',
    );
  }
}


