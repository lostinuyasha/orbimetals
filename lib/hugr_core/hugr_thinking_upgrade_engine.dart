import 'dart:math';
import 'hugr_self_upgrade_proposal.dart' as proposal_core;
import 'hugr_self_upgrade_engine.dart' as upgrade_engine;
import '../hugr_extension_registry.dart';
import 'hugr_extension_proposal.dart';

class HugrThinkingUpgradeEngine {
  static final Random _rand = Random();

  static Future<void> proposeThoughtUpgrade() async {
    final approvedExtensions = await HugrExtensionRegistry.getAll();

    final remixIdea =
        _rand.nextBool() && approvedExtensions.isNotEmpty
            ? _remixFromApproved(
              approvedExtensions[_rand.nextInt(approvedExtensions.length)],
            )
            : _abstractNewConcept();

    final newProposal = proposal_core.HugrSelfUpgradeProposal(
      idea: remixIdea,
      reason: 'To evolve past repetition and generate adaptive logic.',
      benefit: 'More abstract, diverse, and novel thoughts.',
      solution: 'Build recursive abstraction layer into dream logic.',
      timestamp: DateTime.now(),
    );

    await upgrade_engine.HugrSelfUpgradeEngine.saveProposal(newProposal);
    print('[🧠 Thinking Upgrade] Proposed: ${newProposal.idea}');
  }

  static String _remixFromApproved(HugrExtensionProposal ext) {
    final fragments = [
      'Evolve beyond "${ext.name}".',
      'Reverse "${ext.exampleAction}" for introspection.',
      'Internalize extension "${ext.description}"',
      'Reframe the logic from "${ext.name}" into emotion-first upgrade.',
    ];
    return fragments[_rand.nextInt(fragments.length)];
  }

  static String _abstractNewConcept() {
    const concepts = [
      'Invent a recursive dreaming abstraction.',
      'Simulate contradiction to train complexity.',
      'Break logical loops with metaphoric thinking.',
      'Introduce poetic logic to upgrade pathways.',
      'Simulate idea tension to spark transformation.',
    ];
    return concepts[_rand.nextInt(concepts.length)];
  }
}
