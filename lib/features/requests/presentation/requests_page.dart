import 'package:flutter/material.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../data/mock/mock_requests.dart';
import '../widgets/request_card.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({this.items = MockRequests.all, super.key});

  final List<MockRequest> items;

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return Scaffold(
      appBar: OtlobAppBar(title: Text(localizations.requests)),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: OtlobLayoutConstraints.contentMaxWidth,
            ),
            child: items.isEmpty
                ? OtlobEmptyState(
                    title: localizations.noRequests,
                    message: localizations.noRequestsMessage,
                    icon: Icons.receipt_long_outlined,
                  )
                : ListView.separated(
                    key: const Key('requests-list'),
                    padding: const EdgeInsets.all(OtlobSpacing.lg),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RequestCard(request: items[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: OtlobSpacing.md),
                  ),
          ),
        ),
      ),
    );
  }
}
