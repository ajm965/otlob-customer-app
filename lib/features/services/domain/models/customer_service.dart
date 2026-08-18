enum ServiceVisual {
  cleaning,
  airConditioning,
  plumbing,
  electrical,
  maintenance,
  moving,
}

class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.visual,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final ServiceVisual visual;

  String title({required bool isArabic}) => isArabic ? titleAr : titleEn;
}

class CustomerService {
  const CustomerService({
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
  final ServiceVisual visual;

  String title({required bool isArabic}) => isArabic ? titleAr : titleEn;

  String description({required bool isArabic}) =>
      isArabic ? descriptionAr : descriptionEn;
}
