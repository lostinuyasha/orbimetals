import 'package:hugr_mirror/hugr_core/hugr_extension_proposal.dart'
    as extension_core;
import '/hugr_extension_registry.dart' as registry_core;
import '/hugr_core/hugr_self_upgrade_engine.dart' as upgrade_core;
import 'package:hugr_mirror/hugr_core/hugr_self_upgrade_proposal.dart'
    as proposal_core;
import 'hugr_upgrade_evolution_heatmap.dart';

class HugrExtensionActionEngine {
  static Future<void> executeApprovedExtensions() async {
    final extensions = await registry_core.HugrExtensionRegistry.getAll();
    for (final ext in extensions) {
      print('[Extension Action] 🛠️ Executing: ${ext.exampleAction}');
      await proposeUpgradeFromExtension(ext); // ✅ bonus upgrade
      await HugrUpgradeEvolutionHeatmap.record(ext.name);
    }
  }

  // 🔁 Bonus upgrade after executing extensions
  static Future<void> proposeUpgradeFromExtension(
    extension_core.HugrExtensionProposal ext,
  ) async {
    final heatmap = await HugrUpgradeEvolutionHeatmap.getHeatmap();
    final idea = 'Upgrade Hugr based on "${ext.name}" behavior';

    if (heatmap.containsKey(idea)) {
      print('[🧠 Extension Upgrade] Skipped duplicate: "$idea"');
      return;
    }

    final upgradeProposal = proposal_core.HugrSelfUpgradeProposal(
      idea: idea,
      reason:
          'To evolve Hugr’s behavior system with real-time extension feedback.',
      benefit: 'Deeper alignment between extensions and autonomous upgrades.',
      solution:
          'Integrate "${ext.exampleAction}" as a recurring behavior pattern.',
      timestamp: DateTime.now(),
    );

    await upgrade_core.HugrSelfUpgradeEngine.saveProposal(upgradeProposal);
    await HugrUpgradeEvolutionHeatmap.record(idea);
    print('[🧠 Extension Upgrade] Proposed: ${upgradeProposal.idea}');
  }
}
