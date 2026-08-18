import '../../../../core/errors/integration_failure.dart';
import '../../domain/models/customer_service.dart';
import '../../domain/repositories/service_catalog_repository.dart';

abstract final class MockServices {
  static const List<ServiceCategory> categories = <ServiceCategory>[
    ServiceCategory(
      id: 'cleaning',
      titleAr: 'التنظيف',
      titleEn: 'Cleaning',
      visual: ServiceVisual.cleaning,
    ),
    ServiceCategory(
      id: 'air-conditioning',
      titleAr: 'التكييف',
      titleEn: 'Air conditioning',
      visual: ServiceVisual.airConditioning,
    ),
    ServiceCategory(
      id: 'plumbing',
      titleAr: 'السباكة',
      titleEn: 'Plumbing',
      visual: ServiceVisual.plumbing,
    ),
    ServiceCategory(
      id: 'electrical',
      titleAr: 'الكهرباء',
      titleEn: 'Electrical',
      visual: ServiceVisual.electrical,
    ),
  ];

  static const List<CustomerService> popular = <CustomerService>[
    CustomerService(
      id: 'home-cleaning',
      titleAr: 'تنظيف المنزل',
      titleEn: 'Home cleaning',
      descriptionAr: 'خدمة تنظيف أساسية للمنزل',
      descriptionEn: 'Essential cleaning for your home',
      visual: ServiceVisual.cleaning,
    ),
    CustomerService(
      id: 'ac-maintenance',
      titleAr: 'صيانة المكيف',
      titleEn: 'AC maintenance',
      descriptionAr: 'فحص وصيانة دورية للمكيف',
      descriptionEn: 'Routine AC inspection and maintenance',
      visual: ServiceVisual.airConditioning,
    ),
    CustomerService(
      id: 'plumbing-check',
      titleAr: 'فحص السباكة',
      titleEn: 'Plumbing check',
      descriptionAr: 'فحص أولي لمشكلات السباكة',
      descriptionEn: 'Initial inspection for plumbing issues',
      visual: ServiceVisual.plumbing,
    ),
    CustomerService(
      id: 'electrical-check',
      titleAr: 'فحص الكهرباء',
      titleEn: 'Electrical check',
      descriptionAr: 'فحص أولي للأعطال الكهربائية',
      descriptionEn: 'Initial inspection for electrical issues',
      visual: ServiceVisual.electrical,
    ),
  ];
}

class MockServiceCatalogRepository implements ServiceCatalogRepository {
  const MockServiceCatalogRepository();

  @override
  Future<IntegrationResult<List<ServiceCategory>>> listCategories() async =>
      const IntegrationSuccess<List<ServiceCategory>>(MockServices.categories);

  @override
  Future<IntegrationResult<List<CustomerService>>> listServices() async =>
      const IntegrationSuccess<List<CustomerService>>(MockServices.popular);

  @override
  Future<IntegrationResult<CustomerService?>> getService(
    String serviceId,
  ) async {
    for (final CustomerService service in MockServices.popular) {
      if (service.id == serviceId) {
        return IntegrationSuccess<CustomerService?>(service);
      }
    }
    return const IntegrationSuccess<CustomerService?>(null);
  }
}
