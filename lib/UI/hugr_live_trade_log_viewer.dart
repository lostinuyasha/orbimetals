import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HugrLiveTradeLogViewer extends StatefulWidget {
  const HugrLiveTradeLogViewer({super.key});

  @override
  State<HugrLiveTradeLogViewer> createState() => _HugrLiveTradeLogViewerState();
}

class _HugrLiveTradeLogViewerState extends State<HugrLiveTradeLogViewer> {
  List<Map<String, dynamic>> _logs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList('hugr_live_trades') ?? [];

    final decoded =
        data.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    setState(() {
      _logs = decoded.reversed.toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📊 Live Trade Log')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _logs.isEmpty
              ? const Center(child: Text('No live trades yet.'))
              : ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(
                        '📈 ${log['symbol']} @ \$${log['price'].toStringAsFixed(2)}',
                      ),
                      subtitle: Text('${log['reason']}\n⏰ ${log['timestamp']}'),
                    ),
                  );
                },
              ),
    );
  }
}
