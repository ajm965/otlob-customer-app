import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/core/errors/integration_failure.dart';
import 'package:otlob_customer_app/features/authentication/data/mock/mock_authentication.dart';
import 'package:otlob_customer_app/features/authentication/domain/models/authentication_state.dart';
import 'package:otlob_customer_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:otlob_customer_app/features/profile/data/mock/mock_profile.dart';
import 'package:otlob_customer_app/features/profile/domain/repositories/customer_profile_repository.dart';
import 'package:otlob_customer_app/features/requests/data/mock/mock_requests.dart';
import 'package:otlob_customer_app/features/requests/domain/models/customer_request.dart';
import 'package:otlob_customer_app/features/requests/domain/repositories/customer_request_repository.dart';
import 'package:otlob_customer_app/features/services/data/mock/mock_services.dart';
import 'package:otlob_customer_app/features/services/domain/repositories/service_catalog_repository.dart';

void main() {
  test(
    'mock authentication repository satisfies local authentication boundary',
    () async {
      final AuthenticationRepository repository =
          MockAuthenticationRepository();

      expect(repository.isValidKsaPhone('+966501234567'), isTrue);
      final IntegrationResult<AuthenticationState> started = await repository
          .beginPhoneAuthentication(AuthenticationFlow.signIn, '+966501234567');
      expect(started, isA<IntegrationSuccess<AuthenticationState>>());
    },
  );

  test('mock service repository satisfies catalog boundary', () async {
    final ServiceCatalogRepository repository = MockServiceCatalogRepository();

    final IntegrationResult<dynamic> categories = await repository
        .listCategories();
    final IntegrationResult<dynamic> services = await repository.listServices();
    final IntegrationResult<dynamic> service = await repository.getService(
      'home-cleaning',
    );

    expect(categories, isA<IntegrationSuccess<dynamic>>());
    expect(services, isA<IntegrationSuccess<dynamic>>());
    expect(service, isA<IntegrationSuccess<dynamic>>());
  });

  test(
    'mock request repository satisfies creation, history, and detail boundaries',
    () async {
      final CustomerRequestRepository repository =
          MockCustomerRequestRepository();

      final IntegrationResult<List<CustomerRequest>> history = await repository
          .listRequests();
      final IntegrationResult<CustomerRequest?> detail = await repository
          .getRequest('request-pending');
      final IntegrationResult<List<RequestAddress>> addresses = await repository
          .listSelectableAddresses();
      final RequestAddress address =
          (addresses as IntegrationSuccess<List<RequestAddress>>).value.first;
      final IntegrationResult<RequestSubmission> submission = await repository
          .createRequest(
            RequestDraft(serviceId: 'home-cleaning', address: address),
          );

      expect(history, isA<IntegrationSuccess<List<CustomerRequest>>>());
      expect(detail, isA<IntegrationSuccess<CustomerRequest?>>());
      expect(submission, isA<IntegrationSuccess<RequestSubmission>>());
    },
  );

  test('mock profile repository satisfies profile boundary', () async {
    final CustomerProfileRepository repository =
        MockCustomerProfileRepository();

    final result = await repository.getCurrentProfile();

    expect(result, isA<IntegrationSuccess<dynamic>>());
  });
}
