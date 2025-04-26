import 'package:hugr_mirror/hugr_extensions/hugr_creative_writer_extension.dart';
import 'hugr_generic_extension.dart'; // NEW — we separate Generic extension into its own file!

class HugrExtensionManager {
  static final Map<String, dynamic> _extensions = {};

  /// Initialize Hugr's known extensions.
  static void initialize() {
    _extensions['CreativeWriter'] = HugrCreativeWriterExtension();
    print(
      '[HugrExtensionManager] 🛠️ Extensions initialized: ${_extensions.keys.toList()}',
    );
  }

  /// List all available extensions
  static List<String> listExtensions() {
    return _extensions.keys.toList();
  }

  /// Use a specific extension's ability
  static dynamic useExtension(String extensionName, String prompt) {
    final extension = _extensions[extensionName];
    if (extension == null) {
      print('[HugrExtensionManager] ⚠️ Extension "$extensionName" not found.');
      return "Extension not found.";
    }

    if (extension is HugrCreativeWriterExtension) {
      return extension.writeStory(prompt);
    }

    if (extension is HugrGenericExtension) {
      return extension.performAction(prompt);
    }

    return "Extension loaded, but no known action.";
  }

  /// Add a new extension dynamically
  static void registerExtension(String name, dynamic extensionObject) {
    _extensions[name] = extensionObject;
    print('[HugrExtensionManager] 🔥 New Extension registered: $name');
  }
}


