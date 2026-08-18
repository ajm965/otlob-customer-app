enum CustomerRequestStatus { pending, inProgress, completed, cancelled }

class CustomerRequest {
  const CustomerRequest({
    required this.id,
    required this.serviceTitleAr,
    required this.serviceTitleEn,
    required this.reference,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.locationAr,
    required this.locationEn,
    required this.dateLabelAr,
    required this.dateLabelEn,
    required this.status,
  });

  final String id;
  final String serviceTitleAr;
  final String serviceTitleEn;
  final String reference;
  final String descriptionAr;
  final String descriptionEn;
  final String locationAr;
  final String locationEn;
  final String dateLabelAr;
  final String dateLabelEn;
  final CustomerRequestStatus status;

  String serviceTitle({required bool isArabic}) =>
      isArabic ? serviceTitleAr : serviceTitleEn;

  String dateLabel({required bool isArabic}) =>
      isArabic ? dateLabelAr : dateLabelEn;

  String description({required bool isArabic}) =>
      isArabic ? descriptionAr : descriptionEn;

  String location({required bool isArabic}) =>
      isArabic ? locationAr : locationEn;
}

class RequestAddress {
  const RequestAddress({
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

class RequestDraft {
  const RequestDraft({
    required this.serviceId,
    this.description = '',
    this.address,
    this.submission,
  });

  final String serviceId;
  final String description;
  final RequestAddress? address;
  final RequestSubmission? submission;

  bool get canSubmit => serviceId.isNotEmpty && address != null;
}

class RequestSubmission {
  const RequestSubmission({required this.reference});

  final String reference;
}
