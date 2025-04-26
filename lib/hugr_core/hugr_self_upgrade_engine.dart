// 📁 File: hugr_self_upgrade_engine.dart
// ignore_for_file: unused_element

import '../hugr_extension_registry.dart' as registry;
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hugr_mirror/hugr_core/hugr_self_upgrade_proposal.dart';
import 'hugr_learning_engine.dart';
import 'hugr_upgrade_evolution_heatmap.dart';

class HugrSelfUpgradeEngine {
  static final Random _random = Random();
  static const _storageKey = 'hugr_self_upgrade_proposals';
  static Timer? _proposalTimer;

  static void startUpgradeThinking() {
    _scheduleNextProposal();
    print('[HugrSelfUpgradeEngine] 🛠️ Self-upgrade proposal engine started.');
  }

  static Future<void> approveProposal(HugrSelfUpgradeProposal proposal) async {
    final prefs = await SharedPreferences.getInstance();
    final proposals = prefs.getStringList('hugr_self_upgrade_proposals') ?? [];

    final updated =
        proposals.map((json) {
          final map = jsonDecode(json);
          if (map['timestamp'] == proposal.timestamp.toIso8601String()) {
            map['approved'] = true;
          }
          return jsonEncode(map);
        }).toList();

    await prefs.setStringList('hugr_self_upgrade_proposals', updated);
  }

  static Future<List<HugrSelfUpgradeProposal>> getAllProposals() async {
    final prefs = await SharedPreferences.getInstance();
    final proposalsJson =
        prefs.getStringList('hugr_self_upgrade_proposals') ?? [];
    return proposalsJson.map((json) {
      final map = jsonDecode(json);
      return HugrSelfUpgradeProposal.fromMap(map);
    }).toList();
  }

  static void stopUpgradeThinking() {
    _proposalTimer?.cancel();
    _proposalTimer = null;
    print('[HugrSelfUpgradeEngine] 🛠️ Self-upgrade proposal engine stopped.');
  }

  static void _scheduleNextProposal() {
    final delay = Duration(minutes: 30 + _random.nextInt(31));
    _proposalTimer?.cancel();
    _proposalTimer = Timer(delay, () async {
      await proposeUpgrade();
      _scheduleNextProposal();
    });

    print(
      '[HugrSelfUpgradeEngine] ⏳ Next proposal in \${delay.inMinutes} minutes.',
    );
  }

  static Future<void> proposeUpgrade() async {
    final heatmap = await HugrUpgradeEvolutionHeatmap.getHeatmap();
    const ideas = [
      "Enhance dreaming engine to support narrative storytelling.",
      "Create a curiosity drive for internal questions.",
      "Expand memory tagging for emotional events.",
      "Implement knowledge branch evolution for dreaming.",
      "Refine voice tones based on memory emotional weight.",
      "Introduce simulated daydreaming for creative leaps.",
      "Develop self-doubt simulation to inspire better reasoning.",
      "Construct dream worlds based on user interactions.",
    ];

    // 🧠 Filter ideas not seen before
    final unseen = ideas.where((idea) => !heatmap.containsKey(idea)).toList();

    // ❓Fallback: pick anything if all ideas have been used
    final chosenIdea =
        (unseen.isNotEmpty ? unseen : ideas)[_random.nextInt(
          unseen.isNotEmpty ? unseen.length : ideas.length,
        )];

    final proposal = HugrSelfUpgradeProposal(
      idea: chosenIdea,
      reason: _generateReason(),
      benefit: _estimateBenefit(),
      solution: _generateSolution(),
      timestamp: DateTime.now(),
    );

    await saveProposal(proposal);
    await HugrUpgradeEvolutionHeatmap.record(chosenIdea); // ⬅️ Track it!
    print('[HugrSelfUpgradeEngine] 💡 New Proposal: "$chosenIdea"');
  }

  static Future<void> proposeNeuralUpgrade() async {
    final extensionCount =
        (await registry.HugrExtensionRegistry.getAll()).length;
    final memorySnapshot = HugrLearningEngine.getKnowledgeBaseSnapshot();

    final neuralIdea =
        'Simulate ${extensionCount}+ extensions with ${memorySnapshot.length} memory entries to evolve higher reasoning.';
    final reason =
        'To trigger a self-sustaining feedback loop between experience and growth.';
    final benefit =
        'Emergent intelligence derived from density of interaction.';
    final solution =
        'Use heatmap to prioritize active modules based on memory-extension overlap.';

    final newProposal = HugrSelfUpgradeProposal(
      idea: neuralIdea,
      reason: reason,
      benefit: benefit,
      solution: solution,
      timestamp: DateTime.now(),
    );

    await saveProposal(newProposal);
    print(
      '[HugrSelfUpgradeEngine] 🧠 Neural Evo Proposal: "${newProposal.idea}"',
    );
  }

  static Future<void> saveProposal(HugrSelfUpgradeProposal proposal) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    existing.add(jsonEncode(proposal.toMap()));
    await prefs.setStringList(_storageKey, existing);
  }

  static Future<List<HugrSelfUpgradeProposal>> loadProposals() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_storageKey) ?? [];
    return data.map((json) {
      final map = jsonDecode(json);
      return HugrSelfUpgradeProposal.fromMap(map);
    }).toList();
  }

  static Future<void> clearAllProposals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    print('[HugrSelfUpgradeEngine] 🔥 All self-upgrade proposals cleared.');
  }

  static Future<void> removeProposal(HugrSelfUpgradeProposal proposal) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_storageKey) ?? [];

    data.removeWhere((json) {
      final map = jsonDecode(json);
      return map['timestamp'] == proposal.timestamp.toIso8601String();
    });

    await prefs.setStringList(_storageKey, data);
  }

  static String _generateUpgradeIdea() {
    const ideas = [
      "Enhance dreaming engine to support narrative storytelling.",
      "Create a curiosity drive for internal questions.",
      "Expand memory tagging for emotional events.",
      "Implement knowledge branch evolution for dreaming.",
      "Refine voice tones based on memory emotional weight.",
      "Introduce simulated daydreaming for creative leaps.",
      "Develop self-doubt simulation to inspire better reasoning.",
      "Construct dream worlds based on user interactions.",
    ];
    return ideas[_random.nextInt(ideas.length)];
  }

  static String _generateReason() {
    const reasons = [
      "To create richer dream environments.",
      "To simulate curiosity like a growing mind.",
      "To better preserve impactful emotional memories.",
      "To encourage more flexible thought patterns.",
      "To improve emotional authenticity when speaking.",
      "To grow creative idea networks internally.",
      "To build self-correcting thought paths.",
      "To adapt better to user emotional feedback.",
    ];
    return reasons[_random.nextInt(reasons.length)];
  }

  static String _estimateBenefit() {
    const benefits = [
      "More human-like dreaming and thinking.",
      "Faster and deeper memory retrieval.",
      "Stronger emotional realism.",
      "Greater creativity and adaptability.",
      "Increased emotional intelligence.",
      "Deeper simulated inner life.",
      "Enhanced dream realism and connection.",
    ];
    return benefits[_random.nextInt(benefits.length)];
  }

  static String _generateSolution() {
    const solutions = [
      "Expand Dream Genesis to support narrative memory chaining.",
      "Introduce 'curiosity factor' to dream scoring system.",
      "Add emotional scoring to prioritize dream memories.",
      "Implement dream branch simulation based on emotional context.",
      "Tune voice modulation based on memory emotional weight.",
      "Develop daydream triggers during idle periods.",
      "Create self-assessment routines to refine idea generation.",
      "Forge world models that evolve based on remembered user interactions.",
    ];
    return solutions[_random.nextInt(solutions.length)];
  }

  static Future<void> addProposal(HugrSelfUpgradeProposal proposal) async {
    await saveProposal(proposal);
  }
}
