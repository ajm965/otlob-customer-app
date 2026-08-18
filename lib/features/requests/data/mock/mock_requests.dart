import '../../../../core/errors/integration_failure.dart';
import '../../domain/models/customer_request.dart';
import '../../domain/repositories/customer_request_repository.dart';
import 'mock_request_creation.dart';

typedef MockRequest = CustomerRequest;
typedef MockRequestStatus = CustomerRequestStatus;

abstract final class MockRequests {
  static const List<CustomerRequest> all = <CustomerRequest>[
    CustomerRequest(
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
      status: CustomerRequestStatus.pending,
    ),
    CustomerRequest(
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
      status: CustomerRequestStatus.inProgress,
    ),
    CustomerRequest(
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
      status: CustomerRequestStatus.completed,
    ),
    CustomerRequest(
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
      status: CustomerRequestStatus.cancelled,
    ),
  ];

  static CustomerRequest? byId(String id) {
    for (final CustomerRequest request in all) {
      if (request.id == id) {
        return request;
      }
    }
    return null;
  }
}

class MockCustomerRequestRepository implements CustomerRequestRepository {
  const MockCustomerRequestRepository();

  @override
  Future<IntegrationResult<List<CustomerRequest>>> listRequests() async =>
      const IntegrationSuccess<List<CustomerRequest>>(MockRequests.all);

  @override
  Future<IntegrationResult<CustomerRequest?>> getRequest(
    String requestId,
  ) async => IntegrationSuccess<CustomerRequest?>(MockRequests.byId(requestId));

  @override
  Future<IntegrationResult<RequestSubmission>> createRequest(
    RequestDraft draft,
  ) async {
    if (!draft.canSubmit) {
      return const IntegrationError<RequestSubmission>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }
    return const IntegrationSuccess<RequestSubmission>(
      MockRequestCreationData.submission,
    );
  }

  @override
  Future<IntegrationResult<List<RequestAddress>>>
  listSelectableAddresses() async =>
      const IntegrationSuccess<List<RequestAddress>>(
        MockRequestCreationData.addresses,
      );
}
