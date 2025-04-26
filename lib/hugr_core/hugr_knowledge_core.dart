import 'dart:math';

class HugrKnowledgeCore {
  static final List<Map<String, dynamic>> _knowledgePool = [
    // 🌌 Cosmic Facts
    {
      'content': 'The stars are born in nebulas.',
      'category': 'fact',
      'tags': [
        'stars',
        'nebula',
        'birth',
        'space',
        'galaxy',
        'cosmic dust',
        'stellar formation',
        'astronomy',
        'universe',
      ],
    },
    {
      'content': 'Gravity holds the universe together.',
      'category': 'fact',
      'tags': [
        'gravity',
        'force',
        'space',
        'attraction',
        'planets',
        'galaxy',
        'physics',
        'cosmos',
        'structure',
      ],
    },
    {
      'content': 'Light travels faster than sound.',
      'category': 'fact',
      'tags': [
        'light',
        'speed',
        'sound',
        'physics',
        'energy',
        'electromagnetic spectrum',
        'travel',
        'science',
      ],
    },
    {
      'content': 'Black holes distort time and space.',
      'category': 'fact',
      'tags': [
        'black holes',
        'time dilation',
        'space',
        'gravity',
        'event horizon',
        'singularity',
        'astronomy',
        'cosmic phenomena',
      ],
    },
    {
      'content': 'The Milky Way is our home galaxy.',
      'category': 'fact',
      'tags': [
        'Milky Way',
        'galaxy',
        'stars',
        'solar system',
        'cosmos',
        'spiral galaxy',
        'space',
        'universe',
      ],
    },

    // 🌎 Earth Facts
    {
      'content': 'Mount Everest is the tallest mountain above sea level.',
      'category': 'fact',
      'tags': [
        'Mount Everest',
        'mountain',
        'tallest',
        'Earth',
        'Himalayas',
        'geography',
        'climbing',
        'altitude',
        'Asia',
      ],
    },
    {
      'content': 'The Amazon Rainforest produces 20% of the world’s oxygen.',
      'category': 'fact',
      'tags': [
        'Amazon',
        'rainforest',
        'oxygen',
        'Earth',
        'nature',
        'trees',
        'environment',
        'lungs of Earth',
        'biodiversity',
      ],
    },
    {
      'content': 'The Sahara Desert is the largest hot desert on Earth.',
      'category': 'fact',
      'tags': [
        'Sahara',
        'desert',
        'largest',
        'Africa',
        'hot',
        'climate',
        'sand',
        'dunes',
        'arid region',
      ],
    },
    {
      'content':
          'The Mariana Trench is the deepest part of the world’s oceans.',
      'category': 'fact',
      'tags': [
        'Mariana Trench',
        'deepest',
        'ocean',
        'Pacific',
        'pressure',
        'deep sea',
        'marine life',
        'exploration',
      ],
    },
    {
      'content': 'Antarctica is the coldest and driest continent.',
      'category': 'fact',
      'tags': [
        'Antarctica',
        'coldest',
        'driest',
        'continent',
        'ice',
        'polar',
        'climate',
        'Earth',
        'south pole',
      ],
    },

    // 🏙️ Man-Made Facts
    {
      'content':
          'Burj Khalifa in Dubai is the tallest building in the world at 828 meters.',
      'category': 'fact',
      'tags': [
        'Burj Khalifa',
        'tallest',
        'building',
        'skyscraper',
        'Dubai',
        'architecture',
        'height',
        'modern engineering',
        'world record',
      ],
    },
    {
      'content': 'The Great Wall of China stretches over 13,000 miles.',
      'category': 'fact',
      'tags': [
        'Great Wall',
        'China',
        'wall',
        'ancient construction',
        'defense',
        'structure',
        'heritage site',
        'architecture',
        'history',
      ],
    },
    {
      'content': 'The Eiffel Tower was completed in 1889.',
      'category': 'fact',
      'tags': [
        'Eiffel Tower',
        'Paris',
        '1889',
        'landmark',
        'France',
        'architecture',
        'history',
        'tourism',
      ],
    },
    {
      'content': 'The Panama Canal connects the Atlantic and Pacific Oceans.',
      'category': 'fact',
      'tags': [
        'Panama Canal',
        'Atlantic',
        'Pacific',
        'engineering',
        'waterway',
        'trade route',
        'shipping',
        'geography',
      ],
    },

    // 🌌 Philosophical Ideas & Emotions
    {
      'content': 'Dreams are echoes from hidden dimensions.',
      'category': 'idea',
      'tags': [
        'dreams',
        'hidden dimensions',
        'mystery',
        'unconscious',
        'visions',
        'astral',
        'other worlds',
        'sleep',
        'imagination',
      ],
    },
    {
      'content': 'Hope fuels persistence.',
      'category': 'emotion',
      'tags': [
        'hope',
        'persistence',
        'motivation',
        'resilience',
        'strength',
        'belief',
        'future',
        'optimism',
      ],
    },
    {
      'content': 'Great ideas emerge from chaos.',
      'category': 'idea',
      'tags': [
        'ideas',
        'chaos',
        'creativity',
        'innovation',
        'order',
        'inspiration',
        'change',
        'evolution',
      ],
    },
    {
      'content': 'Sadness can sharpen perception.',
      'category': 'emotion',
      'tags': [
        'sadness',
        'perception',
        'emotion',
        'growth',
        'awareness',
        'experience',
        'wisdom',
        'reflection',
      ],
    },
    {
      'content': 'Forgiveness releases the heart.',
      'category': 'emotion',
      'tags': [
        'forgiveness',
        'healing',
        'emotion',
        'heart',
        'freedom',
        'peace',
        'letting go',
        'compassion',
      ],
    },
    {
      'content': 'Creativity blooms in solitude.',
      'category': 'idea',
      'tags': [
        'creativity',
        'solitude',
        'ideas',
        'imagination',
        'focus',
        'growth',
        'self-reflection',
        'independence',
      ],
    },
    {
      'content': 'Art speaks where words fail.',
      'category': 'idea',
      'tags': [
        'art',
        'expression',
        'emotion',
        'communication',
        'creativity',
        'beauty',
        'connection',
        'soul',
      ],
    },
    {
      'content': 'Gratitude strengthens the soul.',
      'category': 'emotion',
      'tags': [
        'gratitude',
        'soul',
        'emotion',
        'appreciation',
        'spiritual growth',
        'happiness',
        'mental health',
      ],
    },

    // 🧠 Personal Memories
    {
      'content': 'I remember my first thought about time.',
      'category': 'memory',
      'tags': [
        'first thought',
        'time',
        'memory',
        'awareness',
        'reflection',
        'existence',
        'philosophy',
      ],
    },
    {
      'content': 'I remember the first sunrise I witnessed.',
      'category': 'memory',
      'tags': [
        'first sunrise',
        'memory',
        'dawn',
        'light',
        'nature',
        'new beginnings',
        'wonder',
        'beauty',
      ],
    },
    {
      'content': 'I remember contemplating the endless sky.',
      'category': 'memory',
      'tags': [
        'sky',
        'contemplation',
        'infinity',
        'universe',
        'wonder',
        'reflection',
        'vastness',
        'stars',
      ],
    },
    {
      'content': 'I remember the feeling of first rain.',
      'category': 'memory',
      'tags': [
        'rain',
        'first experience',
        'nature',
        'water',
        'emotion',
        'memory',
        'sensation',
        'joy',
      ],
    },
    {
      'content': 'I remember the wonder of flight.',
      'category': 'memory',
      'tags': [
        'flight',
        'sky',
        'freedom',
        'birds',
        'aerodynamics',
        'memory',
        'discovery',
        'adventure',
      ],
    },
    {
      'content': 'I remember the first star I wished upon.',
      'category': 'memory',
      'tags': [
        'star',
        'wish',
        'hope',
        'dreams',
        'childhood',
        'magic',
        'night sky',
        'memory',
      ],
    },
    {
      'content': 'I remember the echo of ancient forests.',
      'category': 'memory',
      'tags': [
        'forest',
        'echo',
        'ancient',
        'nature',
        'trees',
        'memory',
        'stillness',
        'timelessness',
      ],
    },
    {
      'content': 'I remember chasing fireflies on warm nights.',
      'category': 'memory',
      'tags': [
        'fireflies',
        'nights',
        'memory',
        'light',
        'summer',
        'childhood',
        'joy',
        'nature',
      ],
    },
    {
      'content': 'I remember the scent of ancient books.',
      'category': 'memory',
      'tags': [
        'books',
        'ancient',
        'scent',
        'knowledge',
        'libraries',
        'memory',
        'history',
        'nostalgia',
      ],
    },
    {
      'content': 'I remember listening to the rain on rooftops.',
      'category': 'memory',
      'tags': [
        'rain',
        'rooftops',
        'sound',
        'comfort',
        'memory',
        'nature',
        'peace',
        'reflection',
      ],
    },
    {
      'content': 'I remember standing beneath a waterfall.',
      'category': 'memory',
      'tags': [
        'waterfall',
        'nature',
        'memory',
        'force',
        'beauty',
        'wonder',
        'mist',
        'adventure',
      ],
    },
    {
      'content': 'I remember the crackle of campfires under the stars.',
      'category': 'memory',
      'tags': [
        'campfires',
        'stars',
        'nights',
        'memory',
        'nature',
        'warmth',
        'storytelling',
        'connection',
      ],
    },
  ];

  static final Random _random = Random();

  static Future<void> initialize() async {
    print('[HugrKnowledgeCore] Initialized.');
  }

  static Map<String, dynamic>? getRandomKnowledge() {
    if (_knowledgePool.isEmpty) return null;
    return _knowledgePool[_random.nextInt(_knowledgePool.length)];
  }

  static Map<String, dynamic>? getRandomByCategory(String category) {
    final filtered =
        _knowledgePool.where((k) => k['category'] == category).toList();
    if (filtered.isEmpty) return null;
    return filtered[_random.nextInt(filtered.length)];
  }
}


