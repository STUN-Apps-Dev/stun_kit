import 'package:url_launcher/url_launcher.dart';

enum UrlLaunchMode {
  platformDefault,
  inAppWebView,
  inAppBrowserView,
  externalApplication,
  externalNonBrowserApplication,
}

extension UrlLaunchModeExt on UrlLaunchMode {
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
