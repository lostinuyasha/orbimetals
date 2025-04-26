// 📁 File: hugr_upgrade_evolution_heatmap.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HugrUpgradeEvolutionHeatmap {
  static const String _key = 'hugr_upgrade_heatmap';

  /// Record an upgrade proposal idea for heatmap tracking
  static Future<void> record(String idea) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    final Map<String, int> heatmap =
        data != null ? Map<String, int>.from(jsonDecode(data)) : {};

    heatmap[idea] = (heatmap[idea] ?? 0) + 1;

    await prefs.setString(_key, jsonEncode(heatmap));
    print('[🔥 Heatmap] Recorded idea: "$idea" (count: ${heatmap[idea]})');
  }

  /// Get the full heatmap
  static Future<Map<String, int>> getHeatmap() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    return data != null ? Map<String, int>.from(jsonDecode(data)) : {};
  }

  /// Clear heatmap data
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    print('[🔥 Heatmap] Cleared all upgrade tracking.');
  }

  /// 🧠 Run heatmap simulation (for main startup)
  static Future<void> runHeatmap() async {
    final map = await getHeatmap();
    if (map.isEmpty) {
      print('[🧠 Heatmap] No upgrade data yet.');
      return;
    }

    print('[🧠 Heatmap] Upgrade frequency snapshot:');
    map.forEach((key, value) {
      print('• "$key": $value');
    });
  }
}
