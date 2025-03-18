import 'package:flutter/foundation.dart';
import 'package:stun_kit/library/url_launcher/src/url_launch_mode.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Класс для работы с URL-лаунчером.
///
/// Предоставляет методы для открытия WhatsApp, телефона, email и произвольного URL.
class UrlLauncher {
  /// Открывает WhatsApp для указанного номера телефона.
  ///
  /// Если приложение запущено в Web, используется веб-версия WhatsApp.
  /// В противном случае – мобильное приложение.
  /// Возвращает [Future<bool>], указывающий на успешность открытия.
  static Future<bool> launchWhatsApp(String phone) async {
    final webUrl = 'https://api.whatsapp.com/send?phone=$phone';
    final mobileUrl = 'whatsapp://send/?phone=$phone';
    return launchUrlString(kIsWeb ? webUrl : mobileUrl);
  }

  /// Открывает приложение телефона для звонка по указанному номеру.
  ///
  /// Возвращает [Future<bool>], указывающий на успешность открытия.
  static Future<bool> launchPhone(String phone) async {
    return launchUrlString('tel:$phone');
  }

  /// Открывает приложение почты для отправки письма на указанный email.
  ///
  /// Возвращает [Future<bool>], указывающий на успешность открытия.
  static Future<bool> launchEmail(String email) async {
    return launchUrlString('mailto:$email');
  }

  /// Открывает произвольный URL.
  ///
  /// Параметры:
  /// - [url]: URL для открытия.
  /// - [webOnlyWindowName]: имя окна (только для веб, по умолчанию '_blank').
  /// - [mode]: режим открытия URL.
  ///
  /// Возвращает [Future<bool>], указывающий на успешность открытия.
  static Future<bool> launchUrl({
    required String url,
    String webOnlyWindowName = '_blank',
    UrlLaunchMode mode = UrlLaunchMode.platformDefault,
  }) async {
    return launchUrlString(
      url,
      webOnlyWindowName: webOnlyWindowName,
      mode: mode.toLaunchMode(),
    );
  }

  /// Приводит URL к корректному виду.
  ///
  /// Удаляет символы, которые могут нарушить работу URL.
  static String createValidUrl(String url) {
    return url.replaceAll('/#', '').replaceAll(r'\', '');
  }

  /// Проверяет, можно ли открыть указанный URL.
  ///
  /// Возвращает [Future<bool>], показывающий, доступен ли URL для открытия.
  static Future<bool> canLaunchUrl(String url) async {
    return canLaunchUrlString(url);
  }
}
