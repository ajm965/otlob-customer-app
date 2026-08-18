import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../app/customer_navigation_shell.dart';
import '../../features/authentication/data/mock/mock_authentication.dart';
import '../../features/authentication/domain/models/authentication_state.dart';
import '../../features/authentication/domain/repositories/authentication_repository.dart';
import '../../features/authentication/presentation/authentication_entry_page.dart';
import '../../features/authentication/presentation/authentication_phone_page.dart';
import '../../features/authentication/presentation/authentication_scope.dart';
import '../../features/authentication/presentation/authentication_success_page.dart';
import '../../features/authentication/presentation/authentication_verification_page.dart';
import '../../features/authentication/presentation/registration_profile_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/profile/data/mock/mock_profile.dart';
import '../../features/profile/domain/repositories/customer_profile_repository.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/requests/data/mock/mock_requests.dart';
import '../../features/requests/domain/repositories/customer_request_repository.dart';
import '../../features/requests/presentation/request_detail_page.dart';
import '../../features/requests/presentation/request_details_page.dart';
import '../../features/requests/presentation/request_flow_scope.dart';
import '../../features/requests/presentation/request_location_page.dart';
import '../../features/requests/presentation/request_review_page.dart';
import '../../features/requests/presentation/request_start_page.dart';
import '../../features/requests/presentation/request_success_page.dart';
import '../../features/requests/presentation/requests_page.dart';
import '../../features/services/data/mock/mock_services.dart';
import '../../features/services/domain/repositories/service_catalog_repository.dart';
import '../../features/services/presentation/services_page.dart';
import 'app_route.dart';

class AppRouter {
  AppRouter({
    AuthenticationRepository? authenticationRepository,
    ServiceCatalogRepository? serviceRepository,
    CustomerRequestRepository? requestRepository,
    CustomerProfileRepository? profileRepository,
  }) : router = _createRouter(
         authenticationRepository:
             authenticationRepository ?? const MockAuthenticationRepository(),
         serviceRepository:
             serviceRepository ?? const MockServiceCatalogRepository(),
         requestRepository:
             requestRepository ?? const MockCustomerRequestRepository(),
         profileRepository:
             profileRepository ?? const MockCustomerProfileRepository(),
       );

  final GoRouter router;

  static GoRouter _createRouter({
    required AuthenticationRepository authenticationRepository,
    required ServiceCatalogRepository serviceRepository,
    required CustomerRequestRepository requestRepository,
    required CustomerProfileRepository profileRepository,
  }) {
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
                      HomePage(
                        serviceRepository: serviceRepository,
                        requestRepository: requestRepository,
                      ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.services.path,
                  name: AppRoute.services.name,
                  builder: (BuildContext context, GoRouterState state) =>
                      ServicesPage(repository: serviceRepository),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.requests.path,
                  name: AppRoute.requests.name,
                  builder: (BuildContext context, GoRouterState state) =>
                      RequestsPage(repository: requestRepository),
                  routes: <RouteBase>[
                    GoRoute(
                      path: ':requestId',
                      name: AppRoute.requestDetail.name,
                      builder: (BuildContext context, GoRouterState state) {
                        return RequestDetailPage(
                          requestId: state.pathParameters['requestId']!,
                          repository: requestRepository,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.profile.path,
                  name: AppRoute.profile.name,
                  builder: (BuildContext context, GoRouterState state) =>
                      ProfilePage(repository: profileRepository),
                ),
              ],
            ),
          ],
        ),
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return AuthenticationScope(
              repository: authenticationRepository,
              child: child,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: AppRoute.authentication.path,
              name: AppRoute.authentication.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const AuthenticationEntryPage(),
            ),
            GoRoute(
              path: AppRoute.signIn.path,
              name: AppRoute.signIn.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const AuthenticationPhonePage(
                    flow: AuthenticationFlow.signIn,
                  ),
            ),
            GoRoute(
              path: AppRoute.signInVerification.path,
              name: AppRoute.signInVerification.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const AuthenticationVerificationPage(
                    flow: AuthenticationFlow.signIn,
                  ),
            ),
            GoRoute(
              path: AppRoute.registration.path,
              name: AppRoute.registration.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const AuthenticationPhonePage(
                    flow: AuthenticationFlow.registration,
                  ),
            ),
            GoRoute(
              path: AppRoute.registrationVerification.path,
              name: AppRoute.registrationVerification.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const AuthenticationVerificationPage(
                    flow: AuthenticationFlow.registration,
                  ),
            ),
            GoRoute(
              path: AppRoute.registrationProfile.path,
              name: AppRoute.registrationProfile.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const RegistrationProfilePage(),
            ),
            GoRoute(
              path: AppRoute.authenticationSuccess.path,
              name: AppRoute.authenticationSuccess.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const AuthenticationSuccessPage(),
            ),
          ],
        ),
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return RequestFlowScope(
              serviceId: state.pathParameters['serviceId']!,
              repository: requestRepository,
              serviceRepository: serviceRepository,
              child: child,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: AppRoute.requestStart.path,
              name: AppRoute.requestStart.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const RequestStartPage(),
            ),
            GoRoute(
              path: AppRoute.requestDetails.path,
              name: AppRoute.requestDetails.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const RequestDetailsPage(),
            ),
            GoRoute(
              path: AppRoute.requestLocation.path,
              name: AppRoute.requestLocation.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const RequestLocationPage(),
            ),
            GoRoute(
              path: AppRoute.requestReview.path,
              name: AppRoute.requestReview.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const RequestReviewPage(),
            ),
            GoRoute(
              path: AppRoute.requestSuccess.path,
              name: AppRoute.requestSuccess.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const RequestSuccessPage(),
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
