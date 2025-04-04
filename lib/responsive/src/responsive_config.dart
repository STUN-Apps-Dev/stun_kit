/// Класс для настройки адаптивного дизайна.
/// Позволяет задавать и получать параметры, используемые при построении
/// интерфейсов для различных типов устройств (мобильные, планшеты, десктопы).
class ResponsiveConfig {
  // Максимальная ширина экрана для мобильных устройств.
  static double _mobileMaxWidth = 767;

  // Максимальная ширина экрана для планшетов.
  static double _tabletMaxWidth = 991;

  // Ширина контейнера для планшетов.
  static double _tabletContainerWidth = 720;

  // Ширина контейнера для десктопов.
  static double _desktopContainerWidth = 1140;

  /// Возвращает максимальную ширину для мобильных устройств.
  static double get mobileMaxWidth => _mobileMaxWidth;

  /// Возвращает максимальную ширину для планшетов.
  static double get tabletMaxWidth => _tabletMaxWidth;

  /// Возвращает ширину контейнера для планшетов.
  static double get tabletContainerWidth => _tabletContainerWidth;

  /// Возвращает ширину контейнера для десктопов.
  static double get desktopContainerWidth => _desktopContainerWidth;

  /// Инициализирует параметры адаптивного дизайна.
  ///
  /// Если переданный параметр равен null, используется значение по умолчанию.
  static void init({
    double? mobileMaxWidth,
    double? tabletMaxWidth,
    double? tabletContainerWidth,
    double? desktopContainerWidth,
  }) {
    _mobileMaxWidth = mobileMaxWidth ?? _mobileMaxWidth;
    _tabletMaxWidth = tabletMaxWidth ?? _tabletMaxWidth;
    _tabletContainerWidth = tabletContainerWidth ?? _tabletContainerWidth;
    _desktopContainerWidth = desktopContainerWidth ?? _desktopContainerWidth;
  }
}
