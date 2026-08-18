/// Transport-agnostic failures that future repository implementations can map.
///
/// This deliberately omits backend error codes until stable backend contracts
/// are available.
enum IntegrationFailureKind {
  network,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  unknown,
}

class IntegrationFailure {
  const IntegrationFailure(this.kind, {this.message});

  final IntegrationFailureKind kind;
  final String? message;
}

sealed class IntegrationResult<T> {
  const IntegrationResult();
}

class IntegrationSuccess<T> extends IntegrationResult<T> {
  const IntegrationSuccess(this.value);

  final T value;
}

class IntegrationError<T> extends IntegrationResult<T> {
  const IntegrationError(this.failure);

  final IntegrationFailure failure;
}
