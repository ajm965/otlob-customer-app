import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../errors/integration_failure.dart';

class PlatformApiClient {
  PlatformApiClient({
    required this.client,
    required this.baseUrl,
    this.timeout = const Duration(seconds: 15),
  });

  final http.Client client;
  final String baseUrl;
  final Duration timeout;

  Future<IntegrationResult<Object?>> get(
    String path, {
    Map<String, String>? query,
  }) async {
    final Uri uri = _resolve(path, query);
    final http.Response response;
    try {
      response = await client.get(uri).timeout(timeout);
    } on TimeoutException {
      return const IntegrationError<Object?>(
        IntegrationFailure(IntegrationFailureKind.network),
      );
    } on http.ClientException catch (error) {
      return IntegrationError<Object?>(
        IntegrationFailure(IntegrationFailureKind.network, message: error.message),
      );
    } catch (_) {
      return const IntegrationError<Object?>(
        IntegrationFailure(IntegrationFailureKind.network),
      );
    }

    return _mapResponse(response);
  }

  Uri _resolve(String path, Map<String, String>? query) {
    final Uri base = Uri.parse(baseUrl);
    final String joinedPath = _joinPaths(base.path, path);
    return base.replace(
      path: joinedPath,
      queryParameters: query == null || query.isEmpty ? null : query,
    );
  }

  IntegrationResult<Object?> _mapResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final Object? decoded = _tryDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      final Map<String, Object?>? envelope = asJsonMap(decoded);
      if (envelope == null || !envelope.containsKey('data')) {
        return const IntegrationError<Object?>(
          IntegrationFailure(IntegrationFailureKind.unknown),
        );
      }
      return IntegrationSuccess<Object?>(envelope['data']);
    }

    return IntegrationError<Object?>(_failureForStatus(statusCode, decoded));
  }

  IntegrationFailure _failureForStatus(int statusCode, Object? decoded) {
    final Map<String, Object?>? envelope = asJsonMap(decoded);
    final Map<String, Object?>? error = asJsonMap(envelope?['error']);
    final String? message = _optionalString(error?['message']);
    final String? code = _optionalString(error?['code']);

    return IntegrationFailure(
      _kindFor(statusCode, code),
      message: message,
    );
  }

  IntegrationFailureKind _kindFor(int statusCode, String? code) {
    switch (code) {
      case 'unauthenticated':
        return IntegrationFailureKind.unauthorized;
      case 'forbidden':
        return IntegrationFailureKind.forbidden;
      case 'not_found':
        return IntegrationFailureKind.notFound;
      case 'validation_failed':
        return IntegrationFailureKind.validation;
    }

    if (statusCode == 401) {
      return IntegrationFailureKind.unauthorized;
    }
    if (statusCode == 403) {
      return IntegrationFailureKind.forbidden;
    }
    if (statusCode == 404) {
      return IntegrationFailureKind.notFound;
    }
    if (statusCode == 400 || statusCode == 422) {
      return IntegrationFailureKind.validation;
    }
    if (statusCode >= 500 && statusCode <= 599) {
      return IntegrationFailureKind.server;
    }
    return IntegrationFailureKind.unknown;
  }

  Object? _tryDecode(String body) {
    if (body.trim().isEmpty) {
      return null;
    }
    try {
      return jsonDecode(body);
    } on FormatException {
      return null;
    }
  }
}

Map<String, Object?>? asJsonMap(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map<String, dynamic>) {
    return Map<String, Object?>.from(value);
  }
  return null;
}

String? _optionalString(Object? value) {
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  return null;
}

String _joinPaths(String basePath, String path) {
  final String left = basePath.endsWith('/')
      ? basePath.substring(0, basePath.length - 1)
      : basePath;
  final String right = path.startsWith('/') ? path : '/$path';
  if (left.isEmpty) {
    return right;
  }
  return '$left$right';
}
