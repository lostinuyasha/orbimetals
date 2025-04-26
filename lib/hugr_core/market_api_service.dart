// ignore_for_file: unreachable_switch_default

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'hugr_market_insight_engine.dart';

enum HugrRiskMode { conservative, aggressive }

class MarketApiService {
  static const _apiKey = 'd05elo1r01qoigru5c00d05elo1r01qoigru5c0g';
  static const _baseUrl = 'https://finnhub.io/api/v1';

  static HugrRiskMode riskMode = HugrRiskMode.conservative;

  static const List<String> symbolsToTrack = [
    'SPY',
    'QQQ',
    'DIA',
    'IWM',
    'AAPL',
    'MSFT',
    'AMZN',
    'GOOGL',
    'TSLA',
    'META',
    'NVDA',
    'BRK.B',
    'GLD',
    'SLV',
    'USO',
    'AMD',
    'NFLX',
    'BABA',
    'PLTR',
    'SOFI',
    'ROKU',
    'NIO',
  ];

  static const List<String> futuresSymbols = [
    'ES=F', // S&P 500 E-mini
    'NQ=F', // NASDAQ E-mini
    'YM=F', // Dow Jones mini
    'CL=F', // Crude Oil
    'GC=F', // Gold
  ];

  static Future<double?> fetchCurrentPrice(String symbol) async {
    final url = Uri.parse('$_baseUrl/quote?symbol=$symbol&token=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['c']?.toDouble();
    }

    print('❌ Error fetching price for $symbol: ${response.statusCode}');
    return null;
  }

  static Future<double?> fetchFuturesPrice(String symbol) async {
    final url = Uri.parse('$_baseUrl/quote?symbol=$symbol&token=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['c']?.toDouble();
    }

    print('❌ Error fetching futures price for $symbol: ${response.statusCode}');
    return null;
  }

  static void startLiveSignalScanning() {
    Timer.periodic(const Duration(seconds: 40), (_) async {
      print('[MarketApiService] 🔄 Scanning symbols...');
      for (final symbol in symbolsToTrack) {
        final price = await fetchCurrentPrice(symbol);

        if (price != null) {
          final buyThreshold = _dynamicBuyThreshold(symbol, price);
          final sellThreshold = _dynamicSellThreshold(symbol, price);

          if (price < buyThreshold) {
            await HugrMarketInsightEngine.recordSignal(
              symbol: symbol,
              type: 'buy',
              price: price,
              timestamp: DateTime.now().millisecondsSinceEpoch,
              note: 'Dynamic live signal (adaptive)',
            );
            print(
              '[MarketApiService] ✅ Dynamic BUY Signal: $symbol @ \$$price',
            );
          } else if (price > sellThreshold) {
            await HugrMarketInsightEngine.recordSignal(
              symbol: symbol,
              type: 'sell',
              price: price,
              timestamp: DateTime.now().millisecondsSinceEpoch,
              note: 'Dynamic live signal (adaptive)',
            );
            print(
              '[MarketApiService] 🔻 Dynamic SELL Signal: $symbol @ \$$price',
            );
          }
        }
      }
    });
  }

  static void startFuturesSignalScanning() {
    Timer.periodic(const Duration(seconds: 40), (_) async {
      print('[MarketApiService] 🔄 Scanning FUTURES...');
      for (final symbol in futuresSymbols) {
        final price = await fetchFuturesPrice(symbol);

        if (price != null) {
          final buyThreshold = _dynamicBuyThreshold(symbol, price);
          final sellThreshold = _dynamicSellThreshold(symbol, price);

          if (price < buyThreshold) {
            await HugrMarketInsightEngine.recordSignal(
              symbol: symbol,
              type: 'buy',
              price: price,
              timestamp: DateTime.now().millisecondsSinceEpoch,
              note: '[Futures] Live auto-scan signal',
            );
            print(
              '[MarketApiService] ✅ [Futures] BUY Signal: $symbol @ \$$price',
            );
          } else if (price > sellThreshold) {
            await HugrMarketInsightEngine.recordSignal(
              symbol: symbol,
              type: 'sell',
              price: price,
              timestamp: DateTime.now().millisecondsSinceEpoch,
              note: '[Futures] Live auto-scan signal',
            );
            print(
              '[MarketApiService] 🔻 [Futures] SELL Signal: $symbol @ \$$price',
            );
          }
        }
      }
    });
  }

  static double _dynamicBuyThreshold(String symbol, double price) {
    switch (riskMode) {
      case HugrRiskMode.aggressive:
        return price * 0.995;
      case HugrRiskMode.conservative:
      default:
        return price * 0.98;
    }
  }

  static double _dynamicSellThreshold(String symbol, double price) {
    switch (riskMode) {
      case HugrRiskMode.aggressive:
        return price * 1.005;
      case HugrRiskMode.conservative:
      default:
        return price * 1.02;
    }
  }
}
