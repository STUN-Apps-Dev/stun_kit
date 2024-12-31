import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stun_kit/library/printer/printer.dart';
import 'package:stun_kit/ui/navigation/navigation/app_navigator.dart';

class LoggerObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    if (kDebugMode) {
      Printer.i('New route pushed: ${AppRouter.instance.uri}');
    }
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    if (kDebugMode) {
      Printer.i('Tab route visited: ${AppRouter.instance.uri}');
    }
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    if (kDebugMode) {
      Printer.i('Tab route re-visited: ${route.path}');
    }
  }
}
