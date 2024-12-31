import 'dart:async';

import 'package:example/ui/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:stun_kit/library/printer/printer.dart';
import 'package:stun_kit/ui/app/base_app.dart';

void main() async {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    AppRouterFactory.create();

    runApp(const BaseApp());
  }, (error, stackTrace) {
    Printer.e('', error: error, stackTrace: stackTrace);
  });
}
