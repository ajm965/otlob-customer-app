import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/features/profile/data/http/profile_json.dart';
import 'package:otlob_customer_app/features/profile/domain/models/customer_profile.dart';

void main() {
  test('parseProfile maps /v1/auth/me response', () {
    final CustomerProfile profile = parseProfile(<String, Object?>{
      'id': 'user-001',
      'fullName': 'Sara Al-Otlob',
      'locale': 'ar',
      'primaryRole': 'customer',
    });

    expect(profile.displayNameAr, 'Sara Al-Otlob');
    expect(profile.displayNameEn, 'Sara Al-Otlob');
    expect(profile.summaryAr, 'عميل');
    expect(profile.summaryEn, 'Customer');
  });
}
