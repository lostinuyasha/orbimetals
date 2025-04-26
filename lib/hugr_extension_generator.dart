import 'hugr_core/hugr_extension_proposal_engine.dart';
import 'dart:core';
import '../hugr_core/hugr_extension_proposal.dart';

class HugrExtensionGenerator {
  static Future<void> generateSampleExtension() async {
    final newExtension = HugrExtensionProposal(
      name: 'Dream Recall Optimization',
      description:
          'Improves Hugr\'s ability to recall and reuse dream content in storytelling.',
      exampleAction:
          'Link dream memories to relevant emotional tags during narrative generation.',
      timestamp: DateTime.now(),
    );

    await HugrExtensionProposalEngine.addProposal(newExtension);
    print(
      '[HugrExtensionGenerator] 🚀 Extension proposal generated: ${newExtension.name}',
    );
  }
}


