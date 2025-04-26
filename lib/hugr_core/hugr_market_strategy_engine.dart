import 'dart:math';
import '../hugr_market_data_analyzer.dart';
import 'hugr_self_upgrade_engine.dart';
import 'hugr_self_upgrade_proposal.dart';

class HugrMarketStrategyEngine {
  static final Random _rand = Random();

  static Future<void> simulateAndProposeStrategy(
    List<Map<String, dynamic>> candles,
  ) async {
    final insights = HugrMarketDataAnalyzer.detectBreakoutSignals(candles);

    if (insights.isEmpty) return;

    final signal = insights[_rand.nextInt(insights.length)];
    final close = signal['close'] ?? 0;
    final volume = signal['volume'] ?? 0;

    final idea =
        'Create strategy based on breakout signal at \$${close.toStringAsFixed(2)} with volume $volume';
    final reason = 'To capitalize on rapid price movement and market momentum.';
    final benefit =
        'Higher probability trades using live and historical data analysis.';
    final solution =
        'Monitor price-volume patterns and initiate trade logic at threshold levels.';

    final proposal = HugrSelfUpgradeProposal(
      idea: idea,
      reason: reason,
      benefit: benefit,
      solution: solution,
      timestamp: DateTime.now(),
    );

    await HugrSelfUpgradeEngine.saveProposal(proposal);
    print(
      '[📈 Strategy Engine] 💡 New strategy proposed: \$${close.toStringAsFixed(2)} breakout',
    );
  }
}
