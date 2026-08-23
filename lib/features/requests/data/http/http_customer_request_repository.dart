import '../../../../core/errors/integration_failure.dart';
import '../../../../core/network/platform_api_client.dart';
import '../../domain/models/customer_request.dart';
import '../../domain/repositories/customer_request_repository.dart';
import 'request_json.dart';

class HttpCustomerRequestRepository implements CustomerRequestRepository {
  const HttpCustomerRequestRepository({required this.apiClient});

  final PlatformApiClient apiClient;

  @override
  Future<IntegrationResult<List<CustomerRequest>>> listRequests() async {
    final IntegrationResult<Object?> result = await apiClient.get(
      '/v1/requests',
    );
    return switch (result) {
      IntegrationError<Object?>(:final IntegrationFailure failure) =>
        IntegrationError<List<CustomerRequest>>(failure),
      IntegrationSuccess<Object?>(:final Object? value) =>
        _parse(() => parseRequestItems(value)),
    };
  }

  @override
  Future<IntegrationResult<CustomerRequest?>> getRequest(
    String requestId,
  ) async {
    final String trimmedId = requestId.trim();
    if (trimmedId.isEmpty) {
      return const IntegrationError<CustomerRequest?>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }

    final IntegrationResult<Object?> result = await apiClient.get(
      '/v1/requests/${Uri.encodeComponent(trimmedId)}',
    );
    return switch (result) {
      IntegrationError<Object?>(:final IntegrationFailure failure) =>
        IntegrationError<CustomerRequest?>(failure),
      IntegrationSuccess<Object?>(:final Object? value) =>
        _parse(() => parseRequest(value)),
    };
  }

  @override
  Future<IntegrationResult<RequestSubmission>> createRequest(
    RequestDraft draft,
  ) async {
    if (draft.serviceId.trim().isEmpty) {
      return const IntegrationError<RequestSubmission>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }

    final IntegrationResult<Object?> result = await apiClient.post(
      '/v1/requests',
      body: buildCreateRequestBody(draft),
    );
    return switch (result) {
      IntegrationError<Object?>(:final IntegrationFailure failure) =>
        IntegrationError<RequestSubmission>(failure),
      IntegrationSuccess<Object?>(:final Object? value) =>
        _parse(() => parseRequestSubmission(value)),
    };
  }

  IntegrationResult<T> _parse<T>(T Function() parse) {
    try {
      return IntegrationSuccess<T>(parse());
    } on FormatException catch (error) {
      return IntegrationError<T>(
        IntegrationFailure(IntegrationFailureKind.unknown, message: error.message),
      );
    }
  }
}
