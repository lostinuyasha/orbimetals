import 'package:flutter/material.dart';
import 'hugr_core/hugr_learning_engine.dart';

class HugrMemoryTimeline extends StatefulWidget {
  const HugrMemoryTimeline({super.key});

  @override
  State<HugrMemoryTimeline> createState() => _HugrMemoryTimelineState();
}

class _HugrMemoryTimelineState extends State<HugrMemoryTimeline> {
  late List<Map<String, dynamic>> _timelineMemories;

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  void _loadMemories() {
    final snapshot = HugrLearningEngine.getKnowledgeBaseSnapshot();
    snapshot.sort(
      (a, b) => b['timestamp'].compareTo(a['timestamp']),
    ); // newest first
    setState(() {
      _timelineMemories = snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        title: const Text('Hugr Memory Timeline'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body:
          _timelineMemories.isEmpty
              ? const Center(
                child: Text(
                  'No memories yet...',
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _timelineMemories.length,
                itemBuilder: (context, index) {
                  final memory = _timelineMemories[index];
                  return _buildMemoryTile(memory);
                },
              ),
    );
  }

  Widget _buildMemoryTile(Map<String, dynamic> memory) {
    final content = memory['content'] ?? '';
    final type = memory['type'].toString().split('.').last;
    final timestamp = memory['timestamp'] as DateTime;
    final confidence =
        (memory['confidence'] as double?)?.toStringAsFixed(2) ?? '?';

    return Card(
      color: Colors.grey.shade800,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(content, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          '$type • ${timestamp.toLocal()} • Confidence: $confidence',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
    );
  }
}


