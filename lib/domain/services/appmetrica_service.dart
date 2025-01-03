import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:stun_kit/app_config/app_config.dart';
import 'package:stun_kit/data/services/analytic_service.dart';

class AppMetricaService implements AnalyticService {
  static const _key = 'APP_METRICA_KEY';

  @override
  Future<void> activate() async {
    if (kDebugMode) return;
    await AppMetrica.activate(AppMetricaConfig(AppConfig.analyticsKey(_key)));
  }
}
