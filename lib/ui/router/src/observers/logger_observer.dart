// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:stun_kit/config/src/config.dart';
// import 'package:stun_kit/library/printer/printer.dart';
// import 'package:stun_kit/ui/router/src/router.dart';
//
// class LoggerObserver extends AutoRouterObserver {
//   @override
//   void didPush(Route route, Route? previousRoute) {
//     if (EnvConfig.isRouterDebug) {
//       Printer.i('New route pushed: ${AppRouter.instance.uri}');
//     }
//   }
//
//   @override
//   void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
//     if (EnvConfig.isRouterDebug) {
//       Printer.i('Tab route visited: ${AppRouter.instance.uri}');
//     }
//   }
// }
//
// @override
// void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
//   if (EnvConfig.isRouterDebug) {
//     Printer.i('Tab route re-visited: ${route.path}');
//   }
// }
