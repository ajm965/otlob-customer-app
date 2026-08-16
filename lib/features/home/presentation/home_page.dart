import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../data/mock/mock_home_data.dart';
import '../widgets/home_cards.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            child: CustomScrollView(
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
                        style: Theme.of(context).textTheme.headlineSmall,
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
                    child: _SectionHeader(title: localizations.categories),
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
                        category: MockHomeData.categories[index],
                        isArabic: localizations.isArabic,
                        onTap: () => context.go(AppRoute.services.path),
                      );
                    }, childCount: MockHomeData.categories.length),
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
                      onAction: () => context.go(AppRoute.services.path),
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
                        service: MockHomeData.recommended[index],
                        isArabic: localizations.isArabic,
                        onTap: () => context.go(AppRoute.services.path),
                      );
                    }, childCount: MockHomeData.recommended.length),
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
                      onAction: () => context.go(AppRoute.requests.path),
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
                    itemCount: MockHomeData.recentRequests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return HomeRecentRequestCard(
                        request: MockHomeData.recentRequests[index],
                        isArabic: localizations.isArabic,
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
