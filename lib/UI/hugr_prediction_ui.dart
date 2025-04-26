import 'package:flutter/material.dart';
import '../hugr_core/hugr_prediction_engine.dart'; // Make sure this path is right for you
import 'dart:async';

class PredictionUI extends StatefulWidget {
  const PredictionUI({super.key});

  @override
  State<PredictionUI> createState() => _PredictionUIState();
}

class _PredictionUIState extends State<PredictionUI> {
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      setState(
        () {},
      ); // Simply triggers a UI rebuild to show latest predictions
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final predictions = HugrPredictionEngine.getPredictions();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C3A),
        title: const Text('🔮 Market Predictions'),
        centerTitle: true,
      ),
      body:
          predictions.isEmpty
              ? const Center(
                child: Text(
                  'No predictions yet...',
                  style: TextStyle(color: Colors.white60),
                ),
              )
              : ListView.builder(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  final symbol = predictions.keys.elementAt(index);
                  final prediction = predictions[symbol];
                  final color =
                      prediction == 'Bullish'
                          ? Colors.greenAccent
                          : prediction == 'Bearish'
                          ? Colors.redAccent
                          : Colors.blueAccent;

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
                      leading: Icon(Icons.trending_up, color: color, size: 30),
                      title: Text(
                        '$symbol - $prediction',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
