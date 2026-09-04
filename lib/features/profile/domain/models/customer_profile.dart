class CustomerProfile {
  const CustomerProfile({
    required this.id,
    required this.fullName,
    required this.locale,
    required this.primaryRole,
  });

  final String id;
  final String fullName;
  final String locale;
  final String primaryRole;

  /// Localized label for [primaryRole] (`customer`, `technician`,
  /// `company_operator`).
  String localizedPrimaryRole({required bool isArabic}) {
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
}
