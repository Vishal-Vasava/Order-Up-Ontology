import 'dart:developer';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  FirebaseCrashlytics get crashlytics => _crashlytics;

  // final String _userId = inject.get<AuthLocalRepository>().userId;
  Future<String> logError({
    required dynamic exception,
    required String errorMessage,
    StackTrace? stack,
  }) async {
    log(exception.toString());
    if (!kIsWeb) {
      await crashlytics.recordError(
        exception,
        stack,
        information: [DiagnosticsNode.message('User -   $errorMessage')],
      );
    }
    return exception.toString();
  }
}
