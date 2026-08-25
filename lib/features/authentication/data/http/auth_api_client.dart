import '../../../../core/errors/integration_failure.dart';
import '../../../../core/network/platform_api_client.dart';

class AuthApiClient {
  const AuthApiClient({required PlatformApiClient apiClient}) : _apiClient = apiClient;

  final PlatformApiClient _apiClient;

  Future<IntegrationResult<Object?>> bootstrap({
    required String fullName,
    required String locale,
    String primaryRole = 'customer',
  }) {
    return _apiClient.post(
      '/v1/auth/bootstrap',
      body: <String, Object?>{
        'fullName': fullName,
        'locale': locale,
        'primaryRole': primaryRole,
      },
    );
  }

  Future<IntegrationResult<Object?>> getCurrentUser() {
    return _apiClient.get('/v1/auth/me');
  }
}
