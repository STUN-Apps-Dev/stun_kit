import 'package:stun_kit/data/services/app_service.dart';
import 'package:stun_kit/library/url_launcher/url_launcher.dart';

/// ViewModel для отображения информации о приложении и взаимодействия с внешними ресурсами.
///
/// Отвечает за запуск политики конфиденциальности, открытие страницы оценки приложения,
/// переход к другим приложениям разработчика и отправку email.
class AppViewModel {
  /// Сервис, предоставляющий данные о приложении (URL политики, URL приложения, email разработчика).
  final AppService appService;

  /// Конструктор [AppViewModel].
  ///
  /// Требует обязательный параметр [appService] для получения данных о приложении.
  AppViewModel({required this.appService});

  /// Запускает URL политики конфиденциальности.
  ///
  /// Получает URL политики конфиденциальности через [AppService],
  /// а затем пытается открыть его с использованием [UrlLauncher].
  ///
  /// Возвращает [Future<bool>]:
  /// - `true` – если URL успешно запущен,
  /// - `false` – в случае ошибки.
  Future<bool> launchPrivacyPolicy() async {
    final url = await appService.fetchPrivacyPolicyUrl();
    return _launchUrl(url);
  }

  /// Открывает страницу для оценки приложения.
  ///
  /// Получает URL приложения через [AppService]. Если URL пустой, возвращает `false`.
  /// Иначе пытается открыть URL с помощью [UrlLauncher].
  ///
  /// Возвращает [Future<bool>] с результатом операции.
  Future<bool> rateApp() async {
    final url = await appService.fetchAppUrl();
    if (url.isEmpty) return false;
    return _launchUrl(url);
  }

  /// Открывает страницу с другими приложениями разработчика.
  ///
  /// Получает URL страницы разработчика через [AppService]. Если URL пустой, возвращает `false`.
  /// Иначе запускает URL с использованием [UrlLauncher].
  ///
  /// Возвращает [Future<bool>] с результатом запуска.
  Future<bool> seeOtherApps() async {
    final url = await appService.fetchDeveloperUrl();
    if (url.isEmpty) return false;
    return _launchUrl(url);
  }

  /// Запускает почтовый клиент для отправки email разработчику.
  ///
  /// Получает email разработчика через [AppService] и передает его в [UrlLauncher.launchEmail].
  ///
  /// Возвращает [Future<bool>] с результатом операции.
  Future<bool> launcEmail() async {
    final email = await appService.fetchDeveloperEmail();
    return UrlLauncher.launchEmail(email);
  }

  /// Вспомогательный метод для запуска URL с внешним приложением.
  ///
  /// [url] — URL для открытия.
  ///
  /// Возвращает [Future<bool>] с результатом запуска URL.
  Future<bool> _launchUrl(String url) {
    return UrlLauncher.launchUrl(
      url: url,
      mode: UrlLaunchMode.externalApplication,
    );
  }
}
