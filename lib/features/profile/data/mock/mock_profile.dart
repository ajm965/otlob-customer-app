import '../../../../core/errors/integration_failure.dart';
import '../../domain/models/customer_profile.dart';
import '../../domain/repositories/customer_profile_repository.dart';

typedef MockProfile = CustomerProfile;

abstract final class MockProfileData {
  static const CustomerProfile customer = CustomerProfile(
    id: 'mock-customer',
    fullName: 'Otlob customer',
    locale: 'ar',
    primaryRole: 'customer',
  );
}

class MockCustomerProfileRepository implements CustomerProfileRepository {
  const MockCustomerProfileRepository();

  @override
  Future<IntegrationResult<CustomerProfile>> getCurrentProfile() async =>
      const IntegrationSuccess<CustomerProfile>(MockProfileData.customer);

  @override
  Future<IntegrationResult<CustomerProfile>> updateCurrentProfile({
    String? fullName,
    String? locale,
  }) async {
    final String? trimmedName = fullName?.trim();
    final String? normalizedLocale = locale?.trim().toLowerCase();

    String? nextFullName;
    if (trimmedName != null && trimmedName.isNotEmpty) {
      nextFullName = trimmedName;
    }

    String? nextLocale;
    if (normalizedLocale == 'ar' || normalizedLocale == 'en') {
      nextLocale = normalizedLocale;
    }

    if (nextFullName == null && nextLocale == null) {
      return const IntegrationError<CustomerProfile>(
        IntegrationFailure(
          IntegrationFailureKind.validation,
          message: 'At least one profile field must be provided.',
        ),
      );
    }

    return IntegrationSuccess<CustomerProfile>(
      CustomerProfile(
        id: MockProfileData.customer.id,
        fullName: nextFullName ?? MockProfileData.customer.fullName,
        locale: nextLocale ?? MockProfileData.customer.locale,
        primaryRole: MockProfileData.customer.primaryRole,
      ),
    );
  }
}
