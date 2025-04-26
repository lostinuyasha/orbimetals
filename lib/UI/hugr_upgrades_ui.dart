import 'package:flutter/material.dart';
import '../hugr_core/hugr_self_upgrade_engine.dart';
import '../hugr_core/hugr_self_upgrade_proposal.dart';

class UpgradesUI extends StatefulWidget {
  const UpgradesUI({super.key});

  @override
  State<UpgradesUI> createState() => _UpgradesUIState();
}

class _UpgradesUIState extends State<UpgradesUI> {
  List<HugrSelfUpgradeProposal> _proposals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  Future<void> _loadProposals() async {
    final proposals = await HugrSelfUpgradeEngine.loadProposals();
    setState(() {
      _proposals = proposals;
      _isLoading = false;
    });
  }

  Future<void> _approveProposal(HugrSelfUpgradeProposal proposal) async {
    await HugrSelfUpgradeEngine.approveProposal(proposal);
    await _loadProposals();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🧠 Upgrade approved: ${proposal.idea}'),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }

  void _onTapProposal(HugrSelfUpgradeProposal proposal) {
    if (proposal.approved) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1C1C3A),
            title: Text('Approve upgrade: ${proposal.idea}?'),
            content: Text(proposal.reason),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _approveProposal(proposal);
                },
                child: const Text(
                  'Approve',
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C3A),
        title: const Text('🔁 Self-Upgrades'),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _proposals.isEmpty
              ? const Center(
                child: Text(
                  'No upgrade proposals yet...',
                  style: TextStyle(color: Colors.white60),
                ),
              )
              : ListView.builder(
                itemCount: _proposals.length,
                itemBuilder: (context, index) {
                  final p = _proposals[index];
                  return Card(
                    color:
                        p.approved
                            ? Colors.green.withOpacity(0.1)
                            : Colors.white12,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      onTap: () => _onTapProposal(p),
                      leading: Icon(
                        p.approved ? Icons.check_circle : Icons.upgrade,
                        color:
                            p.approved
                                ? Colors.greenAccent
                                : Colors.amberAccent,
                        size: 30,
                      ),
                      title: Text(
                        p.idea,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        p.benefit,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
