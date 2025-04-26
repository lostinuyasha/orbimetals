// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'hugr_learning_engine.dart';
import 'hugr_memory_emotions_engine.dart';
import 'hugr_upgrade_evolution_heatmap.dart';

class HugrWebCrawler {
  static final Random _random = Random();
  static Timer? _timer;

  /// 🕸️ Starts periodic web crawling and learning
  static void startCrawling({Duration interval = const Duration(minutes: 15)}) {
    crawlAndLearn();
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => crawlAndLearn());
    print('[Crawler] 🌐 Started with interval: ${interval.inMinutes}m');
  }

  /// 🧠 Crawl and learn knowledge from rotating API
  static Future<void> crawlAndLearn() async {
    final uri = Uri.parse(HugrApiRotationEngine.next());

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content =
            data['text'] ??
            data['quote'] ??
            data['slip']?['advice'] ??
            data['entries']?[0]?['API'] ??
            data['content'];

        if (content != null && content.toString().trim().isNotEmpty) {
          HugrLearningEngine.storeKnowledge(content);
          HugrMemoryEmotionsEngine.tagSingle(content);
          HugrUpgradeEvolutionHeatmap.record(
            "crawled: \${content.toString().substring(0, 20)}...",
          );
        }
      }
    } catch (e) {
      print('[Crawler] ⚠️ Error: $e');
    }
  }

  /// 🧠 Manual fetch with rate limiter
  static Future<Map<String, dynamic>?> fetchKnowledge() async {
    if (!_rateLimiter.allow()) {
      print('[HugrWebCrawler] ⛔ Rate limit reached.');
      return null;
    }
    return await _crawl();
  }

  /// 🔄 Actual crawl engine from random API
  static Future<Map<String, dynamic>?> _crawl() async {
    final Uri source = HugrApiRotationEngine.nextUri();
    print('[HugrWebCrawler] 🔍 Crawling: $source');

    try {
      final response = await http.get(source);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);

        if (source.host.contains('quotable.io')) {
          final Map<String, dynamic> decoded = jsonDecode(response.body);
          return {
            'content': '${decoded['content']} — ${decoded['author']}',
            'tags': ['quote', 'wisdom'],
          };
        } else if (source.host.contains('uselessfacts')) {
          final Map<String, dynamic> decoded = jsonDecode(response.body);
          return {
            'content': decoded['text'],
            'tags': ['fun', 'fact'],
          };
        } else if (source.host.contains('adviceslip')) {
          final Map<String, dynamic> decoded = jsonDecode(response.body);
          return {
            'content': decoded['slip']['advice'],
            'tags': ['advice', 'insight'],
          };
        } else if (source.host.contains('publicapis')) {
          final Map<String, dynamic> decoded = jsonDecode(response.body);
          final List<dynamic> entries = decoded['entries'];
          final api =
              entries[_random.nextInt(entries.length)] as Map<String, dynamic>;
          return {
            'content': '${api['API']} — ${api['Description']}',
            'tags': ['api', 'tech'],
          };
        } else {
          return {
            'content': response.body.toString().substring(0, 150),
            'tags': ['raw', 'data'],
          };
        }
      } else {
        print('[HugrWebCrawler] ❌ Error: \${response.statusCode}');
      }
    } catch (e) {
      print('[HugrWebCrawler] ❗ Fetch error: $e');
    }

    return null;
  }
}

/// 🔁 API Rotation Helper
class HugrApiRotationEngine {
  static final List<String> _apiPool = [
    'https://uselessfacts.jsph.pl/random.json?language=en',
    'https://api.quotable.io/random',
    'https://api.adviceslip.com/advice',
    'https://api.publicapis.org/entries',
  ];

  static final List<Uri> _apiSources = _apiPool.map(Uri.parse).toList();
  static final Random _random = Random();
  static int _current = 0;

  static Uri nextUri() => _apiSources[_random.nextInt(_apiSources.length)];
  static String next() {
    _current = (_current + 1) % _apiPool.length;
    return _apiPool[_current];
  }
}

/// ⏱️ Simple rate limiter
final RateLimiter _rateLimiter = RateLimiter(
  maxRequests: 5,
  period: Duration(minutes: 1),
);

class RateLimiter {
  final int maxRequests;
  final Duration period;
  int _requestCount = 0;
  Timer? _resetTimer;

  RateLimiter({required this.maxRequests, required this.period}) {
    _resetTimer = Timer.periodic(period, (_) => _requestCount = 0);
  }

  bool allow() {
    if (_requestCount < maxRequests) {
      _requestCount++;
      return true;
    }
    return false;
  }

  void dispose() {
    _resetTimer?.cancel();
  }
}
