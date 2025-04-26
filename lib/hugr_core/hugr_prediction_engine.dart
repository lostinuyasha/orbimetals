import 'dart:async';
import 'market_api_service.dart';

class HugrPredictionEngine {
  static final Map<String, String> _predictions = {};

  static Timer? _predictionTimer;

  static void startPredicting() {
    _predictionTimer?.cancel();
    _predictionTimer = Timer.periodic(const Duration(minutes: 2), (_) async {
      await _fetchAndAnalyze();
    });
    _fetchAndAnalyze(); // Immediate first fetch
  }

  static Future<void> _fetchAndAnalyze() async {
    const symbols = ['SPY', 'QQQ', 'AAPL', 'MSFT'];

    for (final symbol in symbols) {
      final currentPrice = await MarketApiService.fetchCurrentPrice(symbol);
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Small gap to respect API rate limits

      if (currentPrice != null) {
        final previousPrice = _previousPrices[symbol] ?? currentPrice;

        if (currentPrice > previousPrice) {
          _predictions[symbol] = 'Bullish';
        } else if (currentPrice < previousPrice) {
          _predictions[symbol] = 'Bearish';
        } else {
          _predictions[symbol] = 'Neutral';
        }

        _previousPrices[symbol] = currentPrice;
      }
    }
  }

  static final Map<String, double> _previousPrices = {};

  static Map<String, String> getPredictions() {
    return Map.unmodifiable(_predictions);
  }
}
