import '../../domain/models/customer_request.dart';

typedef MockRequestSubmission = RequestSubmission;
typedef MockRequestDraft = RequestDraft;

abstract final class MockRequestCreationData {
  static const RequestSubmission submission = RequestSubmission(
    reference: 'MOCK-REQ-0001',
  );
}
