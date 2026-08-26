import '../../../../core/errors/integration_failure.dart';
import '../../../../core/network/platform_api_client.dart';
import '../../domain/models/customer_profile.dart';
import '../../domain/repositories/customer_profile_repository.dart';
import 'profile_json.dart';

class HttpCustomerProfileRepository implements CustomerProfileRepository {
  const HttpCustomerProfileRepository({required this.apiClient});

  final PlatformApiClient apiClient;

  @override
  Future<IntegrationResult<CustomerProfile>> getCurrentProfile() async {
    final IntegrationResult<Object?> result = await apiClient.get('/v1/auth/me');
    return switch (result) {
      IntegrationError<Object?>(:final IntegrationFailure failure) =>
        IntegrationError<CustomerProfile>(failure),
      IntegrationSuccess<Object?>(:final Object? value) =>
        _parse(() => parseProfile(value)),
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
