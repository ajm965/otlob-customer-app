import '../../../../core/network/platform_api_client.dart';
import '../../domain/models/customer_profile.dart';

CustomerProfile parseProfile(Object? json) {
  final Map<String, Object?> map = _requireMap(json);

  final String id = _requireString(map, 'id');
  final String fullName = _requireString(map, 'fullName');
  final String locale = _requireLocale(map);
  final String primaryRole = _requireString(map, 'primaryRole');

  return CustomerProfile(
    id: id,
    fullName: fullName,
    locale: locale,
    primaryRole: primaryRole,
  );
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

String _requireLocale(Map<String, Object?> json) {
  final String locale = _requireString(json, 'locale').toLowerCase();

  if (locale != 'ar' && locale != 'en') {
    throw FormatException('Unsupported profile locale: $locale.');
  }

  return locale;
}
