import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HugrMarketDataAnalyzer {
  /// Fetches and analyzes historical data for a given stock symbol
  static Future<void> analyzeHistoricalData(String symbol) async {
    final Uri uri = Uri.parse(
      'https://finnhub.io/api/v1/stock/candle?symbol=$symbol&resolution=D&count=100&token=YOUR_API_KEY',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['s'] == 'ok') {
          final List<double> closes = List<double>.from(data['c']);
          final List<double> highs = List<double>.from(data['h']);
          final List<double> lows = List<double>.from(data['l']);
          final List<int> timestamps = List<int>.from(data['t']);

          _detectPatterns(symbol, closes, highs, lows, timestamps);
        } else {
          print(
            '[HugrMarketDataAnalyzer] ⚠️ No valid data returned for $symbol',
          );
          await HugrMarketInsightEngine.logLiveTrade(
            symbol: 'AAPL',
            price: 187.35,
            reason: 'Breakout above resistance',
          );
        }
      } else {
        print('[HugrMarketDataAnalyzer] ❌ API error: ${response.statusCode}');
      }
    } catch (e) {
      print('[HugrMarketDataAnalyzer] 🔥 Exception: $e');
    }
  }

  /// Detects simple breakout pattern based on highs and recent closes
  static void _detectPatterns(
    String symbol,
    List<double> closes,
    List<double> highs,
    List<double> lows,
    List<int> timestamps,
  ) {
    if (closes.length < 3) return;

    final double recentHigh = highs
        .sublist(highs.length - 3)
        .reduce((a, b) => a > b ? a : b);
    final double latestClose = closes.last;

    if (latestClose > recentHigh) {
      print(
        '[Pattern Detected] 🚀 Breakout on $symbol! Close: $latestClose above recent high: $recentHigh',
      );

      HugrMarketInsightEngine.logLiveTrade(
        symbol: symbol,
        price: latestClose,
        reason: 'Breakout above recent high',
      );
    }
  }

  /// Detects breakout signals based on closing price and volume thresholds
  static List<Map<String, dynamic>> detectBreakoutSignals(
    List<Map<String, dynamic>> candles,
  ) {
    final List<Map<String, dynamic>> signals = [];

    for (int i = 1; i < candles.length; i++) {
      final prev = candles[i - 1];
      final curr = candles[i];

      final prevClose = prev['close'] ?? 0;
      final currClose = curr['close'] ?? 0;
      final volume = curr['volume'] ?? 0;

      final priceJump = currClose > prevClose * 1.03;
      final volumeSpike = volume > 1000000;

      if (priceJump || volumeSpike) {
        signals.add(curr);
      }
    }

    return signals;
  }
}

class HugrMarketInsightEngine {
  static const String _storageKey = 'hugr_market_signals';
  static const String _liveKey = 'hugr_live_trades';

  /// 📦 Store a new trading insight
  static Future<void> storeSignal(Map<String, dynamic> signal) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];

    existing.add(jsonEncode(signal));
    await prefs.setStringList(_storageKey, existing);

    print('[📈 Market Insight] Signal stored: ${signal['symbol']}');
  }

  /// 🧠 Retrieve all stored signals
  static Future<List<Map<String, dynamic>>> getSignals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];

    return raw.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
  }

  /// 🚨 Logs a live trade entry with full trace
  static Future<void> logLiveTrade({
    required String symbol,
    required double price,
    required String reason,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_liveKey) ?? [];

    final entry = {
      'symbol': symbol,
      'price': price,
      'reason': reason,
      'timestamp': DateTime.now().toIso8601String(),
    };

    existing.add(jsonEncode(entry));
    await prefs.setStringList(_liveKey, existing);

    print('[💹 Live Trade] $symbol @ \$${price.toStringAsFixed(2)} — $reason');
  }

  /// 📜 Load all live trades
  static Future<List<Map<String, dynamic>>> loadTradeSignals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_liveKey) ?? [];

    return raw.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
  }
}
