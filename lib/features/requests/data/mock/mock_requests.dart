enum MockRequestStatus { pending, inProgress, completed, cancelled }

class MockRequest {
  const MockRequest({
    required this.id,
    required this.serviceTitleAr,
    required this.serviceTitleEn,
    required this.reference,
    required this.dateLabelAr,
    required this.dateLabelEn,
    required this.status,
  });

  final String id;
  final String serviceTitleAr;
  final String serviceTitleEn;
  final String reference;
  final String dateLabelAr;
  final String dateLabelEn;
  final MockRequestStatus status;

  String serviceTitle({required bool isArabic}) =>
      isArabic ? serviceTitleAr : serviceTitleEn;

  String dateLabel({required bool isArabic}) =>
      isArabic ? dateLabelAr : dateLabelEn;
}

abstract final class MockRequests {
  static const List<MockRequest> all = <MockRequest>[
    MockRequest(
      id: 'request-pending',
      serviceTitleAr: 'تنظيف المنزل',
      serviceTitleEn: 'Home cleaning',
      reference: 'REQ-1042',
      dateLabelAr: 'اليوم',
      dateLabelEn: 'Today',
      status: MockRequestStatus.pending,
    ),
    MockRequest(
      id: 'request-progress',
      serviceTitleAr: 'صيانة المكيف',
      serviceTitleEn: 'AC maintenance',
      reference: 'REQ-1038',
      dateLabelAr: 'أمس',
      dateLabelEn: 'Yesterday',
      status: MockRequestStatus.inProgress,
    ),
    MockRequest(
      id: 'request-completed',
      serviceTitleAr: 'فحص السباكة',
      serviceTitleEn: 'Plumbing check',
      reference: 'REQ-1024',
      dateLabelAr: 'الأسبوع الماضي',
      dateLabelEn: 'Last week',
      status: MockRequestStatus.completed,
    ),
    MockRequest(
      id: 'request-cancelled',
      serviceTitleAr: 'فحص الكهرباء',
      serviceTitleEn: 'Electrical check',
      reference: 'REQ-1018',
      dateLabelAr: 'منذ أسبوعين',
      dateLabelEn: 'Two weeks ago',
      status: MockRequestStatus.cancelled,
    ),
  ];
}
