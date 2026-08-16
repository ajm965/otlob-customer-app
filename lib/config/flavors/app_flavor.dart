import '../environment/app_environment.dart';

/// Maps environment selection to future platform flavor naming.
///
/// Platform-specific flavor build configuration is intentionally deferred.
enum AppFlavor {
  development,
  staging,
  production;

  factory AppFlavor.fromEnvironment(AppEnvironment environment) {
    return switch (environment) {
      AppEnvironment.development => AppFlavor.development,
      AppEnvironment.staging => AppFlavor.staging,
      AppEnvironment.production => AppFlavor.production,
    };
  }
}
