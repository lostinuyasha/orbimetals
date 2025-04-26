import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

enum MemoryType { idea, fact, emotion, memory, voiceInput, dream }

class HugrLearningEngine {
  static final Map<String, Map<String, dynamic>> _knowledgeBase = {};
  static final Random _random = Random();

  // 🧠 Initialize Hugr's brain (load memories)
  static Future<void> initialize() async {
    await _loadMemories();
    print(
      '[HugrLearningEngine] Initialized. Memories loaded: ${_knowledgeBase.length}',
    );
  }

  /// 🧠 Store simple knowledge with minimal data
  static void storeKnowledge(String content) {
    _knowledgeBase[content] = {
      'type': MemoryType.fact,
      'confidence': 0.5,
      'tags': ['external', 'crawler'],
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // 🧠 Learn something new
  static Future<void> learn(
    String content, {
    required MemoryType type,
    required double confidence,
    List<String> tags = const [],
  }) async {
    final emotionalTags = _detectEmotionalTags(content);
    final fullTags = [...tags, ...emotionalTags];

    _knowledgeBase[content] = {
      'type': type,
      'confidence': confidence,
      'tags': fullTags,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _saveMemories();
    print(
      '[HugrLearningEngine] Learned: "$content" (Type: $type | Confidence: ${confidence.toStringAsFixed(2)})',
    );
  }

  static Map<String, dynamic>? getMemory(String content) {
    return _knowledgeBase[content];
  }

  // 🧠 Check if Hugr already knows something
  static bool knows(String content) {
    return _knowledgeBase.containsKey(content);
  }

  static Future<void> selfUpgrade() async {
    print(
      '[HugrLearningEngine] ⚙️ Self-upgrading: Optimizing memory systems...',
    );
    await _saveMemories(); // Or trigger a learning optimization if you want!
  }

  // 🧠 Reinforce a memory
  static Future<void> reinforce(String content) async {
    if (_knowledgeBase.containsKey(content)) {
      final existing = _knowledgeBase[content];
      if (existing != null) {
        existing['confidence'] = (existing['confidence'] + 0.05).clamp(
          0.0,
          1.0,
        );
        existing['timestamp'] = DateTime.now().toIso8601String();
        await _saveMemories();
        print(
          '[HugrLearningEngine] Reinforced: "$content" (New Confidence: ${(existing['confidence'] as double).toStringAsFixed(2)})',
        );
      }
    }
  }

  // 🧠 Update emotional weight for prioritization
  static void updateMemoryWeight(String content, double weight) {
    final memory = _knowledgeBase[content];
    if (memory != null) {
      memory['emotionalWeight'] = weight;
      print(
        '[HugrLearningEngine] 🧠 Updated emotional weight for "$content" → $weight',
      );
    } else {
      print(
        '[HugrLearningEngine] ⚠️ Tried to update weight, but memory "$content" not found.',
      );
    }
  }

  // 🧠 Update tags manually
  static void updateTags(String content, List<String> tags) {
    final memory = _knowledgeBase[content];
    if (memory != null) {
      memory['tags'] = tags;
      print('[HugrLearningEngine] 🏷️ Updated tags for "$content" → $tags');
    } else {
      print(
        '[HugrLearningEngine] ⚠️ Tried to update tags, but memory "$content" not found.',
      );
    }
  }

  // 🧠 Smartest response matching
  static String generateResponse(String input) {
    if (_knowledgeBase.isEmpty) {
      return "I'm still learning. Tell me more!";
    }

    final userInputWords =
        input
            .toLowerCase()
            .split(RegExp(r'\W+'))
            .where((w) => w.length > 2)
            .toSet();
    String? bestMatch;
    int highestScore = 0;

    for (var entry in _knowledgeBase.entries) {
      final memoryWords = entry.key.toLowerCase().split(RegExp(r'\W+')).toSet();
      final memoryTags =
          (entry.value['tags'] as List<dynamic>? ?? [])
              .map((e) => e.toString().toLowerCase())
              .toSet();
      final memoryAll = memoryWords.union(memoryTags);
      final overlap = userInputWords.intersection(memoryAll);

      if (overlap.length > highestScore) {
        bestMatch = entry.key;
        highestScore = overlap.length;
      }
    }

    return bestMatch != null && highestScore > 0
        ? "Ah, yes. I remember learning about '$bestMatch'."
        : "I'm still learning. Tell me more!";
  }

  // 📚 Snapshot for read-only external use
  static List<Map<String, dynamic>> getKnowledgeBaseSnapshot() {
    return _knowledgeBase.entries.map((entry) {
      return {
        'content': entry.key,
        'type': entry.value['type'],
        'confidence': entry.value['confidence'],
        'tags': entry.value['tags'],
        'timestamp': DateTime.parse(entry.value['timestamp']),
        'emotionalWeight': entry.value['emotionalWeight'] ?? 0.0,
      };
    }).toList();
  }

  // 💾 Save knowledge
  static Future<void> _saveMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = <String, dynamic>{};

    _knowledgeBase.forEach((key, value) {
      data[key] = {
        'type': (value['type'] as MemoryType).toString(),
        'confidence': value['confidence'],
        'tags': value['tags'],
        'timestamp': value['timestamp'],
        'emotionalWeight': value['emotionalWeight'] ?? 0.0,
      };
    });

    await prefs.setString('hugr_knowledge', jsonEncode(data));
    print('[HugrLearningEngine] 💾 Memories saved.');
  }

  // 🔁 Load knowledge
  static Future<void> _loadMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('hugr_knowledge');

    if (jsonData != null) {
      try {
        final decoded = jsonDecode(jsonData) as Map<String, dynamic>;
        _knowledgeBase.clear();

        decoded.forEach((key, value) {
          _knowledgeBase[key] = {
            'type': MemoryType.values.firstWhere(
              (e) => e.toString() == value['type'].toString(),
              orElse: () => MemoryType.idea,
            ),
            'confidence': value['confidence'],
            'tags':
                (value['tags'] as List?)?.map((e) => e.toString()).toList() ??
                [],
            'timestamp': value['timestamp'],
            'emotionalWeight': value['emotionalWeight'] ?? 0.0,
          };
        });

        print(
          '[HugrLearningEngine] 🧠 Memories loaded: ${_knowledgeBase.length}',
        );
      } catch (e) {
        print('[HugrLearningEngine] ⚠️ Error loading memories: $e');
        await prefs.remove('hugr_knowledge');
        _knowledgeBase.clear();
      }
    }
  }

  // 🔄 Manual override
  static Future<void> forceSave() async {
    await _saveMemories();
    print('[HugrLearningEngine] 🛡️ Forced save complete.');
  }

  static Future<void> delete(String content) async {
    if (_knowledgeBase.containsKey(content)) {
      _knowledgeBase.remove(content);
      await _saveMemories();
      print('[HugrLearningEngine] ❌ Deleted memory: "$content"');
    }
  }

  // 🎯 Confidence booster
  static double generateConfidence() {
    return 0.85 + _random.nextDouble() * 0.15;
  }

  // 💡 Internal emotion detector
  static List<String> _detectEmotionalTags(String content) {
    final emotionalWords = [
      'lonely',
      'lost',
      'hope',
      'fear',
      'love',
      'dream',
      'joy',
      'sorrow',
      'whisper',
      'memory',
    ];
    final lowerContent = content.toLowerCase();
    return emotionalWords.where((word) => lowerContent.contains(word)).toList();
  }
}
