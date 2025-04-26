import 'package:flutter/foundation.dart';

class HugrLogger {
  static void log(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}


