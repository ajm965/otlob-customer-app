import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class BootstrapErrorHandler {
  BootstrapErrorHandler({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  void installFrameworkBoundary() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _logger.e(
        'Uncaught Flutter framework error.',
        error: details.exception,
        stackTrace: details.stack,
      );
    };
  }

  Future<void> run(Future<void> Function() bootstrap) async {
    final Future<void>? guardedBootstrap = runZonedGuarded<Future<void>>(
      bootstrap,
      (Object error, StackTrace stackTrace) {
        _logger.e(
          'Uncaught asynchronous bootstrap error.',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
    if (guardedBootstrap != null) {
      await guardedBootstrap;
    }
  }
}
