import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/features/addresses/data/http/address_json.dart';
import 'package:otlob_customer_app/features/addresses/domain/models/customer_address.dart';

void main() {
  test('parseAddress maps Platform address response', () {
    final CustomerAddress address = parseAddress(<String, Object?>{
      'id': 'addr-001',
      'label': 'المنزل',
      'line1': 'شارع الملك فهد',
      'line2': null,
      'city': 'الرياض',
      'region': 'Riyadh',
      'postalCode': '12345',
      'countryCode': 'SA',
      'location': <String, Object?>{'latitude': 24.7136, 'longitude': 46.6753},
      'isDefault': true,
    });

    expect(address.id, 'addr-001');
    expect(address.label, 'المنزل');
    expect(address.line1, 'شارع الملك فهد');
    expect(address.city, 'الرياض');
    expect(address.region, 'Riyadh');
    expect(address.postalCode, '12345');
    expect(address.countryCode, 'SA');
    expect(address.latitude, 24.7136);
    expect(address.longitude, 46.6753);
    expect(address.isDefault, isTrue);
  });

  test('parseAddressItems maps list envelope', () {
    final List<CustomerAddress> addresses = parseAddressItems(
      <String, Object?>{
        'items': <Object?>[
          <String, Object?>{
            'id': 'addr-001',
            'label': 'Home',
            'line1': 'Street 1',
            'city': 'Riyadh',
            'countryCode': 'SA',
            'location': <String, Object?>{
              'latitude': 24.7,
              'longitude': 46.7,
            },
            'isDefault': false,
          },
        ],
        'nextPageToken': null,
      },
    );

    expect(addresses, hasLength(1));
    expect(addresses.single.id, 'addr-001');
  });

  test('buildCreateAddressBody sends supported fields only', () {
    final Map<String, Object?> body = buildCreateAddressBody(
      const CustomerAddress(
        id: 'draft',
        label: 'Work',
        line1: 'Office tower',
        city: 'Riyadh',
        countryCode: 'SA',
        latitude: 24.75,
        longitude: 46.65,
        isDefault: true,
      ),
    );

    expect(body, <String, Object?>{
      'label': 'Work',
      'line1': 'Office tower',
      'city': 'Riyadh',
      'countryCode': 'SA',
      'isDefault': true,
      'location': <String, Object?>{'latitude': 24.75, 'longitude': 46.65},
    });
    expect(body.containsKey('id'), isFalse);
  });

  test('buildUpdateAddressBody matches create shape', () {
    final Map<String, Object?> body = buildUpdateAddressBody(
      const CustomerAddress(
        id: 'addr-002',
        label: 'Work',
        line1: 'Updated street',
        city: 'Riyadh',
        countryCode: 'SA',
      ),
    );

    expect(body['label'], 'Work');
    expect(body['line1'], 'Updated street');
    expect(body.containsKey('location'), isFalse);
  });
}
