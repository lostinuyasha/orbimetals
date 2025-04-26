// 📁 File: hugr_extension_proposal_engine.dart

import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'hugr_extension_proposal.dart';
import 'hugr_self_upgrade_engine.dart';
import 'hugr_self_upgrade_proposal.dart';

class HugrExtensionProposalEngine {
  static final Random _random = Random();
  static const _storageKey = 'hugr_extension_proposals';
  static Timer? _proposalTimer;
  static final List<HugrExtensionProposal> _proposals = [];

  static Future<List<HugrExtensionProposal>> loadProposals() async {
    final prefs = await SharedPreferences.getInstance();
    final proposalsJson = prefs.getStringList(_storageKey) ?? [];
    _proposals.clear();
    _proposals.addAll(
      proposalsJson.map((json) {
        final map = jsonDecode(json);
        return HugrExtensionProposal.fromMap(map);
      }),
    );
    await deduplicateProposals();
    return List.unmodifiable(_proposals);
  }

  static Future<void> addProposal(HugrExtensionProposal proposal) async {
    if (isDuplicate(proposal)) {
      print(
        '[HugrExtensionProposalEngine] ⚠️ Duplicate skipped: ${proposal.name}',
      );
      return;
    }
    _proposals.add(proposal);
    await _saveProposal(proposal);
    print('[HugrExtensionProposalEngine] ✅ Proposal added: ${proposal.name}');
  }

  static Future<void> clearAllProposals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    _proposals.clear();
    print('[HugrExtensionProposalEngine] 🔥 All extension proposals cleared.');
  }

  static Future<void> removeProposal(HugrExtensionProposal proposal) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    existing.removeWhere((json) {
      final map = jsonDecode(json);
      return map['timestamp'] == proposal.timestamp.toIso8601String();
    });
    await prefs.setStringList(_storageKey, existing);
    _proposals.removeWhere((p) => p.timestamp == proposal.timestamp);
  }

  static bool isDuplicate(HugrExtensionProposal proposal) {
    return _proposals.any(
      (p) =>
          p.name.toLowerCase() == proposal.name.toLowerCase() ||
          _normalize(p.description) == _normalize(proposal.description),
    );
  }

  static Future<void> deduplicateProposals() async {
    final Set<String> seen = {};
    final List<HugrExtensionProposal> unique = [];
    for (final p in _proposals) {
      final hash = _normalize(p.name + p.description);
      if (!seen.contains(hash)) {
        seen.add(hash);
        unique.add(p);
      }
    }
    _proposals
      ..clear()
      ..addAll(unique);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      _proposals.map((p) => jsonEncode(p.toMap())).toList(),
    );
    print(
      '[HugrExtensionProposalEngine] ✅ Deduplicated: ${_proposals.length} remain.',
    );
  }

  static Future<void> _saveProposal(HugrExtensionProposal proposal) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    existing.add(jsonEncode(proposal.toMap()));
    await prefs.setStringList(_storageKey, existing);
  }

  static String _normalize(String input) =>
      input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  static void startProposingExtensions({
    Duration interval = const Duration(hours: 2),
  }) {
    _proposalTimer?.cancel();
    _proposalTimer = Timer.periodic(interval, (_) => proposeExtension());
    print(
      '[HugrExtensionProposalEngine] 🔄 Auto-proposal started every ${interval.inMinutes} minutes.',
    );
  }

  static void stopProposingExtensions() {
    _proposalTimer?.cancel();
    _proposalTimer = null;
    print('[HugrExtensionProposalEngine] 🛑 Auto-proposal stopped.');
  }

  static Future<void> proposeExtension() async {
    final proposal = HugrExtensionProposal(
      name: _generateExtensionName(),
      description: _generateExtensionDescription(),
      exampleAction: _generateExampleAction(),
      timestamp: DateTime.now(),
    );
    await addProposal(proposal);
  }

  static String _generateExtensionName() =>
      [
        'Dream Constellation Mapper',
        'Voice Tone Calibration',
        'Curiosity Signal Enhancer',
        'Context Clue Reinforcer',
        'Emotional Weight Visualizer',
      ][_random.nextInt(5)];

  static String _generateExtensionDescription() =>
      [
        'Maps connections between related dream fragments for visual insight.',
        'Adapts tone to emotional memory markers when speaking.',
        'Highlights unknowns in memory paths to trigger curiosity.',
        'Reinforces importance of context by anchoring related data.',
        'Visualizes memory emotional weight as color-coded graphs.',
      ][_random.nextInt(5)];

  static String _generateExampleAction() =>
      [
        'Draw lines between memory clusters in dream state.',
        'Adjust tone when speaking about sad or joyful events.',
        'Trigger exploratory dreaming when unknown tags are detected.',
        'Display connected concepts while narrating context-rich thoughts.',
        'Overlay dream scene color filters based on memory emotion score.',
      ][_random.nextInt(5)];
  static List<Map<String, dynamic>> getAllProposals() {
    return _proposals.map((p) => p.toMap()).toList();
  }

  static Future<void> approveProposal(HugrExtensionProposal proposal) async {
    final prefs = await SharedPreferences.getInstance();
    final proposals = prefs.getStringList(_storageKey) ?? [];

    final updatedProposals =
        proposals.map((json) {
          final map = jsonDecode(json);
          if (map['timestamp'] == proposal.timestamp.toIso8601String()) {
            map['approved'] = true; // ✅ Mark as approved
            return jsonEncode(map);
          }
          return json;
        }).toList();

    await prefs.setStringList(_storageKey, updatedProposals);

    // Also update the in-memory version
    final index = _proposals.indexWhere(
      (p) => p.timestamp == proposal.timestamp,
    );
    if (index != -1) {
      _proposals[index] = HugrExtensionProposal(
        name: proposal.name,
        description: proposal.description,
        exampleAction: proposal.exampleAction,
        timestamp: proposal.timestamp,
        approved: true,
      );
    }

    print('[HugrExtensionProposalEngine] ✅ Approved: ${proposal.name}');
  }
}

// Optionally inject a test upgrade too
Future<void> injectExtensionUpgrade() async {
  final upgrade = HugrSelfUpgradeProposal(
    idea: 'Allow extensions to evolve contextually',
    reason: 'So extensions can adapt based on recent memory activity.',
    benefit: 'Dynamic self-evolution and better responsiveness.',
    solution: 'Link extension triggers to HugrLearningEngine active clusters.',
    timestamp: DateTime.now(),
  );
  await HugrSelfUpgradeEngine.saveProposal(upgrade);
  print('[HugrExtensionProposalEngine] 🧠 Upgrade proposed: ${upgrade.idea}');
}
