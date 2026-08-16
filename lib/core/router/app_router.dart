import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../app/customer_navigation_shell.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/requests/presentation/requests_page.dart';
import '../../features/services/presentation/services_page.dart';
import 'app_route.dart';

class AppRouter {
  AppRouter() : router = _createRouter();

  final GoRouter router;

  static GoRouter _createRouter() {
    return GoRouter(
      initialLocation: AppRoute.home.path,
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
          builder:
              (
                BuildContext context,
                GoRouterState state,
                StatefulNavigationShell navigationShell,
              ) {
                return CustomerNavigationShell(
                  navigationShell: navigationShell,
                );
              },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.home.path,
                  name: AppRoute.home.name,
                  builder: (BuildContext context, GoRouterState state) =>
                      const HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.services.path,
                  name: AppRoute.services.name,
                  builder: (BuildContext context, GoRouterState state) =>
                      const ServicesPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.requests.path,
                  name: AppRoute.requests.name,
                  builder: (BuildContext context, GoRouterState state) =>
                      const RequestsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.profile.path,
                  name: AppRoute.profile.name,
                  builder: (BuildContext context, GoRouterState state) =>
                      const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/',
          redirect: (BuildContext context, GoRouterState state) =>
              AppRoute.home.path,
        ),
      ],
    );
  }
}
