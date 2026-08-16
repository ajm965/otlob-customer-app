enum MockServiceVisual {
  cleaning,
  airConditioning,
  plumbing,
  electrical,
  maintenance,
  moving,
}

class MockServiceCategory {
  const MockServiceCategory({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.visual,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final MockServiceVisual visual;

  String title({required bool isArabic}) => isArabic ? titleAr : titleEn;
}

class MockService {
  const MockService({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.visual,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final MockServiceVisual visual;

  String title({required bool isArabic}) => isArabic ? titleAr : titleEn;

  String description({required bool isArabic}) =>
      isArabic ? descriptionAr : descriptionEn;
}

abstract final class MockServices {
  static const List<MockServiceCategory> categories = <MockServiceCategory>[
    MockServiceCategory(
      id: 'cleaning',
      titleAr: 'التنظيف',
      titleEn: 'Cleaning',
      visual: MockServiceVisual.cleaning,
    ),
    MockServiceCategory(
      id: 'air-conditioning',
      titleAr: 'التكييف',
      titleEn: 'Air conditioning',
      visual: MockServiceVisual.airConditioning,
    ),
    MockServiceCategory(
      id: 'plumbing',
      titleAr: 'السباكة',
      titleEn: 'Plumbing',
      visual: MockServiceVisual.plumbing,
    ),
    MockServiceCategory(
      id: 'electrical',
      titleAr: 'الكهرباء',
      titleEn: 'Electrical',
      visual: MockServiceVisual.electrical,
    ),
  ];

  static const List<MockService> popular = <MockService>[
    MockService(
      id: 'home-cleaning',
      titleAr: 'تنظيف المنزل',
      titleEn: 'Home cleaning',
      descriptionAr: 'خدمة تنظيف أساسية للمنزل',
      descriptionEn: 'Essential cleaning for your home',
      visual: MockServiceVisual.cleaning,
    ),
    MockService(
      id: 'ac-maintenance',
      titleAr: 'صيانة المكيف',
      titleEn: 'AC maintenance',
      descriptionAr: 'فحص وصيانة دورية للمكيف',
      descriptionEn: 'Routine AC inspection and maintenance',
      visual: MockServiceVisual.airConditioning,
    ),
    MockService(
      id: 'plumbing-check',
      titleAr: 'فحص السباكة',
      titleEn: 'Plumbing check',
      descriptionAr: 'فحص أولي لمشكلات السباكة',
      descriptionEn: 'Initial inspection for plumbing issues',
      visual: MockServiceVisual.plumbing,
    ),
    MockService(
      id: 'electrical-check',
      titleAr: 'فحص الكهرباء',
      titleEn: 'Electrical check',
      descriptionAr: 'فحص أولي للأعطال الكهربائية',
      descriptionEn: 'Initial inspection for electrical issues',
      visual: MockServiceVisual.electrical,
    ),
  ];
}
