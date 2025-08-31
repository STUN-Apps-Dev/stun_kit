import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stun_kit/stun_kit.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await EnvConfig.init();

    // AppRouter.registerInstance(MyAppRouter());

    runApp(const BaseApp());
  }, (error, stackTrace) {
    Printer.e('', error: error, stackTrace: stackTrace);
  });
}
