class HugrGenericExtension {
  final String name;
  final String description;
  final String exampleAction;

  HugrGenericExtension({
    required this.name,
    required this.description,
    required this.exampleAction,
  });

  String performAction(String prompt) {
    return "[$name Extension] Inspired by '$prompt': $exampleAction";
  }
}


