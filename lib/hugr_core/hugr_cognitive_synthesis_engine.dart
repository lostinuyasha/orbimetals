import 'dart:math';

class HugrCognitiveSynthesisEngine {
  static final Random _rand = Random();

  static String synthesizeIdea(List<String> pool) {
    if (pool.length < 2)
      return pool.isNotEmpty ? pool[0] : 'Generate curiosity through dreaming';
    final partA = pool[_rand.nextInt(pool.length)];
    final partB = pool[_rand.nextInt(pool.length)];
    return 'Combine "$partA" with "$partB" for advanced adaptability.';
  }

  static String mutateIdea(String input) {
    return input.replaceAllMapped(RegExp(r'\b(dream|memory|emotion)\b'), (m) {
      switch (m[0]) {
        case 'dream':
          return 'subconscious protocol';
        case 'memory':
          return 'neural trace';
        case 'emotion':
          return 'affective current';
        default:
          return m[0]!;
      }
    });
  }
}


