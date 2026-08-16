class MockRequestAddress {
  const MockRequestAddress({
    required this.id,
    required this.labelAr,
    required this.labelEn,
    required this.line1Ar,
    required this.line1En,
    required this.cityAr,
    required this.cityEn,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String labelAr;
  final String labelEn;
  final String line1Ar;
  final String line1En;
  final String cityAr;
  final String cityEn;
  final String countryCode;
  final double latitude;
  final double longitude;

  String label({required bool isArabic}) => isArabic ? labelAr : labelEn;
  String line1({required bool isArabic}) => isArabic ? line1Ar : line1En;
  String city({required bool isArabic}) => isArabic ? cityAr : cityEn;
}

class MockRequestSubmission {
  const MockRequestSubmission({required this.reference});

  final String reference;
}

class MockRequestDraft {
  const MockRequestDraft({
    required this.serviceId,
    this.description = '',
    this.address,
    this.submission,
  });

  final String serviceId;
  final String description;
  final MockRequestAddress? address;
  final MockRequestSubmission? submission;

  bool get canSubmit => serviceId.isNotEmpty && address != null;
}

abstract final class MockRequestCreationData {
  static const List<MockRequestAddress> addresses = <MockRequestAddress>[
    MockRequestAddress(
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
    MockRequestAddress(
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

  static const MockRequestSubmission submission = MockRequestSubmission(
    reference: 'MOCK-REQ-0001',
  );
}
