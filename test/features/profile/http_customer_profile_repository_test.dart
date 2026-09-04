import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:otlob_customer_app/core/errors/integration_failure.dart';
import 'package:otlob_customer_app/core/network/platform_api_client.dart';
import 'package:otlob_customer_app/features/profile/data/http/http_customer_profile_repository.dart';
import 'package:otlob_customer_app/features/profile/data/mock/mock_profile.dart';
import 'package:otlob_customer_app/features/profile/domain/models/customer_profile.dart';
import 'package:otlob_customer_app/features/profile/domain/repositories/customer_profile_repository.dart';

void main() {
  test('HTTP profile repository satisfies profile boundary', () {
    final CustomerProfileRepository repository = HttpCustomerProfileRepository(
      apiClient: PlatformApiClient(
        client: MockClient(
          (http.Request request) async => http.Response('', 500),
        ),
        baseUrl: 'http://127.0.0.1:8080',
      ),
    );

    expect(repository, isA<CustomerProfileRepository>());
    expect(
      const MockCustomerProfileRepository(),
      isA<CustomerProfileRepository>(),
    );
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

    final IntegrationResult<CustomerProfile> result = await repository
        .getCurrentProfile();

    expect(result, isA<IntegrationSuccess<CustomerProfile>>());
    final CustomerProfile profile =
        (result as IntegrationSuccess<CustomerProfile>).value;
    expect(profile.id, 'user-001');
    expect(profile.fullName, 'Sara Al-Otlob');
    expect(profile.locale, 'ar');
    expect(profile.primaryRole, 'customer');
  });

  test('updateCurrentProfile patches /v1/auth/me with trimmed fullName', () async {
    final HttpCustomerProfileRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.method, 'PATCH');
      expect(request.url.path, '/v1/auth/me');
      final Map<String, Object?> body =
          jsonDecode(request.body) as Map<String, Object?>;
      expect(body, <String, Object?>{'fullName': 'Sara Updated'});
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'id': 'user-001',
            'fullName': 'Sara Updated',
            'locale': 'ar',
            'primaryRole': 'customer',
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerProfile> result = await repository
        .updateCurrentProfile(fullName: '  Sara Updated  ');

    expect(result, isA<IntegrationSuccess<CustomerProfile>>());
    expect(
      (result as IntegrationSuccess<CustomerProfile>).value.fullName,
      'Sara Updated',
    );
  });

  test('updateCurrentProfile normalizes locale before patch', () async {
    final HttpCustomerProfileRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.method, 'PATCH');
      expect(request.url.path, '/v1/auth/me');
      final Map<String, Object?> body =
          jsonDecode(request.body) as Map<String, Object?>;
      expect(body, <String, Object?>{'locale': 'en'});
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'id': 'user-001',
            'fullName': 'Sara Al-Otlob',
            'locale': 'en',
            'primaryRole': 'customer',
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerProfile> result = await repository
        .updateCurrentProfile(locale: ' EN ');

    expect(result, isA<IntegrationSuccess<CustomerProfile>>());
    expect((result as IntegrationSuccess<CustomerProfile>).value.locale, 'en');
  });

  test('updateCurrentProfile rejects empty update body', () async {
    final HttpCustomerProfileRepository repository = _repository((
      http.Request request,
    ) async {
      fail('No HTTP call should be made for an empty update.');
    });

    final IntegrationResult<CustomerProfile> blankName = await repository
        .updateCurrentProfile(fullName: '   ');
    final IntegrationResult<CustomerProfile> unsupportedLocale =
        await repository.updateCurrentProfile(locale: 'fr');
    final IntegrationResult<CustomerProfile> noFields = await repository
        .updateCurrentProfile();

    for (final IntegrationResult<CustomerProfile> result in <
      IntegrationResult<CustomerProfile>
    >[blankName, unsupportedLocale, noFields]) {
      expect(result, isA<IntegrationError<CustomerProfile>>());
      expect(
        (result as IntegrationError<CustomerProfile>).failure.kind,
        IntegrationFailureKind.validation,
      );
    }
  });

  test('maps HTTP 401 to unauthorized', () async {
    final HttpCustomerProfileRepository repository = _repository((
      http.Request request,
    ) async {
      return http.Response(
        jsonEncode(<String, Object?>{
          'error': <String, Object?>{
            'code': 'unauthenticated',
            'message': 'Auth required',
            'details': <String, Object?>{},
            'requestId': 'req_auth',
          },
        }),
        401,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerProfile> result = await repository
        .getCurrentProfile();

    expect(result, isA<IntegrationError<CustomerProfile>>());
    expect(
      (result as IntegrationError<CustomerProfile>).failure.kind,
      IntegrationFailureKind.unauthorized,
    );
  });

  test('maps malformed success body to unknown', () async {
    final HttpCustomerProfileRepository repository = _repository((
      http.Request request,
    ) async {
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'id': 'user-001',
            'fullName': 'Sara',
            'locale': 'fr',
            'primaryRole': 'customer',
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerProfile> result = await repository
        .getCurrentProfile();

    expect(result, isA<IntegrationError<CustomerProfile>>());
    expect(
      (result as IntegrationError<CustomerProfile>).failure.kind,
      IntegrationFailureKind.unknown,
    );
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
