import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../hugr_core/market_api_service.dart';

class HugrSettingsUI extends StatefulWidget {
  const HugrSettingsUI({super.key});

  @override
  State<HugrSettingsUI> createState() => _HugrSettingsUIState();
}

class _HugrSettingsUIState extends State<HugrSettingsUI> {
  bool _liveScanning = true;
  int _predictionFrequency = 30;
  List<String> _symbolsToTrack = ['AAPL', 'MSFT', 'SPY', 'QQQ'];
  HugrRiskMode _riskMode = HugrRiskMode.conservative;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _liveScanning = prefs.getBool('hugr_live_scanning') ?? true;
      _predictionFrequency = prefs.getInt('hugr_prediction_frequency') ?? 30;
      _symbolsToTrack =
          prefs.getStringList('hugr_symbols_to_track') ?? _symbolsToTrack;
      final riskString = prefs.getString('hugr_risk_mode') ?? 'conservative';
      _riskMode =
          riskString == 'aggressive'
              ? HugrRiskMode.aggressive
              : HugrRiskMode.conservative;
      MarketApiService.riskMode = _riskMode;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hugr_live_scanning', _liveScanning);
    await prefs.setInt('hugr_prediction_frequency', _predictionFrequency);
    await prefs.setStringList('hugr_symbols_to_track', _symbolsToTrack);
    await prefs.setString('hugr_risk_mode', _riskMode.name);
  }

  void _toggleLiveScanning(bool value) {
    setState(() => _liveScanning = value);
    _saveSettings();
  }

  void _resetSignals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('hugr_market_signals');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All signals have been reset.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C3A),
        title: const Text('⚙️ Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: _liveScanning,
            onChanged: _toggleLiveScanning,
            title: const Text('Enable Live Scanning'),
            subtitle: const Text(
              'Allows Hugr to fetch live trade signals every 60s',
            ),
            activeColor: Colors.greenAccent,
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Prediction Frequency'),
            subtitle: Text('$_predictionFrequency seconds'),
            trailing: const Icon(Icons.edit, color: Colors.white60),
            onTap: () async {
              final newValue = await _showNumberPicker(
                context,
                _predictionFrequency,
              );
              if (newValue != null) {
                setState(() => _predictionFrequency = newValue);
                _saveSettings();
              }
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            title: const Text('Symbols to Track'),
            subtitle: Text(_symbolsToTrack.join(', ')),
            trailing: const Icon(Icons.list, color: Colors.white60),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            value: _riskMode == HugrRiskMode.aggressive,
            onChanged: (value) {
              setState(() {
                _riskMode =
                    value ? HugrRiskMode.aggressive : HugrRiskMode.conservative;
                MarketApiService.riskMode = _riskMode;
                _saveSettings();
              });
            },
            title: const Text('Risk Mode'),
            subtitle: Text(
              _riskMode == HugrRiskMode.aggressive
                  ? '💥 Aggressive Trading (tighter thresholds)'
                  : '🛡️ Conservative Trading (wider thresholds)',
            ),
            activeColor: Colors.orangeAccent,
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text(
              'Reset All Signals',
              style: TextStyle(color: Colors.redAccent),
            ),
            trailing: const Icon(Icons.delete, color: Colors.redAccent),
            onTap: _resetSignals,
          ),
        ],
      ),
    );
  }

  Future<int?> _showNumberPicker(BuildContext context, int currentValue) async {
    int tempValue = currentValue;
    return showDialog<int>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1C1C3A),
            title: const Text('Set Prediction Frequency'),
            content: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$tempValue seconds'),
                    Slider(
                      value: tempValue.toDouble(),
                      min: 10,
                      max: 120,
                      divisions: 11,
                      label: '$tempValue',
                      onChanged:
                          (val) =>
                              setDialogState(() => tempValue = val.toInt()),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, tempValue),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
