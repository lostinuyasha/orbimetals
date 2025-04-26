import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'hugr_named_worlds.dart';

class HugrWorldStorageEngine {
  static const _fileName = 'hugr_worlds.json';

  /// 📤 Save all current world data to disk
  static Future<void> saveWorlds() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');

    final Map<String, dynamic> worldMap = {};

    HugrNamedWorldEngine.worlds.forEach((key, world) {
      worldMap[key] = {'name': world.name, 'events': world.events};
    });

    await file.writeAsString(jsonEncode(worldMap));
    print('[HugrWorldStorage] 💾 Worlds saved to ${file.path}');
  }

  /// 📥 Load saved world data into Hugr’s memory
  static Future<void> loadWorlds() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');

    if (!await file.exists()) {
      print('[HugrWorldStorage] ⚠️ No saved world file found.');
      return;
    }

    final jsonString = await file.readAsString();
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

    HugrNamedWorldEngine.worlds.clear();
    decoded.forEach((key, value) {
      final events = List<String>.from(value['events'] ?? []);
      HugrNamedWorldEngine.worlds[key] = HugrWorldModel(key, events);
    });

    print('[HugrWorldStorage] 🔄 Worlds restored from storage.');
  }

  /// 🔥 Wipe saved worlds from disk (if needed)
  static Future<void> clearSavedWorlds() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');

    if (await file.exists()) {
      await file.delete();
      print('[HugrWorldStorage] ❌ Worlds deleted from disk.');
    }
  }
}


