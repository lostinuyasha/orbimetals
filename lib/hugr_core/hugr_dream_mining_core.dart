class HugrDreamMiningCore {
  static Future<List<String>> extractThemes(List<String> rawDreamLogs) async {
    final Set<String> themes = {};
    for (final log in rawDreamLogs) {
      final matches = RegExp(
        r'\b(dream|memory|emotion|reflection|voice)\b',
      ).allMatches(log);
      for (final match in matches) {
        themes.add(match.group(0)!);
      }
    }
    return themes.toList();
  }
}


