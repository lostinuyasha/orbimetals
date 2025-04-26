// 📁 File: hugr_apex_memory_engine.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HugrApexMemoryEngine {
  static const _storageKey = 'hugr_apex_trading_memory';

  /// Save a new trade memory
  static Future<void> saveTradeMemory({
    required String symbol,
    required String direction,
    required double entryPrice,
    required double exitPrice,
    required double profitLoss,
    required double accountBalance,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList(_storageKey) ?? [];

    final memory = {
      'symbol': symbol,
      'direction': direction,
      'entryPrice': entryPrice,
      'exitPrice': exitPrice,
      'profitLoss': profitLoss,
      'accountBalance': accountBalance,
      'timestamp': DateTime.now().toIso8601String(),
    };

    existing.add(jsonEncode(memory));
    await prefs.setStringList(_storageKey, existing);

    print('[HugrApexMemoryEngine] 🧠 Trade Memory Saved: \$symbol \$direction');
  }

  /// Load all trade memories
  static Future<List<Map<String, dynamic>>> loadMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList(_storageKey) ?? [];

    return raw.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
  }

  /// Clear memories (optional)
  static Future<void> clearMemories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    print('[HugrApexMemoryEngine] 🔥 Cleared all trade memories.');
  }
}
