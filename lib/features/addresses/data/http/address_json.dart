import '../../../../core/network/platform_api_client.dart';
import '../../domain/models/customer_address.dart';

CustomerAddress parseAddress(Object? json) {
  final Map<String, Object?> map = _requireMap(json);
  final Map<String, Object?>? location = asJsonMap(map['location']);
  return CustomerAddress(
    id: _requireString(map, 'id'),
    label: _requireString(map, 'label'),
    line1: _requireString(map, 'line1'),
    line2: _optionalString(map['line2']),
    city: _requireString(map, 'city'),
    region: _optionalString(map['region']),
    postalCode: _optionalString(map['postalCode']),
    countryCode: _requireString(map, 'countryCode'),
    latitude: _optionalDouble(location?['latitude']),
    longitude: _optionalDouble(location?['longitude']),
    isDefault: map['isDefault'] == true,
  );
}

List<CustomerAddress> parseAddressItems(Object? data) {
  final Map<String, Object?> map = _requireMap(data);
  final Object? items = map['items'];
  if (items is! List) {
    throw const FormatException('Address list is missing items.');
  }
  return List<CustomerAddress>.from(
    List<Object?>.from(items).map(parseAddress),
  );
}

Map<String, Object?> buildCreateAddressBody(CustomerAddress address) {
  final Map<String, Object?> body = <String, Object?>{
    'label': address.label.trim(),
    'line1': address.line1.trim(),
    'city': address.city.trim(),
    'countryCode': address.countryCode.trim(),
    'isDefault': address.isDefault,
  };
  if (address.line2 != null && address.line2!.trim().isNotEmpty) {
    body['line2'] = address.line2!.trim();
  }
  if (address.region != null && address.region!.trim().isNotEmpty) {
    body['region'] = address.region!.trim();
  }
  if (address.postalCode != null && address.postalCode!.trim().isNotEmpty) {
    body['postalCode'] = address.postalCode!.trim();
  }
  final double? latitude = address.latitude;
  final double? longitude = address.longitude;
  if (latitude != null && longitude != null) {
    body['location'] = <String, Object?>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }
  return body;
}

Map<String, Object?> buildUpdateAddressBody(CustomerAddress address) {
  return buildCreateAddressBody(address);
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
  throw FormatException('Missing address field $key.');
}

String? _optionalString(Object? value) {
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  return null;
}

double? _optionalDouble(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  return null;
}
