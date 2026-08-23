import '../../../../core/errors/integration_failure.dart';
import '../models/customer_address.dart';

abstract interface class CustomerAddressRepository {
  Future<IntegrationResult<List<CustomerAddress>>> listAddresses();

  Future<IntegrationResult<CustomerAddress?>> getAddress(String addressId);

  Future<IntegrationResult<CustomerAddress>> createAddress(
    CustomerAddress draft,
  );

  Future<IntegrationResult<CustomerAddress>> updateAddress(
    CustomerAddress address,
  );

  Future<IntegrationResult<void>> deleteAddress(String addressId);
}
