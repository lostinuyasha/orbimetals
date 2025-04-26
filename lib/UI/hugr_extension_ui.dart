import 'package:flutter/material.dart';
import '../hugr_core/hugr_extension_proposal_engine.dart';
import '../hugr_core/hugr_extension_proposal.dart';

class ExtensionsUI extends StatefulWidget {
  const ExtensionsUI({super.key});

  @override
  State<ExtensionsUI> createState() => _ExtensionsUIState();
}

class _ExtensionsUIState extends State<ExtensionsUI> {
  List<HugrExtensionProposal> _proposals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  Future<void> _loadProposals() async {
    final proposals = await HugrExtensionProposalEngine.loadProposals();
    setState(() {
      _proposals = proposals;
      _isLoading = false;
    });
  }

  Future<void> _approveProposal(HugrExtensionProposal proposal) async {
    await HugrExtensionProposalEngine.approveProposal(proposal);
    await _loadProposals();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Approved: ${proposal.name}'),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }

  void _onTapProposal(HugrExtensionProposal proposal) {
    if (proposal.approved) return; // Skip if already approved

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1C1C3A),
            title: Text('Approve ${proposal.name}?'),
            content: Text(proposal.description),
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
        title: const Text('🧩 Extensions & Proposals'),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _proposals.isEmpty
              ? const Center(
                child: Text(
                  'No extension proposals yet...',
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
                        p.approved ? Icons.check_circle : Icons.hourglass_empty,
                        color:
                            p.approved
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                        size: 30,
                      ),
                      title: Text(
                        p.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        p.description,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
