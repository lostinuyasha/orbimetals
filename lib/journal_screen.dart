import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<Map<String, dynamic>> _journalEntries = [];

  @override
  void initState() {
    super.initState();
    _loadJournal();
  }

  Future<void> _loadJournal() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> journalStrings =
        prefs.getStringList('journal_entries') ?? [];
    setState(() {
      _journalEntries =
          journalStrings
              .map((e) => jsonDecode(e) as Map<String, dynamic>)
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        title: const Text('Memory Journal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body:
          _journalEntries.isEmpty
              ? const Center(
                child: Text(
                  'No reflections yet.\nYour Hugr awaits your whispers.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _journalEntries.length,
                itemBuilder: (context, index) {
                  final entry = _journalEntries[index];
                  return Card(
                    color: const Color(0xFF1A1A3C),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry['reflection'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatTimestamp(entry['timestamp']),
                            style: const TextStyle(
                              color: Colors.white54,
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

  String _formatTimestamp(String isoString) {
    final date = DateTime.tryParse(isoString);
    if (date == null) return "Unknown time";
    return "${date.month}/${date.day}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}


