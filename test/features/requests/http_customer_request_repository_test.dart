import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:otlob_customer_app/features/addresses/data/mock/mock_addresses.dart';
import 'package:otlob_customer_app/core/errors/integration_failure.dart';
import 'package:otlob_customer_app/core/network/platform_api_client.dart';
import 'package:otlob_customer_app/features/requests/data/http/http_customer_request_repository.dart';
import 'package:otlob_customer_app/features/requests/data/mock/mock_requests.dart';
import 'package:otlob_customer_app/features/requests/domain/models/customer_request.dart';
import 'package:otlob_customer_app/features/requests/domain/repositories/customer_request_repository.dart';

void main() {
  test('HTTP request repository satisfies request boundary', () {
    final CustomerRequestRepository repository = HttpCustomerRequestRepository(
      apiClient: PlatformApiClient(
        client: MockClient((http.Request request) async => http.Response('', 500)),
        baseUrl: 'http://127.0.0.1:8080',
      ),
    );

    expect(repository, isA<CustomerRequestRepository>());
    expect(const MockCustomerRequestRepository(), isA<CustomerRequestRepository>());
  });

  test('createRequest posts supported fields only', () async {
    final HttpCustomerRequestRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/v1/requests');
      expect(request.headers['content-type'], 'application/json');
      expect(request.headers.containsKey('Authorization'), isFalse);
      final Map<String, Object?> body =
          jsonDecode(request.body) as Map<String, Object?>;
      expect(body, <String, Object?>{
        'serviceId': 'plumbing',
        'description': 'اختبار طلب سباكة',
      });
      expect(body.containsKey('addressId'), isFalse);
      expect(body.containsKey('location'), isFalse);
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'id': 'req-004',
            'marketId': 'sa',
            'countryCode': 'SA',
            'customerId': 'offline-customer',
            'serviceId': 'plumbing',
            'status': 'draft',
            'description': 'اختبار طلب سباكة',
            'location': null,
            'preferredTimeStart': null,
            'preferredTimeEnd': null,
            'acceptedOfferId': null,
            'bookingId': null,
          },
        }),
        201,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<RequestSubmission> result = await repository
        .createRequest(
          const RequestDraft(
            serviceId: 'plumbing',
            description: 'اختبار طلب سباكة',
          ),
        );

    expect(result, isA<IntegrationSuccess<RequestSubmission>>());
    expect(
      (result as IntegrationSuccess<RequestSubmission>).value.reference,
      'req-004',
    );
  });

  test('createRequest includes addressId when draft has saved address', () async {
    final HttpCustomerRequestRepository repository = _repository((
      http.Request request,
    ) async {
      final Map<String, Object?> body =
          jsonDecode(request.body) as Map<String, Object?>;
      expect(body['addressId'], 'mock-home-address');
      expect(body.containsKey('location'), isFalse);
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'id': 'req-005',
            'marketId': 'sa',
            'countryCode': 'SA',
            'customerId': 'offline-customer',
            'serviceId': 'plumbing',
            'status': 'draft',
            'description': 'With saved address',
            'location': <String, Object?>{'latitude': 24.7, 'longitude': 46.7},
            'preferredTimeStart': null,
            'preferredTimeEnd': null,
            'acceptedOfferId': null,
            'bookingId': null,
          },
        }),
        201,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<RequestSubmission> result = await repository
        .createRequest(
          RequestDraft(
            serviceId: 'plumbing',
            description: 'With saved address',
            address: MockAddresses.all.first,
          ),
        );

    expect(result, isA<IntegrationSuccess<RequestSubmission>>());
    expect(
      (result as IntegrationSuccess<RequestSubmission>).value.reference,
      'req-005',
    );
  });

  test('getRequest loads request by id', () async {
    final HttpCustomerRequestRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/v1/requests/req-004');
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'id': 'req-004',
            'marketId': 'sa',
            'countryCode': 'SA',
            'customerId': 'offline-customer',
            'serviceId': 'plumbing',
            'status': 'draft',
            'description': 'اختبار طلب سباكة',
            'location': null,
            'preferredTimeStart': null,
            'preferredTimeEnd': null,
            'acceptedOfferId': null,
            'bookingId': null,
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerRequest?> result = await repository
        .getRequest('req-004');

    expect(result, isA<IntegrationSuccess<CustomerRequest?>>());
    final CustomerRequest? request =
        (result as IntegrationSuccess<CustomerRequest?>).value;
    expect(request?.id, 'req-004');
    expect(request?.reference, 'req-004');
    expect(request?.status, CustomerRequestStatus.pending);
  });

  test('listRequests loads customer requests', () async {
    final HttpCustomerRequestRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/v1/requests');
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'items': <Object?>[
              <String, Object?>{
                'id': 'req-001',
                'marketId': 'sa',
                'countryCode': 'SA',
                'customerId': 'offline-customer',
                'serviceId': 'plumbing',
                'status': 'open',
                'description': 'Open request',
                'location': null,
                'preferredTimeStart': null,
                'preferredTimeEnd': null,
                'acceptedOfferId': null,
                'bookingId': null,
              },
            ],
            'nextPageToken': null,
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<List<CustomerRequest>> result = await repository
        .listRequests();

    expect(result, isA<IntegrationSuccess<List<CustomerRequest>>>());
    final List<CustomerRequest> requests =
        (result as IntegrationSuccess<List<CustomerRequest>>).value;
    expect(requests, hasLength(1));
    expect(requests.single.id, 'req-001');
  });

  test('maps HTTP 404 to notFound', () async {
    final HttpCustomerRequestRepository repository = _repository((
      http.Request request,
    ) async {
      return http.Response(
        jsonEncode(<String, Object?>{
          'error': <String, Object?>{
            'code': 'not_found',
            'message': 'Request not found.',
            'details': <String, Object?>{},
            'requestId': 'req_1',
          },
        }),
        404,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerRequest?> result = await repository
        .getRequest('missing-request');

    expect(result, isA<IntegrationError<CustomerRequest?>>());
    expect(
      (result as IntegrationError<CustomerRequest?>).failure.kind,
      IntegrationFailureKind.notFound,
    );
  });
}

HttpCustomerRequestRepository _repository(
  Future<http.Response> Function(http.Request request) handler,
) {
  return HttpCustomerRequestRepository(
    apiClient: PlatformApiClient(
      client: MockClient(handler),
      baseUrl: 'http://127.0.0.1:8080',
    ),
  );
}
