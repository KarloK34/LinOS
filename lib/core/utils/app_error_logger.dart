import 'package:flutter/material.dart';

class AppErrorLogger {
  static void handleError(Object error, StackTrace stackTrace) {
    debugPrint('Global Error: $error');
    debugPrint('Stack Trace: $stackTrace');

    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}
