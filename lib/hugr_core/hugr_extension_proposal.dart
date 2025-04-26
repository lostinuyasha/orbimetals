class HugrExtensionProposal {
  final String name;
  final String description;
  final String exampleAction;
  final DateTime timestamp;
  final bool approved; // ✅ Add this!

  HugrExtensionProposal({
    required this.name,
    required this.description,
    required this.exampleAction,
    required this.timestamp,
    this.approved = false, // default to false
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'exampleAction': exampleAction,
      'timestamp': timestamp.toIso8601String(),
      'approved': approved, // ✅ Save approval state
    };
  }

  factory HugrExtensionProposal.fromMap(Map<String, dynamic> map) {
    return HugrExtensionProposal(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      exampleAction: map['exampleAction'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      approved: map['approved'] ?? false, // ✅ Load approval state
    );
  }
}
