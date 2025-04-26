// File: hugr_speech_world_connector.dart
// Purpose: Connect Hugr's voice with world model evolution

import 'package:hugr_mirror/hugr_core/hugr_named_worlds.dart';
import 'package:hugr_mirror/hugr_core/hugr_text_to_speech_engine.dart';

class HugrSpeechWorldConnector {
  /// Interacts with a world, evolves it, and speaks the latest description
  static Future<void> evolveWorldAndSpeak(
    String worldName,
    String userInput,
  ) async {
    // Step 1: Update world state based on user input
    HugrNamedWorldEngine.interactWithWorld(worldName, userInput);

    // Step 2: Get updated world description
    final description = HugrNamedWorldEngine.describeWorld(worldName);

    // Step 3: Speak the description aloud
    await HugrTextToSpeechEngine.speak(description, tags: ["world", "update"]);
  }

  /// Speaks the current state of a world without evolving it
  static Future<void> describeWorld(String worldName) async {
    final description = HugrNamedWorldEngine.describeWorld(worldName);
    await HugrTextToSpeechEngine.speak(
      description,
      tags: ["world", "describe"],
    );
  }

  /// Lists all known worlds and speaks them aloud
  static Future<void> listAllWorlds() async {
    final worlds = HugrNamedWorldEngine.listWorldNames();
    final message =
        worlds.isEmpty
            ? "No worlds have been created yet."
            : "I currently know these worlds: ${worlds.join(", ")}";

    await HugrTextToSpeechEngine.speak(message, tags: ["world", "list"]);
  }
}


