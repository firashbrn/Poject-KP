// core/utils/logger.dart
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class AppLogger {
  static final Logger _logger = Logger('AppLogger');

  AppLogger(String s);

  static void setup() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // In production, send to logging service
      if (kDebugMode) {
        print(
          '[${record.level.name}] ${record.loggerName}: ${record.message}',
        );
      }
    });
  }

  static void info(String message) {
    _logger.info(message);
  }

  static void warning(String message) {
    _logger.warning(message);
  }

  static void severe(String message) {
    _logger.severe(message);
  }

  static void fine(String message) {
    _logger.fine(message);
  }
}