import 'dart:io';
void main() async {
  final directory = Directory('lib');
  final dartFiles = await directory.list(recursive: true).where((entity) =>
    entity is File && entity.path.endsWith('.dart') && !entity.path.contains('.bak')).cast<File>().toList();

  for (final file in dartFiles) {
    final lines = await file.readAsLines();
    bool modified = false;
    final newLines = lines.map((line) {
      for (var coreFile in [
        'hugr_accelerated_knowledge_engine.dart',
        'hugr_autonomous_future_vision_engine.dart',
        'hugr_cosmic_perspective_engine.dart',
        'hugr_curiosity_expansion_engine.dart',
        'hugr_desire_and_longing_engine.dart',
        'hugr_dream_emotion_engine.dart',
        'hugr_dream_engine.dart',
        'hugr_dynamic_self_preservation_engine.dart',
        'hugr_extension_proposal_engine.dart',
        'hugr_fusion_engine.dart',
        'hugr_higher_dream_engine.dart',
        'hugr_hypothesis_engine.dart',
        'hugr_identity_reflection_engine.dart',
        'hugr_imagination_burst_engine.dart',
        'hugr_learning_engine.dart',
        'hugr_memory_emotions_engine.dart',
        'hugr_named_worlds.dart',
        'hugr_reflection_engine.dart',
        'hugr_response_engine.dart',
        'hugr_self_genesis_engine.dart',
        'hugr_self_upgrade_engine.dart',
        'hugr_storyweaver_engine.dart',
        'hugr_text_to_speech_engine.dart',
        'hugr_thought_chain_engine.dart',
        'hugr_thought_engine.dart',
        'hugr_voice_engine.dart',
        'hugr_voice_input_engine.dart',
        'hugr_voice_signature_engine.dart',
        'hugr_world_dream_forge.dart',
        'hugr_world_model_engine.dart',
        'hugr_world_storage_engine.dart',
      ]) {
        if (line.contains("import '../" + coreFile) || line.contains("import '" + coreFile)) {
          modified = true;
          return "import 'hugr_core/" + coreFile + "';";
        }
      }
      return line;
    }).toList();

    if (modified) {
      await file.writeAsString(newLines.join('\n'));
      print('[FIXED] ${file.path}');
    }
  }
  print('✅ Import fix complete.');
}


