import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugr_mirror/hugr_core/hugr_market_insight_engine.dart';

class HugrTradeUI extends StatefulWidget {
  const HugrTradeUI({super.key});

  @override
  State<HugrTradeUI> createState() => _HugrTradeUIState();
}

class _HugrTradeUIState extends State<HugrTradeUI> {
  Timer? _refreshTimer; // <-- put it here!
  List<Map<String, dynamic>> _tradeSignals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTradeSignals();
  }

  void _loadTradeSignals() {
    setState(() {
      _tradeSignals = HugrMarketInsightEngine.getAllSignals().reversed.toList();
      _isLoading = false;
    });
  }

  Widget _buildSignalCard(Map<String, dynamic> signal) {
    final bool isBuy = signal['type'] == 'buy';
    final Color color = isBuy ? Colors.greenAccent : Colors.redAccent;
    final IconData icon = isBuy ? Icons.arrow_upward : Icons.arrow_downward;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          '${signal['symbol']} • \$${signal['price']}',
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        subtitle: Text(
          'Type: ${signal['type'].toUpperCase()} • '
          '${DateTime.fromMillisecondsSinceEpoch(signal['timestamp'])}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing:
            signal['note'] != ''
                ? const Icon(Icons.note, color: Colors.blueGrey)
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C3A),
        title: const Text('📈 Hugr Trade Signals'),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _tradeSignals.isEmpty
              ? const Center(
                child: Text(
                  'No signals yet.',
                  style: TextStyle(color: Colors.white60),
                ),
              )
              : ListView.builder(
                itemCount: _tradeSignals.length,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 1.0,
                    child: _buildSignalCard(_tradeSignals[index]),
                  );
                },
              ),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
