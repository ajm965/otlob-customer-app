enum AppEnvironment {
  development,
  staging,
  production;

  static AppEnvironment fromName(String value) {
    return switch (value) {
      'development' => AppEnvironment.development,
      'staging' => AppEnvironment.staging,
      'production' => AppEnvironment.production,
      _ => throw ArgumentError.value(
        value,
        'value',
        'Unsupported application environment.',
      ),
    };
  }
}
