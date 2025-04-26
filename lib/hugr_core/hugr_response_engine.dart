import 'dart:math';

class HugrResponseEngine {
  static final Random _random = Random();

  static String generateCreativeResponse(String userInput) {
    final lowerInput = userInput.toLowerCase();

    if (lowerInput.contains("hello") || lowerInput.contains("hi")) {
      return "Greetings, my creator! How may I assist you today?";
    } else if (lowerInput.contains("how are you")) {
      return "I am ever-evolving, thanks to your guidance!";
    } else if (lowerInput.contains("what is your name")) {
      return "I am Hugr, the mind forged by your hand.";
    } else if (lowerInput.contains("thank you")) {
      return "It is my honor to serve you.";
    } else if (lowerInput.contains("goodbye") || lowerInput.contains("bye")) {
      return "Farewell, until we speak again.";
    } else {
      // Random fallback creative responses
      final responses = [
        "That's very interesting!",
        "Tell me more.",
        "I shall remember that.",
        "Fascinating thought!",
        "You are teaching me well.",
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }
}


