import 'package:flutter/material.dart';
import 'hugr_core/hugr_learning_engine.dart';

class HugrMemoryFeed extends StatefulWidget {
  const HugrMemoryFeed({super.key});

  @override
  State<HugrMemoryFeed> createState() => HugrMemoryFeedState();
}

class HugrMemoryFeedState extends State<HugrMemoryFeed> {
  List<Map<String, dynamic>> _memories = [];

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    final memories =
        HugrLearningEngine.getKnowledgeBaseSnapshot().reversed.toList();
    setState(() {
      _memories = memories.reversed.toList(); // newest first
    });
  }

  // 🌟 External trigger to reload memories
  void refreshFeed() {
    _loadMemories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.memory, color: Colors.pinkAccent),
              SizedBox(width: 8),
              Text(
                '🧠 Hugr Memory Feed',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_memories.isEmpty)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'No memories yet...',
                style: TextStyle(color: Colors.white38),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true, // Important! Don't expand infinitely
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scroll inside
              itemCount: _memories.length,
              itemBuilder: (context, index) {
                final memory = _memories[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    memory['content'] ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}


