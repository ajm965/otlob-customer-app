import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:otlob_customer_app/core/errors/integration_failure.dart';
import 'package:otlob_customer_app/core/network/platform_api_client.dart';
import 'package:otlob_customer_app/features/addresses/data/http/http_customer_address_repository.dart';
import 'package:otlob_customer_app/features/addresses/data/mock/mock_addresses.dart';
import 'package:otlob_customer_app/features/addresses/domain/models/customer_address.dart';
import 'package:otlob_customer_app/features/addresses/domain/repositories/customer_address_repository.dart';

void main() {
  test('HTTP address repository satisfies address boundary', () {
    final CustomerAddressRepository repository = HttpCustomerAddressRepository(
      apiClient: PlatformApiClient(
        client: MockClient((http.Request request) async => http.Response('', 500)),
        baseUrl: 'http://127.0.0.1:8080',
      ),
    );

    expect(repository, isA<CustomerAddressRepository>());
    expect(const MockCustomerAddressRepository(), isA<CustomerAddressRepository>());
  });

  test('listAddresses loads saved addresses', () async {
    final HttpCustomerAddressRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/v1/addresses');
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'items': <Object?>[
              <String, Object?>{
                'id': 'addr-001',
                'label': 'المنزل',
                'line1': 'شارع الملك فهد',
                'city': 'الرياض',
                'countryCode': 'SA',
                'location': <String, Object?>{
                  'latitude': 24.7136,
                  'longitude': 46.6753,
                },
                'isDefault': true,
              },
            ],
            'nextPageToken': null,
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<List<CustomerAddress>> result = await repository
        .listAddresses();

    expect(result, isA<IntegrationSuccess<List<CustomerAddress>>>());
    final List<CustomerAddress> addresses =
        (result as IntegrationSuccess<List<CustomerAddress>>).value;
    expect(addresses, hasLength(1));
    expect(addresses.single.id, 'addr-001');
  });

  test('getAddress loads address by id', () async {
    final HttpCustomerAddressRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/v1/addresses/addr-001');
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'id': 'addr-001',
            'label': 'المنزل',
            'line1': 'شارع الملك فهد',
            'city': 'الرياض',
            'countryCode': 'SA',
            'location': <String, Object?>{
              'latitude': 24.7136,
              'longitude': 46.6753,
            },
            'isDefault': true,
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerAddress?> result = await repository
        .getAddress('addr-001');

    expect(result, isA<IntegrationSuccess<CustomerAddress?>>());
    expect(
      (result as IntegrationSuccess<CustomerAddress?>).value?.id,
      'addr-001',
    );
  });

  test('createAddress posts address body', () async {
    final HttpCustomerAddressRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/v1/addresses');
      final Map<String, Object?> body =
          jsonDecode(request.body) as Map<String, Object?>;
      expect(body['label'], 'New home');
      expect(body['line1'], 'Street 9');
      expect(body.containsKey('id'), isFalse);
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'id': 'addr-010',
            'label': 'New home',
            'line1': 'Street 9',
            'city': 'Riyadh',
            'countryCode': 'SA',
            'location': <String, Object?>{'latitude': 24.7, 'longitude': 46.7},
            'isDefault': false,
          },
        }),
        201,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerAddress> result = await repository
        .createAddress(
          const CustomerAddress(
            id: 'draft',
            label: 'New home',
            line1: 'Street 9',
            city: 'Riyadh',
            countryCode: 'SA',
            latitude: 24.7,
            longitude: 46.7,
          ),
        );

    expect(result, isA<IntegrationSuccess<CustomerAddress>>());
    expect((result as IntegrationSuccess<CustomerAddress>).value.id, 'addr-010');
  });

  test('updateAddress patches address body', () async {
    final HttpCustomerAddressRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.method, 'PATCH');
      expect(request.url.path, '/v1/addresses/addr-002');
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'id': 'addr-002',
            'label': 'Updated work',
            'line1': 'New tower',
            'city': 'Riyadh',
            'countryCode': 'SA',
            'isDefault': false,
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerAddress> result = await repository
        .updateAddress(
          const CustomerAddress(
            id: 'addr-002',
            label: 'Updated work',
            line1: 'New tower',
            city: 'Riyadh',
            countryCode: 'SA',
          ),
        );

    expect(result, isA<IntegrationSuccess<CustomerAddress>>());
    expect(
      (result as IntegrationSuccess<CustomerAddress>).value.label,
      'Updated work',
    );
  });

  test('deleteAddress sends DELETE request', () async {
    final HttpCustomerAddressRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.method, 'DELETE');
      expect(request.url.path, '/v1/addresses/addr-002');
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{'id': 'addr-002', 'status': 'archived'},
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<void> result = await repository.deleteAddress(
      'addr-002',
    );

    expect(result, isA<IntegrationSuccess<void>>());
  });

  test('maps HTTP 404 to notFound', () async {
    final HttpCustomerAddressRepository repository = _repository((
      http.Request request,
    ) async {
      return http.Response(
        jsonEncode(<String, Object?>{
          'error': <String, Object?>{
            'code': 'not_found',
            'message': 'Address not found.',
            'details': <String, Object?>{},
            'requestId': 'req_1',
          },
        }),
        404,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerAddress?> result = await repository
        .getAddress('missing-address');

    expect(result, isA<IntegrationError<CustomerAddress?>>());
    expect(
      (result as IntegrationError<CustomerAddress?>).failure.kind,
      IntegrationFailureKind.notFound,
    );
  });
}

HttpCustomerAddressRepository _repository(
  Future<http.Response> Function(http.Request request) handler,
) {
  return HttpCustomerAddressRepository(
    apiClient: PlatformApiClient(
      client: MockClient(handler),
      baseUrl: 'http://127.0.0.1:8080',
    ),
  );
}
