import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConfig {
  AppConfig._();

  static Future<void> load() {
    return dotenv.load(fileName: ".env");
  }

  static String debugerKey(final String key) {
    return dotenv.env[key] ?? '';
  }

  static String analyticsKey(final String key) {
    return dotenv.env[key] ?? '';
  }

  static bool get apiLogs {
    return const bool.fromEnvironment('API_LOGS', defaultValue: true);
  }

  static bool get navigationLogs {
    return const bool.fromEnvironment('NAV_LOGS', defaultValue: true);
  }
}
