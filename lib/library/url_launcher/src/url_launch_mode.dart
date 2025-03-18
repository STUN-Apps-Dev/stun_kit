import 'package:url_launcher/url_launcher.dart';

/// Перечисление режимов открытия URL.
enum UrlLaunchMode {
  platformDefault,
  inAppWebView,
  inAppBrowserView,
  externalApplication,
  externalNonBrowserApplication,
}

/// Расширение для [UrlLaunchMode], позволяющее преобразовать значение
/// в [LaunchMode] из пакета [url_launcher].
extension UrlLaunchModeExt on UrlLaunchMode {
  /// Преобразует [UrlLaunchMode] в [LaunchMode].
  LaunchMode toLaunchMode() {
    switch (this) {
      case UrlLaunchMode.platformDefault:
        return LaunchMode.platformDefault;
      case UrlLaunchMode.inAppWebView:
        return LaunchMode.inAppWebView;
      case UrlLaunchMode.inAppBrowserView:
        return LaunchMode.inAppBrowserView;
      case UrlLaunchMode.externalApplication:
        return LaunchMode.externalApplication;
      case UrlLaunchMode.externalNonBrowserApplication:
        return LaunchMode.externalNonBrowserApplication;
    }
  }
}
