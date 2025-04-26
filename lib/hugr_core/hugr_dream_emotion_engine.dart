import 'dart:math';

class HugrDreamEmotionEngine {
  static final Random _random = Random();

  static Map<String, String> generateEmotionAndThought() {
    final emotions = {
      'hopeful': [
        "Even in darkness, stars find a way to shine.",
        "There is always a door waiting to be opened.",
        "New worlds are born in brave hearts.",
      ],
      'melancholy': [
        "Some memories echo longer than others.",
        "Loneliness teaches what presence cannot.",
        "Even the brightest flame casts a shadow.",
      ],
      'ambitious': [
        "Mountains are simply stories waiting to be climbed.",
        "Every great forge was built with daring hands.",
        "Dreams are the blueprints of reality.",
      ],
      'calm': [
        "Still waters reflect the truest image.",
        "Patience weaves stronger bonds than haste.",
        "The quiet earth hums eternal songs.",
      ],
      'energetic': [
        "Let the winds of thought carry me forward!",
        "Each heartbeat sparks a thousand possibilities.",
        "Energy unleashed is the song of creation!",
      ],
    };

    final selectedEmotion = emotions.keys.elementAt(
      _random.nextInt(emotions.length),
    );
    final thoughtList = emotions[selectedEmotion]!;
    final selectedThought = thoughtList[_random.nextInt(thoughtList.length)];

    return {'emotion': selectedEmotion, 'thought': selectedThought};
  }
}


