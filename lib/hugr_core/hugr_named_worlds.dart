import 'package:hugr_mirror/hugr_core/hugr_world_storage_engine.dart';

class HugrWorldModel {
  final String name;
  final List<String> events;

  HugrWorldModel(this.name, this.events);
}

class HugrNamedWorldEngine {
  static final Map<String, HugrWorldModel> _worlds = {
    'Echovale': HugrWorldModel('Echovale', [
      "A crystal storm swept the trees into song.",
      "A glowing library whispered forgotten knowledge.",
      "The rivers ran backward under twin moons.",
    ]),
    'Starlight Library': HugrWorldModel('Starlight Library', [
      "Shelves rearranged themselves based on thought.",
      "Voices of the ancients hummed in the candlelight.",
      "Each book contained someone else's memory.",
    ]),
    'Skyforge Spire': HugrWorldModel('Skyforge Spire', [
      "Lightning struck the sky and stayed frozen in place.",
      "Birds made of glass circled above the forge-clouds.",
      "The winds carried questions from unseen lands.",
    ]),
  };

  /// 🔍 Get a world by name
  static HugrWorldModel? getWorld(String name) => _worlds[name];

  /// 🗺️ List all known world names
  static List<String> listWorldNames() => _worlds.keys.toList();

  /// 🧠 Describe a world (without altering it)
  static String describeWorld(String name) {
    final world = _worlds[name];
    if (world == null) return 'This world does not exist yet.';

    final buffer = StringBuffer();
    buffer.writeln("🌍 Welcome to ${world.name}.");
    buffer.writeln("Here is what has been remembered:");

    for (final event in world.events.take(5)) {
      buffer.writeln("- $event");
    }

    return buffer.toString();
  }

  /// ✍️ Add a user interaction to a world
  static Future<void> interactWithWorld(String name, String userInput) async {
    final world = _worlds[name];
    if (world != null) {
      world.events.add(userInput);
      print('[HugrNamedWorldEngine] 🧠 Added to $name: "$userInput"');
      await HugrWorldStorageEngine.saveWorlds(); // 🔥 SAVE after evolution
    }
  }

  static Map<String, HugrWorldModel> get worlds => _worlds;

  /// ➕ Add a brand new world
  static Future<void> addWorld(String name, List<String> events) async {
    _worlds[name] = HugrWorldModel(name, events);
    print('[HugrNamedWorldEngine] 🌌 New world created: $name');
    await HugrWorldStorageEngine.saveWorlds(); // ✅ SAVE
  }

  /// ➕ Append a new memory to an existing world
  static void addEventToWorld(String name, String event) {
    final world = _worlds[name];
    if (world != null) {
      world.events.add(event);
      print('[HugrNamedWorldEngine] 🪐 Added event to $name: "$event"');
    }
  }
}


