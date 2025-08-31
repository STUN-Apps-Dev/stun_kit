import 'package:flutter/material.dart';
import 'package:stun_kit/library/printer/printer.dart';

class LoggerObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    Printer.i(
      '[Router] PUSH ${_routeLabel(route)}  <=  ${_routeLabel(previousRoute)}',
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    Printer.i(
      '[Router] POP ${_routeLabel(route)}  =>  ${_routeLabel(previousRoute)}',
    );
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    Printer.i(
      '[Router] REPLACE ${_routeLabel(oldRoute)}  ->  ${_routeLabel(newRoute)}',
    );
  }

  String _routeLabel(Route? r) {
    if (r == null) return '—';
    final settings = r.settings;
    final name = settings.name;
    final key = settings is Page ? settings.key : null;
    return '${r.runtimeType}${name != null ? '("$name")' : ''}${key != null ? '[$key]' : ''}';
  }
}
