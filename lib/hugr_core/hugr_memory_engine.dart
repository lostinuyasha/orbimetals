import 'package:flutter/material.dart';
import '../hugr_core/hugr_market_insight_engine.dart';
import 'dart:async';

class MemoryUI extends StatefulWidget {
  const MemoryUI({super.key});

  @override
  State<MemoryUI> createState() => _MemoryUIState();
}

class _MemoryUIState extends State<MemoryUI> {
  List<Map<String, dynamic>> _tradeMemories = [];
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadTradeMemories();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadTradeMemories();
    });
  }

  Future<void> _loadTradeMemories() async {
    setState(() {
      _tradeMemories =
          HugrMarketInsightEngine.getAllSignals().reversed.toList();
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C3A),
        title: const Text('🧠 Hugr Memory Center'),
        centerTitle: true,
      ),
      body:
          _tradeMemories.isEmpty
              ? const Center(
                child: Text(
                  'No trade memories yet...',
                  style: TextStyle(color: Colors.white60),
                ),
              )
              : ListView.builder(
                itemCount: _tradeMemories.length,
                itemBuilder: (context, index) {
                  final memory = _tradeMemories[index];
                  final isBuy = memory['type'] == 'buy';
                  final color = isBuy ? Colors.greenAccent : Colors.redAccent;

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
                      leading: Icon(
                        isBuy ? Icons.arrow_upward : Icons.arrow_downward,
                        color: color,
                        size: 30,
                      ),
                      title: Text(
                        '${memory['symbol']} @ \$${memory['price']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      subtitle: Text(
                        '${memory['type'].toString().toUpperCase()} — ${DateTime.fromMillisecondsSinceEpoch(memory['timestamp'])}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
