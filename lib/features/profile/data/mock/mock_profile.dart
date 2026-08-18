import '../../../../core/errors/integration_failure.dart';
import '../../domain/models/customer_profile.dart';
import '../../domain/repositories/customer_profile_repository.dart';

typedef MockProfile = CustomerProfile;

abstract final class MockProfileData {
  static const CustomerProfile customer = CustomerProfile(
    displayNameAr: 'عميل أطلب',
    displayNameEn: 'Otlob customer',
    summaryAr: 'ملف شخصي تجريبي للعرض فقط',
    summaryEn: 'Mock profile for presentation only',
  );
}

class MockCustomerProfileRepository implements CustomerProfileRepository {
  const MockCustomerProfileRepository();

  @override
  Future<IntegrationResult<CustomerProfile>> getCurrentProfile() async =>
      const IntegrationSuccess<CustomerProfile>(MockProfileData.customer);
}
