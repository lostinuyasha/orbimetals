import 'package:speech_to_text/speech_to_text.dart' as stt;

class HugrVoiceInputEngine {
  static final stt.SpeechToText _speech = stt.SpeechToText();
  static bool _isListening = false;
  static bool _available = false;

  static Future<void> initialize() async {
    try {
      _available = await _speech.initialize(
        onStatus:
            (status) => print('[HugrVoiceInputEngine] Mic Status: $status'),
        onError: (error) => print('[HugrVoiceInputEngine] Mic Error: $error'),
      );

      if (_available) {
        print('[HugrVoiceInputEngine] 🎤 Voice Input Initialized.');
      } else {
        print('[HugrVoiceInputEngine] ❌ Voice Input unavailable.');
      }
    } catch (e) {
      print('[HugrVoiceInputEngine] ❌ Failed to initialize Speech-to-Text: $e');
      _available = false;
    }
  }

  static bool isAvailable() {
    return _available;
  }

  static Future<void> startListening(Function(String) onResult) async {
    if (!_available) {
      print(
        '[HugrVoiceInputEngine] ❌ Cannot start listening: Speech recognition unavailable.',
      );
      return;
    }

    if (_isListening) {
      print(
        '[HugrVoiceInputEngine] ⚠️ Already listening. Ignoring start request.',
      );
      return;
    }

    try {
      bool hasPermission = await _speech.hasPermission;
      if (!hasPermission) {
        print('[HugrVoiceInputEngine] 🚨 Asking for mic permission...');
        bool permissionGranted = await _speech.initialize();
        if (!permissionGranted) {
          print('[HugrVoiceInputEngine] ❌ Mic permission denied.');
          return;
        }
      }

      print('[HugrVoiceInputEngine] 🎙️ Starting to listen...');
      _isListening = true;

      _speech.listen(
        onResult: (result) async {
          if (result.finalResult) {
            print(
              '[HugrVoiceInputEngine] 🎤 Final recognized result: ${result.recognizedWords}',
            );
            onResult(result.recognizedWords);

            await stopListening(); // ✅ Proper stop after finished
          }
        },
        listenFor: const Duration(minutes: 1),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: "en_US",
      );
    } catch (e) {
      print('[HugrVoiceInputEngine] ❌ Error during listening: $e');
      _isListening = false;
    }
  }

  static Future<void> stopListening() async {
    if (_isListening) {
      print('[HugrVoiceInputEngine] 🛑 Stopping listening manually...');
      try {
        await _speech.stop(); // ✅ stop() is awaitable
      } catch (e) {
        print('[HugrVoiceInputEngine] ⚠️ Error stopping listening: $e');
      } finally {
        _isListening = false;
      }
    }
  }
}


