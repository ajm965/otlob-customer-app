import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'app_route.dart';
import 'bootstrap_placeholder_page.dart';

class AppRouter {
  AppRouter() : router = _createRouter();

  final GoRouter router;

  static GoRouter _createRouter() {
    return GoRouter(
      initialLocation: AppRoute.bootstrap.path,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoute.bootstrap.path,
          name: AppRoute.bootstrap.name,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage<void>(
              child: BootstrapPlaceholderPage(),
            );
          },
        ),
      ],
    );
  }
}
