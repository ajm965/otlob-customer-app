import '../../../../core/network/platform_api_client.dart';
import '../../../addresses/domain/models/customer_address.dart';
import '../../domain/models/customer_request.dart';

CustomerRequest parseRequest(Object? json) {
  final Map<String, Object?> map = _requireMap(json);
  final String id = _requireString(map, 'id');
  final String serviceId = _requireString(map, 'serviceId');
  final String description = _optionalString(map['description']) ?? '';
  final CustomerRequestStatus status = mapPlatformStatus(
    _requireString(map, 'status'),
  );

  return CustomerRequest(
    id: id,
    serviceId: serviceId,
    serviceTitleAr: serviceId,
    serviceTitleEn: _formatServiceId(serviceId),
    reference: id,
    descriptionAr: description,
    descriptionEn: description,
    locationAr: _locationLabel(map['location'], isArabic: true),
    locationEn: _locationLabel(map['location'], isArabic: false),
    dateLabelAr: _dateLabel(map['preferredTimeStart'], isArabic: true),
    dateLabelEn: _dateLabel(map['preferredTimeStart'], isArabic: false),
    status: status,
  );
}

RequestSubmission parseRequestSubmission(Object? json) {
  final Map<String, Object?> map = _requireMap(json);
  return RequestSubmission(reference: _requireString(map, 'id'));
}

List<CustomerRequest> parseRequestItems(Object? data) {
  final Map<String, Object?> map = _requireMap(data);
  final Object? items = map['items'];
  if (items is! List) {
    throw const FormatException('Request list is missing items.');
  }
  final List<CustomerRequest> parsed = <CustomerRequest>[];
  for (final Object? item in List<Object?>.from(items)) {
    parsed.add(parseRequest(item));
  }
  return parsed;
}

CustomerRequestStatus mapPlatformStatus(String status) {
  switch (status) {
    case 'draft':
    case 'open':
      return CustomerRequestStatus.pending;
    case 'matched':
    case 'booked':
      return CustomerRequestStatus.inProgress;
    case 'cancelled':
    case 'expired':
      return CustomerRequestStatus.cancelled;
    default:
      throw FormatException('Unsupported request status: $status');
  }
}

Map<String, Object?> buildCreateRequestBody(RequestDraft draft) {
  final Map<String, Object?> body = <String, Object?>{
    'serviceId': draft.serviceId.trim(),
    'description': draft.description.trim().isEmpty
        ? 'بدون وصف'
        : draft.description.trim(),
  };
  final CustomerAddress? address = draft.address;
  if (address != null && address.id.trim().isNotEmpty) {
    body['addressId'] = address.id.trim();
  } else if (address != null &&
      address.latitude != null &&
      address.longitude != null) {
    body['location'] = <String, Object?>{
      'latitude': address.latitude,
      'longitude': address.longitude,
    };
  }
  return body;
}

String _formatServiceId(String serviceId) {
  return serviceId
      .split(RegExp(r'[-_]'))
      .where((String part) => part.isNotEmpty)
      .map(
        (String part) =>
            '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
      )
      .join(' ');
}

String _locationLabel(Object? location, {required bool isArabic}) {
  final Map<String, Object?>? coordinates = asJsonMap(location);
  if (coordinates == null) {
    return isArabic ? 'غير محدد' : 'Not specified';
  }
  final Object? latitude = coordinates['latitude'];
  final Object? longitude = coordinates['longitude'];
  if (latitude is num && longitude is num) {
    return '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
  }
  return isArabic ? 'غير محدد' : 'Not specified';
}

String _dateLabel(Object? preferredTimeStart, {required bool isArabic}) {
  if (preferredTimeStart is! String || preferredTimeStart.trim().isEmpty) {
    return isArabic ? 'غير محدد' : 'Not specified';
  }
  final DateTime? parsed = DateTime.tryParse(preferredTimeStart);
  if (parsed == null) {
    return preferredTimeStart;
  }
  final String day = parsed.toLocal().toIso8601String().split('T').first;
  return day;
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
  throw FormatException('Missing request field $key.');
}

String? _optionalString(Object? value) {
  if (value is String) {
    return value;
  }
  return null;
}
