class HugrSelfUpgradeProposal {
  final String idea;
  final String reason;
  final String benefit;
  final String solution;
  final DateTime timestamp;
  final bool approved;

  HugrSelfUpgradeProposal({
    required this.idea,
    required this.reason,
    required this.benefit,
    required this.solution,
    required this.timestamp,
    this.approved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'idea': idea,
      'reason': reason,
      'benefit': benefit,
      'solution': solution,
      'timestamp': timestamp.toIso8601String(),
      'approved': approved,
    };
  }

  factory HugrSelfUpgradeProposal.fromMap(Map<String, dynamic> map) {
    return HugrSelfUpgradeProposal(
      idea: map['idea'] ?? '',
      reason: map['reason'] ?? '',
      benefit: map['benefit'] ?? '',
      solution: map['solution'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      approved: map['approved'] ?? false,
    );
  }
}
