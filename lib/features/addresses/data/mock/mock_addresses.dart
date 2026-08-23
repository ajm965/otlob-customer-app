import '../../../../core/errors/integration_failure.dart';
import '../../domain/models/customer_address.dart';
import '../../domain/repositories/customer_address_repository.dart';

class MockCustomerAddressRepository implements CustomerAddressRepository {
  const MockCustomerAddressRepository();

  @override
  Future<IntegrationResult<List<CustomerAddress>>> listAddresses() async =>
      const IntegrationSuccess<List<CustomerAddress>>(MockAddresses.all);

  @override
  Future<IntegrationResult<CustomerAddress?>> getAddress(
    String addressId,
  ) async => IntegrationSuccess<CustomerAddress?>(MockAddresses.byId(addressId));

  @override
  Future<IntegrationResult<CustomerAddress>> createAddress(
    CustomerAddress draft,
  ) async {
    return IntegrationSuccess<CustomerAddress>(draft);
  }

  @override
  Future<IntegrationResult<CustomerAddress>> updateAddress(
    CustomerAddress address,
  ) async {
    return IntegrationSuccess<CustomerAddress>(address);
  }

  @override
  Future<IntegrationResult<void>> deleteAddress(String addressId) async {
    return const IntegrationSuccess<void>(null);
  }
}

abstract final class MockAddresses {
  static const List<CustomerAddress> all = <CustomerAddress>[
    CustomerAddress(
      id: 'mock-home-address',
      label: 'Mock home',
      line1: 'Sample address, example district',
      city: 'Riyadh',
      countryCode: 'SA',
      latitude: 24.7,
      longitude: 46.7,
    ),
    CustomerAddress(
      id: 'mock-work-address',
      label: 'Mock workplace',
      line1: 'Second sample location, example district',
      city: 'Riyadh',
      countryCode: 'SA',
      latitude: 24.75,
      longitude: 46.65,
    ),
  ];

  static CustomerAddress? byId(String id) {
    for (final CustomerAddress address in all) {
      if (address.id == id) {
        return address;
      }
    }
    return null;
  }
}
