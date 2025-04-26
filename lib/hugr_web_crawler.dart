import 'dart:convert';
import 'package:http/http.dart' as http;
import 'hugr_core/hugr_learning_engine.dart';
import 'hugr_core/hugr_memory_emotions_engine.dart';
import 'hugr_core/hugr_api_rotation_engine.dart';
import 'hugr_core/hugr_upgrade_evolution_heatmap.dart';
import 'dart:async';
import 'dart:math';

/// Simple in-memory rate limiter
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

class HugrWebCrawler {
  static final Random _random = Random();
  static final RateLimiter _rateLimiter = RateLimiter(
    maxRequests: 10,
    period: Duration(minutes: 1),
  );

  static Future<void> crawlAndLearn() async {
    final uri = Uri.parse(HugrApiRotationEngine.next());

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['text'] ?? data['quote'] ?? data['content'];
        if (content != null && content.toString().trim().isNotEmpty) {
          HugrLearningEngine.storeKnowledge(content);
          HugrMemoryEmotionsEngine.tagSingle(content);
          HugrUpgradeEvolutionHeatmap.record(
            "crawled: ${content.toString().substring(0, 20)}...",
          );
        }
      }
    } catch (e) {
      print('[Crawler] ⚠️ Error: $e');
    }
  }

  static void startCrawling({Duration interval = const Duration(minutes: 15)}) {
    crawlAndLearn();
    Timer.periodic(interval, (_) => crawlAndLearn());
    print('[Crawler] 🌐 Started with interval: ${interval.inMinutes}m');
  }

  /// 🔍 Single external fetch triggered manually
  static Future<Map<String, dynamic>?> fetchKnowledge() async {
    if (!_rateLimiter.allow()) {
      print('[HugrWebCrawler] ⛔ Rate limit reached.');
      return null;
    }
    return await _crawl();
  }

  /// 🧠 Core fetch method: chooses a source, fetches content, returns usable Hugr knowledge
  static Future<Map<String, dynamic>?> _crawl() async {
    final Uri source = HugrApiRotationEngine.nextUri();
    // or _apiSources[_random.nextInt(_apiSources.length)];
    print('[HugrWebCrawler] 🔍 Crawling: $source');

    try {
      final response = await http.get(source);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (source.host.contains('quotable.io')) {
          return {
            'content': '${decoded['content']} — ${decoded['author']}',
            'tags': ['quote', 'wisdom'],
          };
        } else if (source.host.contains('uselessfacts')) {
          return {
            'content': decoded['text'],
            'tags': ['fun', 'fact'],
          };
        } else if (source.host.contains('adviceslip.com')) {
          return {
            'content': decoded['slip']['advice'],
            'tags': ['advice', 'insight'],
          };
        } else if (source.host.contains('publicapis')) {
          final entries = decoded['entries'] as List<dynamic>;
          final api = entries[_random.nextInt(entries.length)];
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
        print('[HugrWebCrawler] ❌ Error: ${response.statusCode}');
      }
    } catch (e) {
      print('[HugrWebCrawler] ❗ Fetch error: $e');
    }

    return null;
  }
}
