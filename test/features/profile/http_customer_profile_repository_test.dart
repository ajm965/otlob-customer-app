import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:otlob_customer_app/core/errors/integration_failure.dart';
import 'package:otlob_customer_app/core/network/platform_api_client.dart';
import 'package:otlob_customer_app/features/profile/data/http/http_customer_profile_repository.dart';
import 'package:otlob_customer_app/features/profile/domain/models/customer_profile.dart';
import 'package:otlob_customer_app/features/profile/domain/repositories/customer_profile_repository.dart';

void main() {
  test('HTTP profile repository satisfies profile boundary', () {
    final CustomerProfileRepository repository = HttpCustomerProfileRepository(
      apiClient: PlatformApiClient(
        client: MockClient((http.Request request) async => http.Response('', 500)),
        baseUrl: 'http://127.0.0.1:8080',
      ),
    );

    expect(repository, isA<CustomerProfileRepository>());
  });

  test('getCurrentProfile loads /v1/auth/me', () async {
    final HttpCustomerProfileRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/v1/auth/me');
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'id': 'user-001',
            'fullName': 'Sara Al-Otlob',
            'locale': 'ar',
            'primaryRole': 'customer',
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerProfile> result =
        await repository.getCurrentProfile();

    expect(result, isA<IntegrationSuccess<CustomerProfile>>());
    final CustomerProfile profile =
        (result as IntegrationSuccess<CustomerProfile>).value;
    expect(profile.displayNameAr, 'Sara Al-Otlob');
    expect(profile.summaryEn, 'Customer');
  });
}

HttpCustomerProfileRepository _repository(
  Future<http.Response> Function(http.Request request) handler,
) {
  return HttpCustomerProfileRepository(
    apiClient: PlatformApiClient(
      client: MockClient(handler),
      baseUrl: 'http://127.0.0.1:8080',
    ),
  );
}
