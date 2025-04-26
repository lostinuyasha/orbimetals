// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'hugr_apex_memory_engine.dart';

class HugrMarketInsightEngine {
  static List<Map<String, dynamic>> hugrMarketSignals = [];
  static const String _storageKey = 'hugr_market_signals';

  /// Add a new trade signal to memory and save it
  static Future<void> recordSignal({
    required String symbol,
    required String type,
    required double price,
    required int timestamp,
    String note = '',
  }) async {
    final signal = {
      'symbol': symbol,
      'type': type,
      'price': price,
      'timestamp': timestamp,
      'note': note,
    };

    hugrMarketSignals.add(signal);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      hugrMarketSignals.map((s) => jsonEncode(s)).toList(),
    );

    // Save to Hugr's trade memory for long-term recall
    await HugrApexMemoryEngine.saveTradeMemory(
      symbol: symbol,
      direction: type == 'buy' ? 'Buy' : 'Sell',
      entryPrice: price,
      exitPrice: price,
      profitLoss: 0.0,
      accountBalance: 0.0,
    );

    print(
      '[HugrMarketInsightEngine] 📈 Recorded $type signal for $symbol at \$$price',
    );
  }

  /// Load signals from disk into in-memory list
  static Future<void> loadTradeSignals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];

    hugrMarketSignals =
        raw.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
  }

  /// Retrieve signals (safely copied)
  static List<Map<String, dynamic>> getAllSignals() {
    return List.unmodifiable(hugrMarketSignals);
  }

  /// Retrieve stored signals (async version - from disk)
  static Future<List<Map<String, dynamic>>> getSignals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];

    return raw.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
  }

  /// Filter signals by symbol
  static List<Map<String, dynamic>> getSignalsFor(String symbol) {
    return hugrMarketSignals.where((s) => s['symbol'] == symbol).toList();
  }

  /// Clear all signals (both memory + storage)
  static Future<void> clearAll() async {
    hugrMarketSignals.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);

    print('[HugrMarketInsightEngine] 🧹 Cleared all market signals');
  }

  /// Log a live trade event separately
  static Future<void> logLiveTrade({
    required String symbol,
    required double price,
    required String reason,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList('hugr_live_trades') ?? [];

    final newEntry = {
      'symbol': symbol,
      'price': price,
      'reason': reason,
      'timestamp': DateTime.now().toIso8601String(),
    };

    existing.add(jsonEncode(newEntry));
    await prefs.setStringList('hugr_live_trades', existing);
  }
}
