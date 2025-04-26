import 'hugr_generic_extension.dart';
import 'hugr_extension_manager.dart';

class HugrExtensionInstaller {
  /// Install a new extension based on an approved extension proposal.
  static void installExtension(
    String name,
    String description,
    String exampleAction,
  ) {
    final extensionObject = HugrGenericExtension(
      name: name,
      description: description,
      exampleAction: exampleAction,
    );

    HugrExtensionManager.registerExtension(name, extensionObject);

    print('[HugrExtensionInstaller] 🚀 Extension "$name" installed.');
  }
}


