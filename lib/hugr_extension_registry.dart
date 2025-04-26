import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'hugr_core/hugr_extension_proposal.dart';

class HugrExtensionRegistry {
  static const _key = 'approved_hugr_extensions';

  static Future<void> add(HugrExtensionProposal extension) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];
    current.add(jsonEncode(extension.toMap()));
    await prefs.setStringList(_key, current);
  }

  static Future<List<HugrExtensionProposal>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((json) {
      final map = jsonDecode(json);
      return HugrExtensionProposal.fromMap(map);
    }).toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}


