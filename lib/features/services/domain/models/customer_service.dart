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
    this.visual,
  });

  final String id;
  final String titleAr;
  final String titleEn;

  /// Present only on local mock fixtures. Platform catalog DTOs do not include it.
  final ServiceVisual? visual;

  String title({required bool isArabic}) => isArabic ? titleAr : titleEn;
}

class CustomerService {
  const CustomerService({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    this.categoryId,
    this.descriptionAr,
    this.descriptionEn,
    this.visual,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final String? categoryId;

  /// Present only on local mock fixtures. Platform catalog DTOs do not include it.
  final String? descriptionAr;

  /// Present only on local mock fixtures. Platform catalog DTOs do not include it.
  final String? descriptionEn;

  /// Present only on local mock fixtures. Platform catalog DTOs do not include it.
  final ServiceVisual? visual;

  String title({required bool isArabic}) => isArabic ? titleAr : titleEn;

  String? description({required bool isArabic}) {
    final String? value = isArabic ? descriptionAr : descriptionEn;
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value;
  }
}
