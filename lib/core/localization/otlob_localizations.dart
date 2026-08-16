import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class OtlobLocalizations {
  const OtlobLocalizations(this.locale);

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  static const LocalizationsDelegate<OtlobLocalizations> delegate =
      _OtlobLocalizationsDelegate();

  final Locale locale;

  bool get isArabic => locale.languageCode == 'ar';

  String get appName => isArabic ? 'أطلب' : 'Otlob';
  String get home => isArabic ? 'الرئيسية' : 'Home';
  String get services => isArabic ? 'الخدمات' : 'Services';
  String get requests => isArabic ? 'الطلبات' : 'Requests';
  String get profile => isArabic ? 'حسابي' : 'Profile';
  String get welcome => isArabic ? 'مرحباً بك' : 'Welcome';
  String get discoverServices =>
      isArabic ? 'ما الخدمة التي تحتاجها؟' : 'What service do you need?';
  String get searchServices => isArabic ? 'ابحث عن خدمة' : 'Search services';
  String get categories => isArabic ? 'فئات الخدمات' : 'Service categories';
  String get popularServices =>
      isArabic ? 'خدمات مقترحة' : 'Recommended services';
  String get recentRequests => isArabic ? 'أحدث الطلبات' : 'Recent requests';
  String get viewAll => isArabic ? 'عرض الكل' : 'View all';
  String get createRequest => isArabic ? 'إنشاء طلب' : 'Create request';
  String get browseServices => isArabic ? 'تصفح الخدمات' : 'Browse services';
  String get browseServicesDescription => isArabic
      ? 'اختر الخدمة المناسبة من الفئات المتاحة'
      : 'Choose the right service from the available categories';
  String get serviceDetails =>
      isArabic ? 'تفاصيل الخدمة لاحقاً' : 'Service details coming later';
  String get allRequests => isArabic ? 'كل الطلبات' : 'All requests';
  String get all => isArabic ? 'الكل' : 'All';
  String get noRequests => isArabic ? 'لا توجد طلبات' : 'No requests yet';
  String get noRequestsMessage => isArabic
      ? 'ستظهر طلباتك هنا بعد إنشاء أول طلب'
      : 'Your requests will appear here after you create one';
  String get pending => isArabic ? 'قيد الانتظار' : 'Pending';
  String get inProgress => isArabic ? 'قيد التنفيذ' : 'In progress';
  String get completed => isArabic ? 'مكتمل' : 'Completed';
  String get cancelled => isArabic ? 'ملغي' : 'Cancelled';
  String get requestReference => isArabic ? 'رقم الطلب' : 'Request reference';
  String get requestService => isArabic ? 'الخدمة' : 'Service';
  String get requestStatus => isArabic ? 'حالة الطلب' : 'Request status';
  String get requestDescription => isArabic ? 'الوصف' : 'Description';
  String get requestLocation => isArabic ? 'الموقع' : 'Location';
  String get requestDate => isArabic ? 'التاريخ' : 'Date';
  String get requestNotFound =>
      isArabic ? 'الطلب غير موجود' : 'Request not found';
  String get requestNotFoundMessage => isArabic
      ? 'تعذر العثور على هذا الطلب التجريبي'
      : 'This mock request could not be found';
  String get backToRequests =>
      isArabic ? 'العودة إلى الطلبات' : 'Back to requests';
  String get accountOverview => isArabic ? 'ملخص الحساب' : 'Account overview';
  String get customerName => isArabic ? 'عميل أطلب' : 'Otlob customer';
  String get customerContact => isArabic ? 'بيانات تجريبية' : 'Mock profile';
  String get profileInformation =>
      isArabic ? 'معلومات الملف الشخصي' : 'Profile information';
  String get accountOptions => isArabic ? 'خيارات الحساب' : 'Account options';
  String get personalInformation =>
      isArabic ? 'المعلومات الشخصية' : 'Personal information';
  String get language => isArabic ? 'اللغة' : 'Language';
  String get helpPlaceholder =>
      isArabic ? 'المساعدة (قريباً)' : 'Help (coming later)';
  String get placeholderActionMessage => isArabic
      ? 'هذه الخطوة غير مفعلة في النسخة التجريبية'
      : 'This action is not enabled in the mock experience';
  String get requestStart =>
      isArabic ? 'بدء طلب الخدمة' : 'Start service request';
  String get selectedService =>
      isArabic ? 'الخدمة المختارة' : 'Selected service';
  String get serviceUnavailable =>
      isArabic ? 'الخدمة غير متاحة' : 'Service unavailable';
  String get backToServices =>
      isArabic ? 'العودة إلى الخدمات' : 'Back to services';
  String get requestDetails => isArabic ? 'تفاصيل الطلب' : 'Request details';
  String get requestDetailsPrompt => isArabic
      ? 'اشرح ما تحتاجه لمساعدة مقدم الخدمة'
      : 'Describe what you need to help the service provider';
  String get descriptionOptional =>
      isArabic ? 'الوصف (اختياري)' : 'Description (optional)';
  String get descriptionHint => isArabic
      ? 'اكتب وصفاً مختصراً للمشكلة'
      : 'Add a short description of the issue';
  String get serviceLocation => isArabic ? 'موقع الخدمة' : 'Service location';
  String get selectMockLocation =>
      isArabic ? 'اختر موقعاً تجريبياً' : 'Select a mock location';
  String get mockLocationNotice => isArabic
      ? 'هذه مواقع محلية تجريبية ولا تستخدم الخرائط أو GPS'
      : 'These are local mock locations; no maps or GPS are used';
  String get locationRequired => isArabic
      ? 'اختر موقع الخدمة للمتابعة'
      : 'Select a service location to continue';
  String get reviewRequest => isArabic ? 'مراجعة الطلب' : 'Review request';
  String get reviewRequestMessage => isArabic
      ? 'راجع المعلومات قبل الإرسال التجريبي'
      : 'Review the information before mock submission';
  String get noDescription =>
      isArabic ? 'لم تتم إضافة وصف' : 'No description added';
  String get submitMockRequest =>
      isArabic ? 'إرسال طلب تجريبي' : 'Submit mock request';
  String get mockSubmissionNotice => isArabic
      ? 'لن يتم إرسال هذا الطلب إلى أي خادم'
      : 'This request will not be sent to any backend';
  String get requestSubmitted =>
      isArabic ? 'تم الإرسال التجريبي' : 'Mock submission complete';
  String get requestSubmittedMessage => isArabic
      ? 'تم إنشاء نتيجة محلية للعرض فقط'
      : 'A local result was created for demonstration only';
  String get submissionUnavailable => isArabic
      ? 'لا توجد نتيجة إرسال تجريبية'
      : 'No mock submission result is available';
  String get mockReference => isArabic ? 'المرجع التجريبي' : 'Mock reference';
  String get goToRequests =>
      isArabic ? 'الانتقال إلى الطلبات' : 'Go to Requests';
  String get continueLabel => isArabic ? 'متابعة' : 'Continue';
  String get optional => isArabic ? 'اختياري' : 'Optional';
  String get authentication => isArabic ? 'الدخول إلى أطلب' : 'Access Otlob';
  String get authenticationEntryMessage => isArabic
      ? 'سجّل الدخول أو أنشئ حساب عميل باستخدام رقم الجوال'
      : 'Sign in or create a customer account with your mobile number';
  String get signIn => isArabic ? 'تسجيل الدخول' : 'Sign in';
  String get createAccount => isArabic ? 'إنشاء حساب' : 'Create account';
  String get signInTitle => isArabic ? 'تسجيل الدخول' : 'Customer sign in';
  String get signInMessage => isArabic
      ? 'أدخل رقم جوالك للمتابعة إلى التحقق'
      : 'Enter your mobile number to continue to verification';
  String get registrationTitle =>
      isArabic ? 'إنشاء حساب عميل' : 'Create customer account';
  String get registrationMessage => isArabic
      ? 'ابدأ برقم جوال سعودي لإكمال التسجيل'
      : 'Start with a Saudi mobile number to register';
  String get phoneNumber => isArabic ? 'رقم الجوال' : 'Mobile number';
  String get phoneHint => '+966';
  String get phoneFormatHelp => isArabic
      ? 'استخدم الصيغة الدولية السعودية التي تبدأ بـ +966'
      : 'Use Saudi international format beginning with +966';
  String get phoneRequired =>
      isArabic ? 'أدخل رقم الجوال' : 'Enter your mobile number';
  String get phoneInvalid => isArabic
      ? 'أدخل رقماً سعودياً صحيحاً بالصيغة الدولية'
      : 'Enter a valid Saudi number in international format';
  String get sendMockCode =>
      isArabic ? 'متابعة إلى رمز تجريبي' : 'Continue to mock code';
  String get localAuthenticationNotice => isArabic
      ? 'هذه تجربة محلية فقط. لن يتم إرسال رمز أو الاتصال بأي خدمة.'
      : 'This is a local demo only. No code is sent and no service is contacted.';
  String get verificationTitle =>
      isArabic ? 'التحقق من رقم الجوال' : 'Verify mobile number';
  String verificationMessage(String phone) => isArabic
      ? 'أدخل أي قيمة غير فارغة لعرض التحقق المحلي للرقم $phone'
      : 'Enter any non-empty value to demonstrate local verification for $phone';
  String get verificationCode =>
      isArabic ? 'رمز التحقق التجريبي' : 'Mock verification code';
  String get verificationCodeHelp => isArabic
      ? 'طول الرمز غير محدد في العقود الحالية'
      : 'Code length is not defined by the current contracts';
  String get verificationCodeRequired => isArabic
      ? 'أدخل رمز التحقق التجريبي'
      : 'Enter the mock verification code';
  String get verifyMockCode => isArabic ? 'تحقق محلياً' : 'Verify locally';
  String get registrationProfile =>
      isArabic ? 'إكمال بيانات الحساب' : 'Complete account details';
  String get registrationProfileMessage => isArabic
      ? 'الاسم اختياري، والموافقة على الشروط والخصوصية مطلوبة'
      : 'Name is optional; Terms and Privacy acceptance is required';
  String get fullNameOptional =>
      isArabic ? 'الاسم الكامل (اختياري)' : 'Full name (optional)';
  String get fullNameHint =>
      isArabic ? 'أدخل اسمك إن رغبت' : 'Enter your name if you wish';
  String get acceptTermsAndPrivacy => isArabic
      ? 'أوافق على الشروط وسياسة الخصوصية'
      : 'I accept the Terms and Privacy Policy';
  String get termsAcceptanceRequired => isArabic
      ? 'يجب الموافقة على الشروط وسياسة الخصوصية'
      : 'Accept the Terms and Privacy Policy to continue';
  String get finishMockRegistration =>
      isArabic ? 'إكمال التسجيل التجريبي' : 'Complete mock registration';
  String get authenticationComplete =>
      isArabic ? 'اكتمل الدخول التجريبي' : 'Mock authentication complete';
  String get authenticationCompleteMessage => isArabic
      ? 'تمت محاكاة رحلة الدخول محلياً فقط، ولم يتم إنشاء جلسة حقيقية.'
      : 'The journey was simulated locally only; no real session was created.';
  String get goToHome => isArabic ? 'الانتقال إلى الرئيسية' : 'Go to Home';
  String get alreadyHaveAccount =>
      isArabic ? 'لديك حساب بالفعل؟' : 'Already have an account?';
  String get needCustomerAccount =>
      isArabic ? 'ليس لديك حساب؟' : 'Need a customer account?';
  String get authenticationStepUnavailable => isArabic
      ? 'ابدأ بإدخال رقم الجوال لإكمال هذه الخطوة'
      : 'Start with your mobile number to complete this step';
  String get restartAuthentication =>
      isArabic ? 'العودة إلى بداية الدخول' : 'Back to authentication';

  String requestStep(int current, int total) {
    return isArabic ? 'الخطوة $current من $total' : 'Step $current of $total';
  }

  static OtlobLocalizations of(BuildContext context) {
    return Localizations.of<OtlobLocalizations>(context, OtlobLocalizations)!;
  }
}

class _OtlobLocalizationsDelegate
    extends LocalizationsDelegate<OtlobLocalizations> {
  const _OtlobLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return OtlobLocalizations.supportedLocales.any(
      (Locale supportedLocale) =>
          supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<OtlobLocalizations> load(Locale locale) {
    return SynchronousFuture<OtlobLocalizations>(OtlobLocalizations(locale));
  }

  @override
  bool shouldReload(_OtlobLocalizationsDelegate old) => false;
}
