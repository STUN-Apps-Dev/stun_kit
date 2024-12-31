import 'package:auto_route/auto_route.dart';
import 'package:example/ui/navigation/app_router.gr.dart';
import 'package:example/ui/navigation/routes.dart';
import 'package:stun_kit/ui/navigation/app_router.dart';
export 'package:stun_kit/ui/navigation/navigation.dart';

@AutoRouterConfig(replaceInRouteName: 'ScreenFactory,Route')
class _AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(
        path: AppRoutes.initial,
        page: InitialRoute.page,
        initial: true,
      ),
      AutoRoute(
        path: AppRoutes.viewModelExample,
        page: ViewModelExampleRoute.page,
      ),
    ];
  }
}

class AppRouterFactory {
  static void create() {
    AppRouter.registerInstance(_AppRouter());
  }
}
