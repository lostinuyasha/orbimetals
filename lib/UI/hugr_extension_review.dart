// HUGR EXTENSION REVIEW UI ---------------------------------------------
import 'package:flutter/material.dart';
import '../hugr_core/hugr_extension_proposal.dart'; // if you're in lib/ui/
import '../hugr_core/hugr_extension_proposal_engine.dart';

class HugrExtensionReview extends StatefulWidget {
  const HugrExtensionReview({super.key});

  @override
  State<HugrExtensionReview> createState() => _HugrExtensionReviewState();
}

class _HugrExtensionReviewState extends State<HugrExtensionReview> {
  List<HugrExtensionProposal> _proposals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  Future<void> _loadProposals() async {
    final loaded = await HugrExtensionProposalEngine.loadProposals();
    setState(() {
      _proposals = loaded;
      _isLoading = false;
    });
  }

  Future<void> _handleDecision(
    HugrExtensionProposal proposal,
    bool approve,
  ) async {
    await HugrExtensionProposalEngine.removeProposal(proposal);
    setState(() => _proposals.remove(proposal));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          approve
              ? '✅ Approved: ${proposal.name}'
              : '❌ Rejected: ${proposal.name}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧠 Hugr Extension Proposals')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _proposals.isEmpty
              ? const Center(child: Text('No proposals at the moment.'))
              : ListView.builder(
                itemCount: _proposals.length,
                itemBuilder: (context, index) {
                  final p = _proposals[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text(
                        '${p.description}\n\n👉 Example: ${p.exampleAction}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => _handleDecision(p, true),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _handleDecision(p, false),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}


