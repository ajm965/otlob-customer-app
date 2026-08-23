import '../../../addresses/domain/models/customer_address.dart';

enum CustomerRequestStatus { pending, inProgress, completed, cancelled }

class CustomerRequest {
  const CustomerRequest({
    required this.id,
    required this.serviceId,
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
  final String serviceId;
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

  CustomerRequest withCatalogTitles({
    required String titleAr,
    required String titleEn,
  }) {
    return CustomerRequest(
      id: id,
      serviceId: serviceId,
      serviceTitleAr: titleAr,
      serviceTitleEn: titleEn,
      reference: reference,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      locationAr: locationAr,
      locationEn: locationEn,
      dateLabelAr: dateLabelAr,
      dateLabelEn: dateLabelEn,
      status: status,
    );
  }
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
  final CustomerAddress? address;
  final RequestSubmission? submission;

  bool get canSubmit => serviceId.isNotEmpty && address != null;
}

class RequestSubmission {
  const RequestSubmission({required this.reference});

  final String reference;
}
