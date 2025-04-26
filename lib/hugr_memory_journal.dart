import 'package:flutter/material.dart';
import 'hugr_core/hugr_learning_engine.dart';

class HugrMemoryJournal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final memories = HugrLearningEngine.getKnowledgeBaseSnapshot();

    // Sort newest to oldest (reverse order)
    final sortedMemories = List<Map<String, dynamic>>.from(memories)..sort(
      (a, b) => DateTime.parse(
        b['timestamp'].toString(),
      ).compareTo(DateTime.parse(a['timestamp'].toString())),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('🧠 Hugr\'s Memory Journal')),
      body:
          sortedMemories.isEmpty
              ? const Center(
                child: Text('No memories yet. Start speaking or typing!'),
              )
              : ListView.builder(
                itemCount: sortedMemories.length,
                itemBuilder: (context, index) {
                  final memory = sortedMemories[index];
                  return ListTile(
                    title: Text(memory['content'] ?? 'Unknown'),
                    subtitle: Text(
                      'Type: ${memory['type']}\nConfidence: ${(memory['confidence'] as double).toStringAsFixed(2)}\nSaved: ${memory['timestamp']}',
                    ),
                    isThreeLine: true,
                  );
                },
              ),
    );
  }
}


