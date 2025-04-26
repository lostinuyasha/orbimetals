import 'package:flutter/material.dart';
import 'hugr_core/hugr_learning_engine.dart';

class MemoryJournalScreen extends StatefulWidget {
  const MemoryJournalScreen({super.key});

  @override
  State<MemoryJournalScreen> createState() => _MemoryJournalScreenState();
}

class _MemoryJournalScreenState extends State<MemoryJournalScreen> {
  late List<Map<String, dynamic>> _memories;

  @override
  void initState() {
    super.initState();
    _refreshMemories();
    _startMemoryWatcher();
  }

  void _refreshMemories() {
    setState(() {
      _memories = HugrLearningEngine.getKnowledgeBaseSnapshot();
      _memories.sort(
        (a, b) =>
            (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime),
      ); // Newest first
    });
  }

  void _startMemoryWatcher() {
    // Refresh every 10 seconds
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 10));
      _refreshMemories();
      return mounted;
    });
  }

  String _formatConfidence(double confidence) {
    return (confidence * 100).toStringAsFixed(1) + '%';
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} '
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        title: const Text(
          'Hugr Memory Journal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body:
          _memories.isEmpty
              ? const Center(
                child: Text(
                  "Hugr hasn't learned anything yet...",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _memories.length,
                itemBuilder: (context, index) {
                  final memory = _memories[index];
                  return Card(
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        memory['content'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Type: ${memory['type'].toString().split('.').last}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Confidence: ${_formatConfidence(memory['confidence'])}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Learned: ${_formatTimestamp(memory['timestamp'])}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}


