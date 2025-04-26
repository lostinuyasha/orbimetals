import '../hugr_core/hugr_extension_proposal.dart';
import '../hugr_core/hugr_extension_proposal_engine.dart';
import 'hugr_core/hugr_self_upgrade_engine.dart';
import 'hugr_core/hugr_self_upgrade_proposal.dart';

class HugrExtensionBuilder {
  static Future<void> createSampleExtension() async {
    final proposal = HugrExtensionProposal(
      name: 'Contextual Memory Awareness',
      description:
          'Allows Hugr to recognize when a memory is relevant to the current context, boosting insight and recall.',
      exampleAction:
          'Highlight memories tagged with "purpose" during moments of introspection.',
      timestamp: DateTime.now(),
    );

    await HugrExtensionProposalEngine.addProposal(proposal);
    print('[HugrExtensionBuilder] 🚀 Extension added: ${proposal.name}');
  }

  static Future<void> injectTestUpgrade() async {
    final upgradeProposal = HugrSelfUpgradeProposal(
      idea: 'Add upgrade scoring system',
      reason:
          'Helps prioritize extensions and upgrades based on memory weight.',
      benefit: 'Increases decision quality for self-evolution.',
      solution:
          'Introduce scoring logic to HugrUpgradeEngine with emotional-weighted evaluation.',
      timestamp: DateTime.now(),
    );

    await HugrSelfUpgradeEngine.addProposal(upgradeProposal);
    print(
      '[HugrExtensionBuilder] 💡 Upgrade proposal added: ${upgradeProposal.idea}',
    );
  }
}


