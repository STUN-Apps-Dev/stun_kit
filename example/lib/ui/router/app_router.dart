import 'package:auto_route/auto_route.dart';
import 'package:example/ui/router/app_router.gr.dart';
import 'package:example/ui/router/routes.dart';
import 'package:stun_kit/ui/router/router.dart';
export 'package:stun_kit/ui/router/router.dart';

@AutoRouterConfig(replaceInRouteName: 'ScreenFactory,Route')
class MyAppRouter extends RootStackRouter {
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
      AutoRoute(
        path: AppRoutes.paginatorExample,
        page: PaginatorExampleRoute.page,
      ),
    ];
  }
}
