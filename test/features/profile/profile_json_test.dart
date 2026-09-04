import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/features/profile/data/http/profile_json.dart';
import 'package:otlob_customer_app/features/profile/domain/models/customer_profile.dart';

void main() {
  test('parseProfile maps /v1/auth/me response fields', () {
    final CustomerProfile profile = parseProfile(<String, Object?>{
      'id': 'user-001',
      'fullName': 'Sara Al-Otlob',
      'locale': 'ar',
      'primaryRole': 'customer',
    });

    expect(profile.id, 'user-001');
    expect(profile.fullName, 'Sara Al-Otlob');
    expect(profile.locale, 'ar');
    expect(profile.primaryRole, 'customer');
    expect(profile.localizedPrimaryRole(isArabic: true), 'عميل');
    expect(profile.localizedPrimaryRole(isArabic: false), 'Customer');
  });

  test('parseProfile normalizes locale to lowercase', () {
    final CustomerProfile profile = parseProfile(<String, Object?>{
      'id': 'user-002',
      'fullName': 'Alex',
      'locale': 'EN',
      'primaryRole': 'technician',
    });

    expect(profile.locale, 'en');
    expect(profile.primaryRole, 'technician');
    expect(profile.localizedPrimaryRole(isArabic: false), 'Technician');
  });

  test('parseProfile trims required string fields', () {
    final CustomerProfile profile = parseProfile(<String, Object?>{
      'id': '  user-003  ',
      'fullName': '  Nora  ',
      'locale': ' ar ',
      'primaryRole': ' company_operator ',
    });

    expect(profile.id, 'user-003');
    expect(profile.fullName, 'Nora');
    expect(profile.locale, 'ar');
    expect(profile.primaryRole, 'company_operator');
    expect(
      profile.localizedPrimaryRole(isArabic: true),
      'مشغل شركة',
    );
  });

  test('parseProfile rejects non-object JSON', () {
    expect(() => parseProfile(<Object?>['not-a-map']), throwsFormatException);
  });

  test('parseProfile rejects missing id', () {
    expect(
      () => parseProfile(<String, Object?>{
        'fullName': 'Sara',
        'locale': 'ar',
        'primaryRole': 'customer',
      }),
      throwsFormatException,
    );
  });

  test('parseProfile rejects missing fullName', () {
    expect(
      () => parseProfile(<String, Object?>{
        'id': 'user-001',
        'locale': 'ar',
        'primaryRole': 'customer',
      }),
      throwsFormatException,
    );
  });

  test('parseProfile rejects blank fullName', () {
    expect(
      () => parseProfile(<String, Object?>{
        'id': 'user-001',
        'fullName': '   ',
        'locale': 'ar',
        'primaryRole': 'customer',
      }),
      throwsFormatException,
    );
  });

  test('parseProfile rejects missing locale', () {
    expect(
      () => parseProfile(<String, Object?>{
        'id': 'user-001',
        'fullName': 'Sara',
        'primaryRole': 'customer',
      }),
      throwsFormatException,
    );
  });

  test('parseProfile rejects unsupported locale', () {
    expect(
      () => parseProfile(<String, Object?>{
        'id': 'user-001',
        'fullName': 'Sara',
        'locale': 'fr',
        'primaryRole': 'customer',
      }),
      throwsFormatException,
    );
  });

  test('parseProfile rejects missing primaryRole', () {
    expect(
      () => parseProfile(<String, Object?>{
        'id': 'user-001',
        'fullName': 'Sara',
        'locale': 'ar',
      }),
      throwsFormatException,
    );
  });
}
