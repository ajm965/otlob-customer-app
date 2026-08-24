import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/features/addresses/data/mock/mock_addresses.dart';
import 'package:otlob_customer_app/features/addresses/domain/models/customer_address.dart';
import 'package:otlob_customer_app/features/requests/data/http/request_json.dart';
import 'package:otlob_customer_app/features/requests/domain/models/customer_request.dart';

void main() {
  test('parseRequest maps Platform request response', () {
    final CustomerRequest request = parseRequest(<String, Object?>{
      'id': 'req-004',
      'marketId': 'sa',
      'countryCode': 'SA',
      'customerId': 'offline-customer',
      'serviceId': 'pipe-repair',
      'status': 'draft',
      'description': 'Kitchen leak',
      'location': null,
      'preferredTimeStart': null,
      'preferredTimeEnd': null,
      'acceptedOfferId': null,
      'bookingId': null,
    });

    expect(request.id, 'req-004');
    expect(request.serviceId, 'pipe-repair');
    expect(request.reference, 'req-004');
    expect(request.serviceTitleEn, 'Pipe Repair');
    expect(request.serviceTitleAr, 'pipe-repair');
    expect(request.descriptionEn, 'Kitchen leak');
    expect(request.locationEn, 'Not specified');
    expect(request.status, CustomerRequestStatus.pending);
  });

  test('mapPlatformStatus maps backend statuses to customer statuses', () {
    expect(mapPlatformStatus('draft'), CustomerRequestStatus.pending);
    expect(mapPlatformStatus('open'), CustomerRequestStatus.pending);
    expect(mapPlatformStatus('matched'), CustomerRequestStatus.inProgress);
    expect(mapPlatformStatus('booked'), CustomerRequestStatus.inProgress);
    expect(mapPlatformStatus('cancelled'), CustomerRequestStatus.cancelled);
    expect(mapPlatformStatus('expired'), CustomerRequestStatus.cancelled);
  });

  test('buildCreateRequestBody sends only supported fields', () {
    final Map<String, Object?> body = buildCreateRequestBody(
      const RequestDraft(
        serviceId: 'plumbing',
        description: 'اختبار طلب سباكة',
      ),
    );

    expect(body, <String, Object?>{
      'serviceId': 'plumbing',
      'description': 'اختبار طلب سباكة',
    });
    expect(body.containsKey('addressId'), isFalse);
    expect(body.containsKey('location'), isFalse);
  });

  test('buildCreateRequestBody sends addressId when address has id', () {
    final Map<String, Object?> body = buildCreateRequestBody(
      RequestDraft(
        serviceId: 'plumbing',
        description: 'اختبار طلب سباكة',
        address: MockAddresses.all.first,
      ),
    );

    expect(body['serviceId'], 'plumbing');
    expect(body['description'], 'اختبار طلب سباكة');
    expect(body['addressId'], 'mock-home-address');
    expect(body.containsKey('location'), isFalse);
  });

  test('buildCreateRequestBody omits location when addressId is present', () {
    final Map<String, Object?> body = buildCreateRequestBody(
      const RequestDraft(
        serviceId: 'plumbing',
        description: 'With saved address',
        address: CustomerAddress(
          id: 'addr-001',
          label: 'Home',
          line1: 'Street',
          city: 'Riyadh',
          countryCode: 'SA',
          latitude: 24.7136,
          longitude: 46.6753,
        ),
      ),
    );

    expect(body['addressId'], 'addr-001');
    expect(body.containsKey('location'), isFalse);
    expect(body.keys.where((String key) => key == 'addressId' || key == 'location'), [
      'addressId',
    ]);
  });

  test('buildCreateRequestBody falls back to location when id is empty', () {
    final Map<String, Object?> body = buildCreateRequestBody(
      const RequestDraft(
        serviceId: 'plumbing',
        description: 'Coords only',
        address: CustomerAddress(
          id: '  ',
          label: 'Pin',
          line1: 'Street',
          city: 'Riyadh',
          countryCode: 'SA',
          latitude: 24.7,
          longitude: 46.7,
        ),
      ),
    );

    expect(body.containsKey('addressId'), isFalse);
    expect(
      body['location'],
      <String, Object?>{'latitude': 24.7, 'longitude': 46.7},
    );
  });

  test('buildCreateRequestBody never sends addressId and location together', () {
    final List<RequestDraft> drafts = <RequestDraft>[
      RequestDraft(
        serviceId: 'plumbing',
        description: 'Saved',
        address: MockAddresses.all.first,
      ),
      const RequestDraft(
        serviceId: 'plumbing',
        description: 'Fallback',
        address: CustomerAddress(
          id: '',
          label: 'Pin',
          line1: 'Street',
          city: 'Riyadh',
          countryCode: 'SA',
          latitude: 24.7,
          longitude: 46.7,
        ),
      ),
      const RequestDraft(
        serviceId: 'plumbing',
        description: 'No address',
      ),
    ];

    for (final RequestDraft draft in drafts) {
      final Map<String, Object?> body = buildCreateRequestBody(draft);
      final bool hasAddressId = body.containsKey('addressId');
      final bool hasLocation = body.containsKey('location');
      expect(
        hasAddressId && hasLocation,
        isFalse,
        reason: 'body must not contain both addressId and location: $body',
      );
    }
  });

  test('parseRequestItems maps list envelope', () {
    final List<CustomerRequest> requests = parseRequestItems(<String, Object?>{
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
    });

    expect(requests, hasLength(1));
    expect(requests.single.id, 'req-001');
    expect(requests.single.status, CustomerRequestStatus.pending);
  });
}
