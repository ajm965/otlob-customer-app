class CustomerAddress {
  const CustomerAddress({
    required this.id,
    required this.label,
    required this.line1,
    required this.city,
    required this.countryCode,
    this.line2,
    this.region,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String line1;
  final String? line2;
  final String city;
  final String? region;
  final String? postalCode;
  final String countryCode;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  String labelText({required bool isArabic}) => label;
  String line1Text({required bool isArabic}) => line1;
  String cityText({required bool isArabic}) => city;
}
