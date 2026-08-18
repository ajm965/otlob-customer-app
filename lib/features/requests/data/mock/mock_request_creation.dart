import '../../domain/models/customer_request.dart';

typedef MockRequestAddress = RequestAddress;
typedef MockRequestSubmission = RequestSubmission;
typedef MockRequestDraft = RequestDraft;

abstract final class MockRequestCreationData {
  static const List<RequestAddress> addresses = <RequestAddress>[
    RequestAddress(
      id: 'mock-home-address',
      labelAr: 'المنزل التجريبي',
      labelEn: 'Mock home',
      line1Ar: 'عنوان تجريبي، حي نموذجي',
      line1En: 'Sample address, example district',
      cityAr: 'الرياض',
      cityEn: 'Riyadh',
      countryCode: 'SA',
      latitude: 24.7,
      longitude: 46.7,
    ),
    RequestAddress(
      id: 'mock-work-address',
      labelAr: 'العمل التجريبي',
      labelEn: 'Mock workplace',
      line1Ar: 'موقع تجريبي ثانٍ، حي نموذجي',
      line1En: 'Second sample location, example district',
      cityAr: 'الرياض',
      cityEn: 'Riyadh',
      countryCode: 'SA',
      latitude: 24.75,
      longitude: 46.65,
    ),
  ];

  static const RequestSubmission submission = RequestSubmission(
    reference: 'MOCK-REQ-0001',
  );
}
