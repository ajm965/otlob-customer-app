import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../data/mock/mock_requests.dart';
import '../widgets/request_card.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({this.items = MockRequests.all, super.key});

  final List<MockRequest> items;

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  _RequestFilter _filter = _RequestFilter.all;

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final List<MockRequest> visibleItems = _filteredItems;
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
            child: widget.items.isEmpty
                ? OtlobEmptyState(
                    title: localizations.noRequests,
                    message: localizations.noRequestsMessage,
                    icon: Icons.receipt_long_outlined,
                  )
                : Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        key: const Key('request-filters'),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          OtlobSpacing.lg,
                          OtlobSpacing.md,
                          OtlobSpacing.lg,
                          OtlobSpacing.sm,
                        ),
                        child: Row(
                          children: <Widget>[
                            for (final _RequestFilter filter
                                in _RequestFilter.values) ...<Widget>[
                              ChoiceChip(
                                key: ValueKey<String>(
                                  'request-filter-${filter.name}',
                                ),
                                label: Text(
                                  _filterLabel(filter, localizations),
                                ),
                                selected: _filter == filter,
                                onSelected: (bool selected) {
                                  if (selected) {
                                    setState(() => _filter = filter);
                                  }
                                },
                              ),
                              if (filter != _RequestFilter.values.last)
                                const SizedBox(width: OtlobSpacing.sm),
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        child: visibleItems.isEmpty
                            ? OtlobEmptyState(
                                title: localizations.noRequests,
                                message: localizations.noRequestsMessage,
                                icon: Icons.receipt_long_outlined,
                              )
                            : ListView.separated(
                                key: const Key('requests-list'),
                                padding: const EdgeInsets.all(OtlobSpacing.lg),
                                itemCount: visibleItems.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final MockRequest request =
                                      visibleItems[index];
                                  return RequestCard(
                                    request: request,
                                    onTap: () => context.push(
                                      AppRoute.requestDetail.pathForRequest(
                                        request.id,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
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

  List<MockRequest> get _filteredItems {
    if (_filter == _RequestFilter.all) {
      return widget.items;
    }
    return widget.items
        .where((MockRequest request) => request.status == _filter.status)
        .toList(growable: false);
  }

  String _filterLabel(_RequestFilter filter, OtlobLocalizations localizations) {
    return switch (filter) {
      _RequestFilter.all => localizations.all,
      _RequestFilter.pending => localizations.pending,
      _RequestFilter.inProgress => localizations.inProgress,
      _RequestFilter.completed => localizations.completed,
      _RequestFilter.cancelled => localizations.cancelled,
    };
  }
}

enum _RequestFilter {
  all(null),
  pending(MockRequestStatus.pending),
  inProgress(MockRequestStatus.inProgress),
  completed(MockRequestStatus.completed),
  cancelled(MockRequestStatus.cancelled);

  const _RequestFilter(this.status);

  final MockRequestStatus? status;
}
