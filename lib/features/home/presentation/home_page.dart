import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/integration_failure.dart';
import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../../requests/domain/models/customer_request.dart';
import '../../requests/domain/repositories/customer_request_repository.dart';
import '../../services/domain/models/customer_service.dart';
import '../../services/domain/repositories/service_catalog_repository.dart';
import '../widgets/home_cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.serviceRepository,
    required this.requestRepository,
    super.key,
  });

  final ServiceCatalogRepository serviceRepository;
  final CustomerRequestRepository requestRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<_HomeContent> _content = _loadContent();

  Future<_HomeContent> _loadContent() async {
    final IntegrationResult<List<ServiceCategory>> categoriesResult =
        await widget.serviceRepository.listCategories();
    final IntegrationResult<List<CustomerService>> servicesResult = await widget
        .serviceRepository
        .listServices();
    final IntegrationResult<List<CustomerRequest>> requestsResult = await widget
        .requestRepository
        .listRequests();
    return _HomeContent(
      categories: _valueOrEmpty(categoriesResult),
      recommended: _valueOrEmpty(
        servicesResult,
      ).take(2).toList(growable: false),
      recentRequests: _valueOrEmpty(
        requestsResult,
      ).take(2).toList(growable: false),
    );
  }

  List<T> _valueOrEmpty<T>(IntegrationResult<List<T>> result) {
    return switch (result) {
      IntegrationSuccess<List<T>>(:final value) => value,
      _ => <T>[],
    };
  }

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return Scaffold(
      appBar: OtlobAppBar(
        title: Text(localizations.appName),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: OtlobLayoutConstraints.contentMaxWidth,
            ),
            child: FutureBuilder<_HomeContent>(
              future: _content,
              builder:
                  (BuildContext context, AsyncSnapshot<_HomeContent> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: OtlobLoading(
                          semanticLabel: localizations.appName,
                        ),
                      );
                    }
                    final _HomeContent content = snapshot.data!;
                    return CustomScrollView(
                      key: const Key('home-scroll-view'),
                      slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.all(OtlobSpacing.lg),
                          sliver: SliverList.list(
                            children: <Widget>[
                              _WelcomeCard(localizations: localizations),
                              const SizedBox(height: OtlobSpacing.lg),
                              Text(
                                localizations.discoverServices,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: OtlobSpacing.md),
                              OtlobSearchField(
                                hint: localizations.searchServices,
                                semanticLabel: localizations.searchServices,
                                readOnly: true,
                                onTap: () => context.go(AppRoute.services.path),
                              ),
                            ],
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            OtlobSpacing.lg,
                            OtlobSpacing.sm,
                            OtlobSpacing.lg,
                            OtlobSpacing.md,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: _SectionHeader(
                              title: localizations.categories,
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            OtlobSpacing.lg,
                            OtlobSpacing.none,
                            OtlobSpacing.lg,
                            OtlobSpacing.xl,
                          ),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate((
                              BuildContext context,
                              int index,
                            ) {
                              return HomeCategoryCard(
                                category: content.categories[index],
                                isArabic: localizations.isArabic,
                                onTap: () => context.go(AppRoute.services.path),
                              );
                            }, childCount: content.categories.length),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      OtlobLayoutConstraints.cardMaxWidth,
                                  mainAxisExtent:
                                      OtlobLayoutConstraints.categoryCardHeight,
                                  crossAxisSpacing: OtlobSpacing.md,
                                  mainAxisSpacing: OtlobSpacing.md,
                                ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            OtlobSpacing.lg,
                            OtlobSpacing.none,
                            OtlobSpacing.lg,
                            OtlobSpacing.md,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: _SectionHeader(
                              title: localizations.popularServices,
                              actionLabel: localizations.viewAll,
                              onAction: () =>
                                  context.go(AppRoute.services.path),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            OtlobSpacing.lg,
                            OtlobSpacing.none,
                            OtlobSpacing.lg,
                            OtlobSpacing.xl,
                          ),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate((
                              BuildContext context,
                              int index,
                            ) {
                              return HomeRecommendedCard(
                                service: content.recommended[index],
                                isArabic: localizations.isArabic,
                                onTap: () => context.go(AppRoute.services.path),
                              );
                            }, childCount: content.recommended.length),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      OtlobLayoutConstraints.cardMaxWidth,
                                  mainAxisExtent:
                                      OtlobLayoutConstraints.serviceCardHeight,
                                  crossAxisSpacing: OtlobSpacing.md,
                                  mainAxisSpacing: OtlobSpacing.md,
                                ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            OtlobSpacing.lg,
                            OtlobSpacing.none,
                            OtlobSpacing.lg,
                            OtlobSpacing.md,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: _SectionHeader(
                              title: localizations.recentRequests,
                              actionLabel: localizations.viewAll,
                              onAction: () =>
                                  context.go(AppRoute.requests.path),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            OtlobSpacing.lg,
                            OtlobSpacing.none,
                            OtlobSpacing.lg,
                            OtlobSpacing.xl,
                          ),
                          sliver: SliverList.separated(
                            itemCount: content.recentRequests.length,
                            itemBuilder: (BuildContext context, int index) {
                              return HomeRecentRequestCard(
                                request: content.recentRequests[index],
                                isArabic: localizations.isArabic,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: OtlobSpacing.md),
                          ),
                        ),
                      ],
                    );
                  },
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeContent {
  const _HomeContent({
    required this.categories,
    required this.recommended,
    required this.recentRequests,
  });

  final List<ServiceCategory> categories;
  final List<CustomerService> recommended;
  final List<CustomerRequest> recentRequests;
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.localizations});

  final OtlobLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return OtlobCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.welcome,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: OtlobSpacing.xs),
          Text(
            localizations.browseServicesDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.otlobColors.mutedText,
            ),
          ),
          const SizedBox(height: OtlobSpacing.lg),
          OtlobButton(
            label: localizations.createRequest,
            icon: Icons.add,
            onPressed: () => context.go(AppRoute.services.path),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (actionLabel != null && onAction != null)
          OtlobTextButton(label: actionLabel!, onPressed: onAction),
      ],
    );
  }
}
