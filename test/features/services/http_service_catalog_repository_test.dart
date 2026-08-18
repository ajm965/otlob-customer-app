import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:otlob_customer_app/core/errors/integration_failure.dart';
import 'package:otlob_customer_app/core/network/platform_api_client.dart';
import 'package:otlob_customer_app/features/services/data/http/http_service_catalog_repository.dart';
import 'package:otlob_customer_app/features/services/data/mock/mock_services.dart';
import 'package:otlob_customer_app/features/services/domain/models/customer_service.dart';
import 'package:otlob_customer_app/features/services/domain/repositories/service_catalog_repository.dart';

void main() {
  test('HTTP catalog repository satisfies the catalog boundary', () {
    final ServiceCatalogRepository repository = HttpServiceCatalogRepository(
      apiClient: PlatformApiClient(
        client: MockClient((http.Request request) async => http.Response('', 500)),
        baseUrl: 'http://127.0.0.1:8080',
      ),
    );

    expect(repository, isA<ServiceCatalogRepository>());
    expect(const MockServiceCatalogRepository(), isA<ServiceCatalogRepository>());
  });

  test('successful category request maps Platform items', () async {
    final HttpServiceCatalogRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.url.path, '/v1/categories');
      expect(request.url.queryParameters['activeOnly'], 'true');
      expect(request.headers.containsKey('Authorization'), isFalse);
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'items': <Object?>[
              <String, Object?>{
                'id': 'plumbing',
                'marketId': 'sa',
                'countryCode': 'SA',
                'nameAr': 'سباكة',
                'nameEn': 'Plumbing',
                'isActive': true,
                'sortOrder': 1,
              },
            ],
            'nextPageToken': null,
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<List<ServiceCategory>> result = await repository
        .listCategories();

    expect(result, isA<IntegrationSuccess<List<ServiceCategory>>>());
    final List<ServiceCategory> categories =
        (result as IntegrationSuccess<List<ServiceCategory>>).value;
    expect(categories, hasLength(1));
    expect(categories.first.id, 'plumbing');
    expect(categories.first.titleEn, 'Plumbing');
    expect(categories.first.visual, isNull);
  });

  test('successful service request maps Platform items', () async {
    final HttpServiceCatalogRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.url.path, '/v1/services');
      expect(request.url.queryParameters['activeOnly'], 'true');
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'items': <Object?>[
              <String, Object?>{
                'id': 'pipe-repair',
                'marketId': 'sa',
                'countryCode': 'SA',
                'categoryId': 'plumbing',
                'nameAr': 'إصلاح أنابيب',
                'nameEn': 'Pipe repair',
                'isActive': true,
              },
            ],
            'nextPageToken': null,
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<List<CustomerService>> result = await repository
        .listServices();

    expect(result, isA<IntegrationSuccess<List<CustomerService>>>());
    final List<CustomerService> services =
        (result as IntegrationSuccess<List<CustomerService>>).value;
    expect(services.single.id, 'pipe-repair');
    expect(services.single.titleEn, 'Pipe repair');
    expect(services.single.categoryId, 'plumbing');
    expect(services.single.description(isArabic: false), isNull);
  });

  test('successful service detail request maps Platform data', () async {
    final HttpServiceCatalogRepository repository = _repository((
      http.Request request,
    ) async {
      expect(request.url.path, '/v1/services/ac-gas-refill');
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'id': 'ac-gas-refill',
            'marketId': 'sa',
            'countryCode': 'SA',
            'categoryId': 'ac',
            'nameAr': 'تعبئة غاز التكييف',
            'nameEn': 'AC Gas Refill',
            'isActive': true,
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerService?> result = await repository
        .getService('ac-gas-refill');

    expect(result, isA<IntegrationSuccess<CustomerService?>>());
    final CustomerService? service =
        (result as IntegrationSuccess<CustomerService?>).value;
    expect(service?.id, 'ac-gas-refill');
    expect(service?.titleEn, 'AC Gas Refill');
    expect(service?.visual, isNull);
  });

  test('maps network failures', () async {
    final HttpServiceCatalogRepository repository = _repository((
      http.Request request,
    ) async {
      throw http.ClientException('Connection failed');
    });

    final IntegrationResult<List<ServiceCategory>> result = await repository
        .listCategories();

    expect(result, isA<IntegrationError<List<ServiceCategory>>>());
    expect(
      (result as IntegrationError<List<ServiceCategory>>).failure.kind,
      IntegrationFailureKind.network,
    );
  });

  test('maps HTTP 401 and 403', () async {
    Future<void> expectKind({
      required int statusCode,
      required String code,
      required IntegrationFailureKind kind,
    }) async {
      final HttpServiceCatalogRepository repository = _repository((
        http.Request request,
      ) async {
        return http.Response(
          jsonEncode(<String, Object?>{
            'error': <String, Object?>{
              'code': code,
              'message': code,
              'details': <String, Object?>{},
              'requestId': 'req_auth',
            },
          }),
          statusCode,
          headers: <String, String>{'content-type': 'application/json'},
        );
      });
      final IntegrationResult<List<ServiceCategory>> result = await repository
          .listCategories();
      expect(
        (result as IntegrationError<List<ServiceCategory>>).failure.kind,
        kind,
      );
    }

    await expectKind(
      statusCode: 401,
      code: 'unauthenticated',
      kind: IntegrationFailureKind.unauthorized,
    );
    await expectKind(
      statusCode: 403,
      code: 'forbidden',
      kind: IntegrationFailureKind.forbidden,
    );
  });

  test('maps HTTP 404 to notFound', () async {
    final HttpServiceCatalogRepository repository = _repository((
      http.Request request,
    ) async {
      return http.Response(
        jsonEncode(<String, Object?>{
          'error': <String, Object?>{
            'code': 'not_found',
            'message': 'The requested path was not found.',
            'details': <String, Object?>{},
            'requestId': 'req_1',
          },
        }),
        404,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<CustomerService?> result = await repository
        .getService('missing-service');

    expect(result, isA<IntegrationError<CustomerService?>>());
    final IntegrationFailure failure =
        (result as IntegrationError<CustomerService?>).failure;
    expect(failure.kind, IntegrationFailureKind.notFound);
    expect(failure.message, 'The requested path was not found.');
  });

  test('maps HTTP 400 to validation', () async {
    final HttpServiceCatalogRepository repository = _repository((
      http.Request request,
    ) async {
      return http.Response(
        jsonEncode(<String, Object?>{
          'error': <String, Object?>{
            'code': 'validation_failed',
            'message': 'Required field missing',
            'details': <String, Object?>{},
            'requestId': 'req_2',
          },
        }),
        400,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<List<CustomerService>> result = await repository
        .listServices();

    expect(result, isA<IntegrationError<List<CustomerService>>>());
    expect(
      (result as IntegrationError<List<CustomerService>>).failure.kind,
      IntegrationFailureKind.validation,
    );
  });

  test('maps HTTP 500 to server', () async {
    final HttpServiceCatalogRepository repository = _repository((
      http.Request request,
    ) async {
      return http.Response(
        jsonEncode(<String, Object?>{
          'error': <String, Object?>{
            'code': 'internal_error',
            'message': 'An unexpected error occurred.',
            'details': <String, Object?>{},
            'requestId': 'req_3',
          },
        }),
        500,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<List<ServiceCategory>> result = await repository
        .listCategories();

    expect(result, isA<IntegrationError<List<ServiceCategory>>>());
    expect(
      (result as IntegrationError<List<ServiceCategory>>).failure.kind,
      IntegrationFailureKind.server,
    );
  });

  test('maps malformed success bodies to unknown', () async {
    final HttpServiceCatalogRepository repository = _repository((
      http.Request request,
    ) async {
      return http.Response(
        '{not-json',
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<List<ServiceCategory>> result = await repository
        .listCategories();

    expect(result, isA<IntegrationError<List<ServiceCategory>>>());
    expect(
      (result as IntegrationError<List<ServiceCategory>>).failure.kind,
      IntegrationFailureKind.unknown,
    );
  });

  test('maps a success envelope with an invalid item to unknown', () async {
    final HttpServiceCatalogRepository repository = _repository((
      http.Request request,
    ) async {
      return http.Response(
        jsonEncode(<String, Object?>{
          'data': <String, Object?>{
            'items': <Object?>[
              <String, Object?>{'id': 'plumbing'},
            ],
            'nextPageToken': null,
          },
        }),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final IntegrationResult<List<ServiceCategory>> result = await repository
        .listCategories();

    expect(result, isA<IntegrationError<List<ServiceCategory>>>());
    expect(
      (result as IntegrationError<List<ServiceCategory>>).failure.kind,
      IntegrationFailureKind.unknown,
    );
  });
}

HttpServiceCatalogRepository _repository(
  Future<http.Response> Function(http.Request request) handler,
) {
  return HttpServiceCatalogRepository(
    apiClient: PlatformApiClient(
      client: MockClient(handler),
      baseUrl: 'http://127.0.0.1:8080',
    ),
  );
}
