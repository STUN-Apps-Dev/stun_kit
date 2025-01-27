import 'dart:async';

import 'package:example/ui/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:stun_kit/stun_kit.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await AppConfig.init();

    AppRouterFactory.create();

    runApp(const BaseApp());
  }, (error, stackTrace) {
    Printer.e('', error: error, stackTrace: stackTrace);
  });
}
