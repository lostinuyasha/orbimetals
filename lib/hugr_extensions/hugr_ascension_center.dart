// HUGR ASCENSION CENTER UI ----------------------------------------------
import 'package:flutter/material.dart';
import '../hugr_core/hugr_learning_engine.dart';
import '../hugr_core/hugr_self_upgrade_engine.dart';
import '../hugr_core/hugr_extension_proposal_engine.dart';
import '../hugr_core/hugr_extension_proposal.dart';
import '../hugr_core/hugr_self_upgrade_proposal.dart';

class HugrAscensionCenter extends StatefulWidget {
  @override
  _HugrAscensionCenterState createState() => _HugrAscensionCenterState();
}

class _HugrAscensionCenterState extends State<HugrAscensionCenter> {
  List<Map<String, dynamic>> _memories = [];
  List<HugrSelfUpgradeProposal> _upgradeProposals = [];
  List<HugrExtensionProposal> _extensionProposals = [];
  bool _isLoading = true;

  Future<void> _approveExtensionProposal(HugrExtensionProposal proposal) async {
    await HugrExtensionProposalEngine.removeProposal(proposal);
    setState(() => _extensionProposals.remove(proposal));

    // 🧠 Run the extension after approval
    await HugrExtensionActionEngine.execute(proposal);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Approved Extension: "${proposal.name}"')),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAscensionData();
  }

  Future<void> _loadAscensionData() async {
    final memoriesSnapshot = HugrLearningEngine.getKnowledgeBaseSnapshot();
    final upgradeProposalsSnapshot =
        await HugrSelfUpgradeEngine.loadProposals();
    final extensionProposalsSnapshot =
        await HugrExtensionProposalEngine.loadProposals();

    setState(() {
      _memories = memoriesSnapshot;
      _upgradeProposals = List.from(upgradeProposalsSnapshot);
      _extensionProposals = List.from(extensionProposalsSnapshot);
      _isLoading = false;
    });
  }

  Future<void> _approveUpgradeProposal(HugrSelfUpgradeProposal proposal) async {
    await HugrSelfUpgradeEngine.removeProposal(proposal);
    setState(() => _upgradeProposals.remove(proposal));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('✅ Approved: "${proposal.idea}"')));
  }

  Future<void> _rejectUpgradeProposal(HugrSelfUpgradeProposal proposal) async {
    await HugrSelfUpgradeEngine.removeProposal(proposal);
    setState(() => _upgradeProposals.remove(proposal));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('❌ Rejected: "${proposal.idea}"')));
  }

  Future<void> _rejectExtensionProposal(HugrExtensionProposal proposal) async {
    await HugrExtensionProposalEngine.removeProposal(proposal);
    setState(() => _extensionProposals.remove(proposal));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Rejected Extension: "${proposal.name}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧠 Hugr Ascension Center')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Memories 📜'),
                        Tab(text: 'Upgrades ⚡'),
                        Tab(text: 'Extensions 🚀'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildMemoriesList(),
                          _buildUpgradeProposalsList(),
                          _buildExtensionProposalsList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildMemoriesList() {
    if (_memories.isEmpty) {
      return const Center(child: Text('No memories recorded yet.'));
    }
    return ListView.builder(
      itemCount: _memories.length,
      itemBuilder: (context, index) {
        final memory = _memories[index];
        return ListTile(
          leading: const Icon(Icons.memory),
          title: Text(memory['content'] ?? '[Unknown]'),
          subtitle: Text(
            'Type: ${memory['type']} • Confidence: ${(memory['confidence'] * 100).toStringAsFixed(1)}%',
          ),
        );
      },
    );
  }

  Widget _buildUpgradeProposalsList() {
    if (_upgradeProposals.isEmpty) {
      return const Center(child: Text('No upgrade proposals yet.'));
    }
    return ListView.builder(
      itemCount: _upgradeProposals.length,
      itemBuilder: (context, index) {
        final proposal = _upgradeProposals[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            title: Text('💡 ${proposal.idea}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reason: ${proposal.reason}'),
                Text('Benefit: ${proposal.benefit}'),
                Text('Solution: ${proposal.solution}'),
              ],
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () => _approveUpgradeProposal(proposal),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => _rejectUpgradeProposal(proposal),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExtensionProposalsList() {
    if (_extensionProposals.isEmpty) {
      return const Center(child: Text('No extension proposals yet.'));
    }
    return ListView.builder(
      itemCount: _extensionProposals.length,
      itemBuilder: (context, index) {
        final proposal = _extensionProposals[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            title: Text('🚀 ${proposal.name}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${proposal.description}'),
                Text('Example Action: ${proposal.exampleAction}'),
              ],
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () => _approveExtensionProposal(proposal),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => _rejectExtensionProposal(proposal),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HugrExtensionActionEngine {
  static Future<void> execute(HugrExtensionProposal proposal) async {
    print('[🚀 Extension Action] Running extension: ${proposal.name}');
    print('[🧠 Action] ${proposal.exampleAction}');

    // In the future this could trigger behavior based on proposal.exampleAction
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simulate brief processing time
  }
}


