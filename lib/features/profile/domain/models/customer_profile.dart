class CustomerProfile {
  const CustomerProfile({
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
