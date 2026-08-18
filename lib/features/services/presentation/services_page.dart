import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/integration_failure.dart';
import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../domain/models/customer_service.dart';
import '../domain/repositories/service_catalog_repository.dart';
import '../widgets/service_cards.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({required this.repository, super.key});

  final ServiceCatalogRepository repository;

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late final Future<IntegrationResult<List<ServiceCategory>>> _categories =
      widget.repository.listCategories();
  late final Future<IntegrationResult<List<CustomerService>>> _services = widget
      .repository
      .listServices();

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return Scaffold(
      appBar: OtlobAppBar(title: Text(localizations.services)),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: OtlobLayoutConstraints.contentMaxWidth,
            ),
            child: FutureBuilder<IntegrationResult<List<ServiceCategory>>>(
              future: _categories,
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<IntegrationResult<List<ServiceCategory>>>
                    categorySnapshot,
                  ) {
                    return FutureBuilder<
                      IntegrationResult<List<CustomerService>>
                    >(
                      future: _services,
                      builder:
                          (
                            BuildContext context,
                            AsyncSnapshot<
                              IntegrationResult<List<CustomerService>>
                            >
                            serviceSnapshot,
                          ) {
                            if (!categorySnapshot.hasData ||
                                !serviceSnapshot.hasData) {
                              return Center(
                                child: OtlobLoading(
                                  semanticLabel: localizations.appName,
                                ),
                              );
                            }
                            final List<ServiceCategory> categories =
                                _valueOrEmpty(categorySnapshot.data);
                            final List<CustomerService> services =
                                _valueOrEmpty(serviceSnapshot.data);
                            return CustomScrollView(
                              key: const Key('services-scroll-view'),
                              slivers: <Widget>[
                                SliverPadding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                    OtlobSpacing.lg,
                                    OtlobSpacing.lg,
                                    OtlobSpacing.lg,
                                    OtlobSpacing.sm,
                                  ),
                                  sliver: SliverToBoxAdapter(
                                    child: Text(
                                      localizations.browseServicesDescription,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color:
                                                context.otlobColors.mutedText,
                                          ),
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.all(
                                    OtlobSpacing.lg,
                                  ),
                                  sliver: SliverGrid(
                                    delegate: SliverChildBuilderDelegate((
                                      BuildContext context,
                                      int index,
                                    ) {
                                      return ServiceCategoryCard(
                                        category: categories[index],
                                        isArabic: localizations.isArabic,
                                        onTap: () => _showDeferredMessage(
                                          context,
                                          localizations.serviceDetails,
                                        ),
                                      );
                                    }, childCount: categories.length),
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent:
                                              OtlobLayoutConstraints
                                                  .cardMaxWidth,
                                          mainAxisExtent: OtlobLayoutConstraints
                                              .categoryCardHeight,
                                          crossAxisSpacing: OtlobSpacing.md,
                                          mainAxisSpacing: OtlobSpacing.md,
                                        ),
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
                                    child: Text(
                                      localizations.popularServices,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
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
                                    itemCount: services.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                          return ServiceCard(
                                            service: services[index],
                                            isArabic: localizations.isArabic,
                                            onTap: () => context.push(
                                              AppRoute.requestStart
                                                  .pathForService(
                                                    services[index].id,
                                                  ),
                                            ),
                                          );
                                        },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const SizedBox(
                                              height: OtlobSpacing.md,
                                            ),
                                  ),
                                ),
                              ],
                            );
                          },
                    );
                  },
            ),
          ),
        ),
      ),
    );
  }

  List<T> _valueOrEmpty<T>(IntegrationResult<List<T>>? result) {
    return switch (result) {
      IntegrationSuccess<List<T>>(:final List<T> value) => value,
      _ => <T>[],
    };
  }

  void _showDeferredMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
