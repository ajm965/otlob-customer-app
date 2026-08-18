import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/features/services/data/http/catalog_json.dart';
import 'package:otlob_customer_app/features/services/domain/models/customer_service.dart';

void main() {
  test('parses a category response object', () {
    final ServiceCategory category = parseCategory(<String, Object?>{
      'id': 'plumbing',
      'marketId': 'sa',
      'countryCode': 'SA',
      'nameAr': 'سباكة',
      'nameEn': 'Plumbing',
      'isActive': true,
      'sortOrder': 1,
    });

    expect(category.id, 'plumbing');
    expect(category.titleAr, 'سباكة');
    expect(category.titleEn, 'Plumbing');
    expect(category.visual, isNull);
  });

  test('parses a service list item', () {
    final CustomerService service = parseService(<String, Object?>{
      'id': 'pipe-repair',
      'marketId': 'sa',
      'countryCode': 'SA',
      'categoryId': 'plumbing',
      'nameAr': 'إصلاح أنابيب',
      'nameEn': 'Pipe repair',
      'isActive': true,
    });

    expect(service.id, 'pipe-repair');
    expect(service.titleAr, 'إصلاح أنابيب');
    expect(service.titleEn, 'Pipe repair');
    expect(service.categoryId, 'plumbing');
    expect(service.descriptionAr, isNull);
    expect(service.descriptionEn, isNull);
    expect(service.visual, isNull);
  });

  test('parses a service detail object', () {
    final CustomerService service = parseService(<String, Object?>{
      'id': 'ac-gas-refill',
      'marketId': 'sa',
      'countryCode': 'SA',
      'categoryId': 'ac',
      'nameAr': 'تعبئة غاز التكييف',
      'nameEn': 'AC Gas Refill',
      'isActive': true,
    });

    expect(service.id, 'ac-gas-refill');
    expect(service.titleEn, 'AC Gas Refill');
    expect(service.categoryId, 'ac');
    expect(service.description(isArabic: false), isNull);
  });

  test('rejects a category object missing nameEn', () {
    expect(
      () => parseCategory(<String, Object?>{
        'id': 'plumbing',
        'nameAr': 'سباكة',
      }),
      throwsFormatException,
    );
  });
}
