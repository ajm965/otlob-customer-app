import '../../../../core/network/platform_api_client.dart';
import '../../domain/models/customer_service.dart';

ServiceCategory parseCategory(Object? json) {
  final Map<String, Object?> map = _requireMap(json);
  return ServiceCategory(
    id: _requireString(map, 'id'),
    titleAr: _requireString(map, 'nameAr'),
    titleEn: _requireString(map, 'nameEn'),
  );
}

CustomerService parseService(Object? json) {
  final Map<String, Object?> map = _requireMap(json);
  return CustomerService(
    id: _requireString(map, 'id'),
    titleAr: _requireString(map, 'nameAr'),
    titleEn: _requireString(map, 'nameEn'),
    categoryId: _optionalString(map['categoryId']),
  );
}

List<T> parseCatalogItems<T>(
  Object? data,
  T Function(Object? json) parseItem,
) {
  final Map<String, Object?> map = _requireMap(data);
  final Object? items = map['items'];
  if (items is! List) {
    throw const FormatException('Catalog list is missing items.');
  }
  final List<T> parsed = <T>[];
  for (final Object? item in List<Object?>.from(items)) {
    parsed.add(parseItem(item));
  }
  return parsed;
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
    return value;
  }
  throw FormatException('Missing catalog field $key.');
}

String? _optionalString(Object? value) {
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  return null;
}
