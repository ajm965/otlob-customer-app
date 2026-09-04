import '../../../../core/errors/integration_failure.dart';
import '../models/customer_profile.dart';

abstract interface class CustomerProfileRepository {
  Future<IntegrationResult<CustomerProfile>> getCurrentProfile();

  Future<IntegrationResult<CustomerProfile>> updateCurrentProfile({
    String? fullName,
    String? locale,
  });
}
