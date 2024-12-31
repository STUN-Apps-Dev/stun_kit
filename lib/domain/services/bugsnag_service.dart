import 'dart:async';

import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:stun_kit/app_config/app_config.dart';
import 'package:stun_kit/data/services/exception_service.dart';
import 'package:stun_kit/library/printer/printer.dart';

class BugsnagService implements ExceptionService {
  static const _key = 'BUGSNAG_KEY';

  @override
  Future<void> init() async {
    if (!kDebugMode) await bugsnag.start(apiKey: AppConfig.debugerKey(_key));

    FlutterError.onError = (details) {
      capture(details.exception, details.stack);
    };
  }

  @override
  Future<void> capture(Object error, StackTrace? stackTrace) async {
    Printer.e('', error: error, stackTrace: stackTrace);

    if (!kIsWeb && !kDebugMode) {
      return bugsnag.notify(error, stackTrace);
    }
  }

  @override
  FutureOr<void> markLaunchCompleted() {
    if (!kDebugMode) return bugsnag.markLaunchCompleted();
    return null;
  }
}
