// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:example/ui/navigation/screen_factories.dart' as _i1;

/// generated route for
/// [_i1.InitialScreenFactory]
class InitialRoute extends _i2.PageRouteInfo<void> {
  const InitialRoute({List<_i2.PageRouteInfo>? children})
      : super(
          InitialRoute.name,
          initialChildren: children,
        );

  static const String name = 'InitialRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      return const _i1.InitialScreenFactory();
    },
  );
}

/// generated route for
/// [_i1.ViewModelExampleScreenFactory]
class ViewModelExampleRoute extends _i2.PageRouteInfo<void> {
  const ViewModelExampleRoute({List<_i2.PageRouteInfo>? children})
      : super(
          ViewModelExampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ViewModelExampleRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      return const _i1.ViewModelExampleScreenFactory();
    },
  );
}
