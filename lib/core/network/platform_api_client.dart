import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../errors/integration_failure.dart';

class PlatformApiClient {
  PlatformApiClient({
    required this.client,
    required this.baseUrl,
    this.timeout = const Duration(seconds: 15),
    this.accessTokenProvider,
  });

  final http.Client client;
  final String baseUrl;
  final Duration timeout;
  final Future<String?> Function()? accessTokenProvider;

  Future<IntegrationResult<Object?>> get(
    String path, {
    Map<String, String>? query,
  }) {
    return _send(
      (Uri uri, Map<String, String> headers) => client.get(uri, headers: headers),
      path,
      query: query,
    );
  }

  Future<IntegrationResult<Object?>> post(
    String path, {
    Map<String, Object?>? body,
    Map<String, String>? query,
  }) {
    return _send(
      (Uri uri, Map<String, String> headers) => client.post(
        uri,
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      ),
      path,
      query: query,
      json: true,
    );
  }

  Future<IntegrationResult<Object?>> patch(
    String path, {
    Map<String, Object?>? body,
    Map<String, String>? query,
  }) {
    return _send(
      (Uri uri, Map<String, String> headers) => client.patch(
        uri,
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      ),
      path,
      query: query,
      json: true,
    );
  }

  Future<IntegrationResult<Object?>> delete(
    String path, {
    Map<String, String>? query,
  }) {
    return _send(
      (Uri uri, Map<String, String> headers) => client.delete(uri, headers: headers),
      path,
      query: query,
    );
  }

  Future<IntegrationResult<Object?>> _send(
    Future<http.Response> Function(Uri uri, Map<String, String> headers) send,
    String path, {
    Map<String, String>? query,
    bool json = false,
  }) async {
    final Uri uri = _resolve(path, query);
    final Map<String, String> headers = await _headers(json: json);
    final http.Response response;
    try {
      response = await send(uri, headers).timeout(timeout);
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

  Future<Map<String, String>> _headers({bool json = false}) async {
    final Map<String, String> headers = <String, String>{};
    if (json) {
      headers['content-type'] = 'application/json';
    }
    final String? token = await accessTokenProvider?.call();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
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
