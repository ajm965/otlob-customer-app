import '../../../../core/network/platform_api_client.dart';
import '../../domain/models/customer_profile.dart';

CustomerProfile parseProfile(Object? json) {
  final Map<String, Object?> map = _requireMap(json);
  final String fullName = _requireString(map, 'fullName');
  _requireString(map, 'locale');
  final String primaryRole = _requireString(map, 'primaryRole');
  final String roleSummaryAr = _roleSummary(primaryRole, isArabic: true);
  final String roleSummaryEn = _roleSummary(primaryRole, isArabic: false);

  return CustomerProfile(
    displayNameAr: fullName,
    displayNameEn: fullName,
    summaryAr: roleSummaryAr,
    summaryEn: roleSummaryEn,
  );
}

String _roleSummary(String primaryRole, {required bool isArabic}) {
  switch (primaryRole) {
    case 'customer':
      return isArabic ? 'عميل' : 'Customer';
    case 'technician':
      return isArabic ? 'فني' : 'Technician';
    case 'company_operator':
      return isArabic ? 'مشغل شركة' : 'Company operator';
    default:
      return isArabic ? 'مستخدم' : 'User';
  }
}

Map<String, Object?> _requireMap(Object? json) {
  final Map<String, Object?>? map = asJsonMap(json);
  if (map == null) {
    throw const FormatException('Expected a JSON object.');
  }
  return map;
}

String _requireString(Map<String, Object?> json, String key) {
  final Object? value = json[key];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  throw FormatException('Missing profile field $key.');
}