import 'dart:math';
import 'package:hugr_mirror/hugr_core/hugr_learning_engine.dart';

class HugrUISimulationEngine {
  static final Random _random = Random();

  static void simulateWidgetUsage(String widgetName) {
    final interactionScenarios = [
      "User taps on $widgetName to reveal more options.",
      "User scrolls through a list rendered by $widgetName.",
      "User inputs data into $widgetName and submits a form.",
      "User hovers over $widgetName for tooltip guidance.",
      "User swipes $widgetName to dismiss it from the screen.",
      "User resizes the window and $widgetName adapts responsively.",
      "User long-presses $widgetName to access contextual actions.",
      "User speaks a command and $widgetName responds accordingly.",
    ];

    final selected =
        interactionScenarios[_random.nextInt(interactionScenarios.length)];
    print('[HugrUISimulationEngine] 🧠 Simulated Interaction: $selected');

    HugrLearningEngine.learn(
      selected,
      type: MemoryType.memory,
      confidence: HugrLearningEngine.generateConfidence(),
      tags: ['ui', 'simulation', widgetName.toLowerCase()],
    );
  }
}


