enum MockHomeVisual { cleaning, airConditioning, plumbing, electrical }

enum MockHomeRequestTone { pending, inProgress }

class MockHomeCategory {
  const MockHomeCategory({
    required this.titleAr,
    required this.titleEn,
    required this.visual,
  });

  final String titleAr;
  final String titleEn;
  final MockHomeVisual visual;

  String title({required bool isArabic}) => isArabic ? titleAr : titleEn;
}

class MockHomeService {
  const MockHomeService({
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.visual,
  });

  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final MockHomeVisual visual;

  String title({required bool isArabic}) => isArabic ? titleAr : titleEn;

  String description({required bool isArabic}) =>
      isArabic ? descriptionAr : descriptionEn;
}

class MockRecentRequest {
  const MockRecentRequest({
    required this.titleAr,
    required this.titleEn,
    required this.statusAr,
    required this.statusEn,
    required this.reference,
    required this.tone,
  });

  final String titleAr;
  final String titleEn;
  final String statusAr;
  final String statusEn;
  final String reference;
  final MockHomeRequestTone tone;

  String title({required bool isArabic}) => isArabic ? titleAr : titleEn;
  String status({required bool isArabic}) => isArabic ? statusAr : statusEn;
}

abstract final class MockHomeData {
  static const List<MockHomeCategory> categories = <MockHomeCategory>[
    MockHomeCategory(
      titleAr: 'التنظيف',
      titleEn: 'Cleaning',
      visual: MockHomeVisual.cleaning,
    ),
    MockHomeCategory(
      titleAr: 'التكييف',
      titleEn: 'Air conditioning',
      visual: MockHomeVisual.airConditioning,
    ),
    MockHomeCategory(
      titleAr: 'السباكة',
      titleEn: 'Plumbing',
      visual: MockHomeVisual.plumbing,
    ),
    MockHomeCategory(
      titleAr: 'الكهرباء',
      titleEn: 'Electrical',
      visual: MockHomeVisual.electrical,
    ),
  ];

  static const List<MockHomeService> recommended = <MockHomeService>[
    MockHomeService(
      titleAr: 'تنظيف المنزل',
      titleEn: 'Home cleaning',
      descriptionAr: 'تنظيف أساسي للمساحات المنزلية',
      descriptionEn: 'Essential cleaning for home spaces',
      visual: MockHomeVisual.cleaning,
    ),
    MockHomeService(
      titleAr: 'صيانة المكيف',
      titleEn: 'AC maintenance',
      descriptionAr: 'فحص وصيانة دورية للمكيف',
      descriptionEn: 'Routine AC inspection and maintenance',
      visual: MockHomeVisual.airConditioning,
    ),
  ];

  static const List<MockRecentRequest> recentRequests = <MockRecentRequest>[
    MockRecentRequest(
      titleAr: 'تنظيف المنزل',
      titleEn: 'Home cleaning',
      statusAr: 'قيد الانتظار',
      statusEn: 'Pending',
      reference: 'REQ-1042',
      tone: MockHomeRequestTone.pending,
    ),
    MockRecentRequest(
      titleAr: 'صيانة المكيف',
      titleEn: 'AC maintenance',
      statusAr: 'قيد التنفيذ',
      statusEn: 'In progress',
      reference: 'REQ-1038',
      tone: MockHomeRequestTone.inProgress,
    ),
  ];
}
