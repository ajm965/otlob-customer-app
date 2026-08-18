import 'package:flutter/material.dart';

import '../../../core/errors/integration_failure.dart';
import '../../../core/localization/otlob_localizations.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../domain/models/customer_profile.dart';
import '../domain/repositories/customer_profile_repository.dart';
import '../widgets/profile_option_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.repository, super.key});

  final CustomerProfileRepository repository;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final Future<IntegrationResult<CustomerProfile>> _profile = widget
      .repository
      .getCurrentProfile();

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return FutureBuilder<IntegrationResult<CustomerProfile>>(
      future: _profile,
      builder:
          (
            BuildContext context,
            AsyncSnapshot<IntegrationResult<CustomerProfile>> snapshot,
          ) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: OtlobLoading(semanticLabel: localizations.appName),
                ),
              );
            }
            final CustomerProfile? profile = switch (snapshot.data) {
              IntegrationSuccess<CustomerProfile>(:final value) => value,
              _ => null,
            };
            if (profile == null) {
              return Scaffold(
                appBar: OtlobAppBar(title: Text(localizations.profile)),
                body: OtlobErrorState(title: localizations.profile),
              );
            }
            return Scaffold(
              appBar: OtlobAppBar(title: Text(localizations.profile)),
              body: SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: OtlobLayoutConstraints.contentMaxWidth,
                    ),
                    child: ListView(
                      key: const Key('profile-list'),
                      padding: const EdgeInsets.all(OtlobSpacing.lg),
                      children: <Widget>[
                        Text(
                          localizations.accountOverview,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: OtlobSpacing.md),
                        OtlobCard(
                          child: Row(
                            children: <Widget>[
                              OtlobAvatar(
                                semanticLabel: localizations.profile,
                                child: const Icon(Icons.person_outline),
                              ),
                              const SizedBox(width: OtlobSpacing.lg),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      profile.displayName(
                                        isArabic: localizations.isArabic,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: OtlobSpacing.xs),
                                    Text(
                                      profile.summary(
                                        isArabic: localizations.isArabic,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                context.otlobColors.mutedText,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: OtlobSpacing.xl),
                        Text(
                          localizations.accountOptions,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: OtlobSpacing.md),
                        ProfileOptionTile(
                          icon: Icons.badge_outlined,
                          label: localizations.personalInformation,
                          onTap: () => _showPlaceholder(context, localizations),
                        ),
                        const SizedBox(height: OtlobSpacing.md),
                        ProfileOptionTile(
                          icon: Icons.language,
                          label: localizations.language,
                          onTap: () => _showPlaceholder(context, localizations),
                        ),
                        const SizedBox(height: OtlobSpacing.md),
                        ProfileOptionTile(
                          icon: Icons.help_outline,
                          label: localizations.helpPlaceholder,
                          onTap: () => _showPlaceholder(context, localizations),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
    );
  }

  void _showPlaceholder(
    BuildContext context,
    OtlobLocalizations localizations,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(localizations.placeholderActionMessage)),
      );
  }
}
