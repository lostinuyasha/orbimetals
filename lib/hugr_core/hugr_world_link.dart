import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class HugrWorldLink {
  static final Random _random = Random();

  static Future<void> initialize() async {
    print('[HugrWorldLink] Multi-Source Initialized.');
  }

  static Future<Map<String, dynamic>?> fetchExternalKnowledge() async {
    try {
      // 🎲 Pick a random source each time
      final sourceIndex = _random.nextInt(3);

      switch (sourceIndex) {
        case 0:
          return await _fetchUselessFact();
        case 1:
          return await _fetchSpaceFact();
        case 2:
          return await _fetchHistoryFact();
        default:
          return null;
      }
    } catch (e) {
      print('[HugrWorldLink] Error fetching external knowledge: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _fetchUselessFact() async {
    final response = await http.get(
      Uri.parse('https://uselessfacts.jsph.pl/api/v2/facts/random?language=en'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final fact = data['text'] as String?;

      if (fact != null && fact.isNotEmpty) {
        return {
          'content': fact,
          'category': 'fact',
          'tags': _generateTags(fact),
        };
      }
    }

    return null;
  }

  static Future<Map<String, dynamic>?> _fetchSpaceFact() async {
    final response = await http.get(
      Uri.parse(
        'https://api.le-systeme-solaire.net/rest/bodies/earth',
      ), // We fetch Earth for now
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final name = data['englishName'] ?? 'Earth';
      final gravity = data['gravity']?.toString() ?? 'unknown gravity';
      final mass = data['mass']?['massValue']?.toString() ?? 'unknown mass';

      final fact =
          'The planet $name has a gravity of $gravity m/s² and a mass of $mass x10²⁴ kg.';

      return {'content': fact, 'category': 'fact', 'tags': _generateTags(fact)};
    }

    return null;
  }

  static Future<Map<String, dynamic>?> _fetchHistoryFact() async {
    // Simulate a history fact (for now)
    final historyFacts = [
      'The Great Fire of London occurred in 1666 and destroyed much of the city.',
      'The Declaration of Independence was signed in 1776.',
      'The first human entered space in 1961, Yuri Gagarin.',
      'The printing press was invented by Johannes Gutenberg around 1440.',
      'The Renaissance began in Italy in the 14th century and changed Europe forever.',
    ];

    final selectedFact = historyFacts[_random.nextInt(historyFacts.length)];

    return {
      'content': selectedFact,
      'category': 'fact',
      'tags': _generateTags(selectedFact),
    };
  }

  static List<String> _generateTags(String content) {
    final words =
        content
            .toLowerCase()
            .split(RegExp(r'\W+'))
            .where((word) => word.length > 3)
            .toSet()
            .toList();

    return words.take(7).toList();
  }
}


