import '../../../../core/errors/integration_failure.dart';
import '../../../../core/network/platform_api_client.dart';
import '../../domain/models/customer_address.dart';
import '../../domain/repositories/customer_address_repository.dart';
import 'address_json.dart';

class HttpCustomerAddressRepository implements CustomerAddressRepository {
  const HttpCustomerAddressRepository({required this.apiClient});

  final PlatformApiClient apiClient;

  @override
  Future<IntegrationResult<List<CustomerAddress>>> listAddresses() async {
    final IntegrationResult<Object?> result = await apiClient.get(
      '/v1/addresses',
    );
    return switch (result) {
      IntegrationError<Object?>(:final IntegrationFailure failure) =>
        IntegrationError<List<CustomerAddress>>(failure),
      IntegrationSuccess<Object?>(:final Object? value) =>
        _parse(() => parseAddressItems(value)),
    };
  }

  @override
  Future<IntegrationResult<CustomerAddress?>> getAddress(
    String addressId,
  ) async {
    final String trimmedId = addressId.trim();
    if (trimmedId.isEmpty) {
      return const IntegrationError<CustomerAddress?>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }
    final IntegrationResult<Object?> result = await apiClient.get(
      '/v1/addresses/${Uri.encodeComponent(trimmedId)}',
    );
    return switch (result) {
      IntegrationError<Object?>(:final IntegrationFailure failure) =>
        IntegrationError<CustomerAddress?>(failure),
      IntegrationSuccess<Object?>(:final Object? value) =>
        _parse(() => parseAddress(value)),
    };
  }

  @override
  Future<IntegrationResult<CustomerAddress>> createAddress(
    CustomerAddress draft,
  ) async {
    final IntegrationResult<Object?> result = await apiClient.post(
      '/v1/addresses',
      body: buildCreateAddressBody(draft),
    );
    return switch (result) {
      IntegrationError<Object?>(:final IntegrationFailure failure) =>
        IntegrationError<CustomerAddress>(failure),
      IntegrationSuccess<Object?>(:final Object? value) =>
        _parse(() => parseAddress(value)),
    };
  }

  @override
  Future<IntegrationResult<CustomerAddress>> updateAddress(
    CustomerAddress address,
  ) async {
    final IntegrationResult<Object?> result = await apiClient.patch(
      '/v1/addresses/${Uri.encodeComponent(address.id)}',
      body: buildUpdateAddressBody(address),
    );
    return switch (result) {
      IntegrationError<Object?>(:final IntegrationFailure failure) =>
        IntegrationError<CustomerAddress>(failure),
      IntegrationSuccess<Object?>(:final Object? value) =>
        _parse(() => parseAddress(value)),
    };
  }

  @override
  Future<IntegrationResult<void>> deleteAddress(String addressId) async {
    final String trimmedId = addressId.trim();
    if (trimmedId.isEmpty) {
      return const IntegrationError<void>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }
    final IntegrationResult<Object?> result = await apiClient.delete(
      '/v1/addresses/${Uri.encodeComponent(trimmedId)}',
    );
    return switch (result) {
      IntegrationError<Object?>(:final IntegrationFailure failure) =>
        IntegrationError<void>(failure),
      IntegrationSuccess<Object?>() => const IntegrationSuccess<void>(null),
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
