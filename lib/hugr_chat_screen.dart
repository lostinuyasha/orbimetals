import 'package:flutter/material.dart';
import 'hugr_core/hugr_learning_engine.dart';
import 'hugr_core/hugr_voice_input_engine.dart';
import 'hugr_core/hugr_text_to_speech_engine.dart';
import 'hugr_core/hugr_fusion_engine.dart';
import 'hugr_extensions/hugr_ascension_center.dart'; // <--- NEW
import 'hugr_speech_world_connector.dart';

class HugrChatScreen extends StatefulWidget {
  @override
  _HugrChatScreenState createState() => _HugrChatScreenState();
}

class _HugrChatScreenState extends State<HugrChatScreen> {
  final List<String> _messages = [];
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeEngines();
  }

  Future<void> _initializeEngines() async {
    await HugrVoiceInputEngine.initialize();
    await HugrTextToSpeechEngine.initialize();
    await HugrSpeechWorldConnector.evolveWorldAndSpeak(
      "Echovale",
      "A crystal storm swept through the lake of light.",
    );

    HugrFusionEngine.startFusionThinking();
  }

  Future<void> _startListening() async {
    setState(() {
      _isListening = true;
    });
    await HugrVoiceInputEngine.startListening((recognizedText) async {
      _handleUserInput(recognizedText);
      setState(() {
        _isListening = false;
      });
    });
  }

  void _handleUserInput(String input) async {
    print('[HugrChatScreen] 🎤 Recognized: $input');
    setState(() {
      _messages.add('You: $input');
    });

    final response = HugrLearningEngine.generateResponse(input);
    setState(() {
      _messages.add('Hugr: $response');
    });

    await HugrTextToSpeechEngine.speak(response);
  }

  void _navigateToAscensionCenter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HugrAscensionCenter()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧠 Hugr Mirror'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_graph),
            onPressed:
                _navigateToAscensionCenter, // 💬 Navigate to Ascension Center
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final reversedIndex = _messages.length - 1 - index;
                return ListTile(title: Text(_messages[reversedIndex]));
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
              label: Text(_isListening ? 'Listening...' : 'Start Listening'),
              onPressed: _isListening ? null : _startListening,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


