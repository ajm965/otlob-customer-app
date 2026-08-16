class MockProfile {
  const MockProfile({
    required this.displayNameAr,
    required this.displayNameEn,
    required this.summaryAr,
    required this.summaryEn,
  });

  final String displayNameAr;
  final String displayNameEn;
  final String summaryAr;
  final String summaryEn;

  String displayName({required bool isArabic}) =>
      isArabic ? displayNameAr : displayNameEn;

  String summary({required bool isArabic}) => isArabic ? summaryAr : summaryEn;
}

abstract final class MockProfileData {
  static const MockProfile customer = MockProfile(
    displayNameAr: 'عميل أطلب',
    displayNameEn: 'Otlob customer',
    summaryAr: 'ملف شخصي تجريبي للعرض فقط',
    summaryEn: 'Mock profile for presentation only',
  );
}
