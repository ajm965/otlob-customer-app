import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../data/mock/mock_services.dart';
import '../widgets/service_cards.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

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
            child: CustomScrollView(
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: context.otlobColors.mutedText,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(OtlobSpacing.lg),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      return ServiceCategoryCard(
                        category: MockServices.categories[index],
                        isArabic: localizations.isArabic,
                        onTap: () => _showDeferredMessage(
                          context,
                          localizations.serviceDetails,
                        ),
                      );
                    }, childCount: MockServices.categories.length),
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
                    OtlobSpacing.sm,
                    OtlobSpacing.lg,
                    OtlobSpacing.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      localizations.popularServices,
                      style: Theme.of(context).textTheme.titleLarge,
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
                    itemCount: MockServices.popular.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ServiceCard(
                        service: MockServices.popular[index],
                        isArabic: localizations.isArabic,
                        onTap: () => context.push(
                          AppRoute.requestStart.pathForService(
                            MockServices.popular[index].id,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: OtlobSpacing.md),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeferredMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
