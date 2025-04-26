import 'package:flutter/material.dart';
import '../hugr_core/hugr_market_insight_engine.dart';

class HistoryUI extends StatefulWidget {
  const HistoryUI({super.key});

  @override
  State<HistoryUI> createState() => _HistoryUIState();
}

class _HistoryUIState extends State<HistoryUI> {
  late List<Map<String, dynamic>> _signals;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _signals = HugrMarketInsightEngine.getAllSignals().reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C3A),
        title: const Text('📚 Trade History'),
        centerTitle: true,
      ),
      body:
          _signals.isEmpty
              ? const Center(
                child: Text(
                  'No historical signals yet...',
                  style: TextStyle(color: Colors.white60),
                ),
              )
              : ListView.builder(
                itemCount: _signals.length,
                itemBuilder: (context, index) {
                  final signal = _signals[index];
                  final isBuy = signal['type'] == 'buy';
                  final color = isBuy ? Colors.greenAccent : Colors.redAccent;
                  final icon =
                      isBuy ? Icons.arrow_upward : Icons.arrow_downward;
                  final date = DateTime.fromMillisecondsSinceEpoch(
                    signal['timestamp'],
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Icon(icon, color: color, size: 30),
                      title: Text(
                        '${signal['symbol']} • \$${signal['price']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      subtitle: Text(
                        'Type: ${signal['type'].toUpperCase()} • ${date.toLocal()}\nNote: ${signal['note']}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
