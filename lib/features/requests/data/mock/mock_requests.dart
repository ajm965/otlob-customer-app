enum MockRequestStatus { pending, inProgress, completed, cancelled }

class MockRequest {
  const MockRequest({
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
  final MockRequestStatus status;

  String serviceTitle({required bool isArabic}) =>
      isArabic ? serviceTitleAr : serviceTitleEn;

  String dateLabel({required bool isArabic}) =>
      isArabic ? dateLabelAr : dateLabelEn;

  String description({required bool isArabic}) =>
      isArabic ? descriptionAr : descriptionEn;

  String location({required bool isArabic}) =>
      isArabic ? locationAr : locationEn;
}

abstract final class MockRequests {
  static const List<MockRequest> all = <MockRequest>[
    MockRequest(
      id: 'request-pending',
      serviceTitleAr: 'تنظيف المنزل',
      serviceTitleEn: 'Home cleaning',
      reference: 'REQ-1042',
      descriptionAr: 'تنظيف غرفة المعيشة والمساحات المشتركة',
      descriptionEn: 'Clean the living room and shared spaces',
      locationAr: 'المنزل التجريبي، الرياض',
      locationEn: 'Mock home, Riyadh',
      dateLabelAr: 'اليوم',
      dateLabelEn: 'Today',
      status: MockRequestStatus.pending,
    ),
    MockRequest(
      id: 'request-progress',
      serviceTitleAr: 'صيانة المكيف',
      serviceTitleEn: 'AC maintenance',
      reference: 'REQ-1038',
      descriptionAr: 'فحص المكيف والتأكد من كفاءة التبريد',
      descriptionEn: 'Inspect the AC and check cooling performance',
      locationAr: 'العمل التجريبي، الرياض',
      locationEn: 'Mock workplace, Riyadh',
      dateLabelAr: 'أمس',
      dateLabelEn: 'Yesterday',
      status: MockRequestStatus.inProgress,
    ),
    MockRequest(
      id: 'request-completed',
      serviceTitleAr: 'فحص السباكة',
      serviceTitleEn: 'Plumbing check',
      reference: 'REQ-1024',
      descriptionAr: 'فحص تسرب بسيط في منطقة المغسلة',
      descriptionEn: 'Inspect a minor leak near the sink',
      locationAr: 'المنزل التجريبي، الرياض',
      locationEn: 'Mock home, Riyadh',
      dateLabelAr: 'الأسبوع الماضي',
      dateLabelEn: 'Last week',
      status: MockRequestStatus.completed,
    ),
    MockRequest(
      id: 'request-cancelled',
      serviceTitleAr: 'فحص الكهرباء',
      serviceTitleEn: 'Electrical check',
      reference: 'REQ-1018',
      descriptionAr: 'فحص مقبس كهربائي لا يعمل',
      descriptionEn: 'Inspect an electrical outlet that is not working',
      locationAr: 'العمل التجريبي، الرياض',
      locationEn: 'Mock workplace, Riyadh',
      dateLabelAr: 'منذ أسبوعين',
      dateLabelEn: 'Two weeks ago',
      status: MockRequestStatus.cancelled,
    ),
  ];

  static MockRequest? byId(String id) {
    for (final MockRequest request in all) {
      if (request.id == id) {
        return request;
      }
    }
    return null;
  }
}
