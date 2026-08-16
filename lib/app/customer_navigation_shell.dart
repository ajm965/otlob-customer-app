import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/localization/otlob_localizations.dart';
import '../core/theme/otlob_design_system.dart';

class CustomerNavigationShell extends StatelessWidget {
  const CustomerNavigationShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: OtlobNavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _selectDestination,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: localizations.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.design_services_outlined),
              selectedIcon: const Icon(Icons.design_services),
              label: localizations.services,
            ),
            NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long),
              label: localizations.requests,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: localizations.profile,
            ),
          ],
        ),
      ),
    );
  }

  void _selectDestination(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
