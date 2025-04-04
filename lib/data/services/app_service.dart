/// Интерфейс для работы с сервисами приложения.
///
/// Определяет контракт для сервисов, предоставляющих функциональность, связанную с информацией о приложении.
abstract interface class AppService {
  /// Асинхронно получает версию приложения.
  ///
  /// Возвращает [Future] с версией приложения в виде строки.
  Future<String> fetchVersion();

  /// Асинхронно получает URL страницы приложения.
  ///
  /// Этот метод должен вернуть строку с URL, на которой представлена информация о приложении.
  Future<String> fetchAppUrl();

  /// Асинхронно получает URL политики конфиденциальности приложения.
  ///
  /// Метод должен вернуть строку с URL, на котором размещена политика конфиденциальности.
  Future<String> fetchPrivacyPolicyUrl();

  /// Асинхронно получает URL страницы разработчика приложения.
  ///
  /// Этот метод должен вернуть строку с URL, на которой представлена информация о разработчике.
  Future<String> fetchDeveloperStoreUrl();

  /// Асинхронно получает email разработчика приложения.
  ///
  /// Метод должен вернуть строку с email.
  Future<String> fetchDeveloperEmail();

  /// Асинхронно получает URL сайта приложения.
  ///
  /// Метод должен вернуть струку с URL сайта разработчикка.
  Future<String> fetchDeveloperSiteUrl();
}
