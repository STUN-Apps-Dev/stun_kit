import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  /// Загружает переменные окружения из файла .env
  static Future<void> init() {
    return dotenv.load(fileName: '.env');
  }

  /// Возвращает флаг отладки API
  static bool get isApiDebug {
    return dotenv.getBool('API_DEBUG', fallback: false);
  }

  /// Возвращает флаг отладки роутинга
  static bool get isRouterDebug {
    return dotenv.getBool('ROUTER_DEBUG', fallback: false);
  }

  /// Обобщённый метод для получения переменной окружения с возможным значением по умолчанию.
  static T getEnv<T>(String key, T fallback) {
    if (T == bool) {
      return dotenv.getBool(key, fallback: fallback as bool) as T;
    } else if (T == double) {
      return dotenv.getDouble(key, fallback: fallback as double) as T;
    } else if (T == int) {
      return dotenv.getInt(key, fallback: fallback as int) as T;
    } else if (T == String) {
      return dotenv.get(key, fallback: fallback as String) as T;
    }
    return fallback;
  }
}
