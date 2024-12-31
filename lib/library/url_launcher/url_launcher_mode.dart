import 'package:url_launcher/url_launcher.dart';

enum UrlLauncherMode {
  platformDefault,
  inAppWebView,
  inAppBrowserView,
  externalApplication,
  externalNonBrowserApplication,
}

extension UrlLauncherModeExt on UrlLauncherMode {
  LaunchMode toLaunchMode() {
    switch (this) {
      case UrlLauncherMode.platformDefault:
        return LaunchMode.platformDefault;
      case UrlLauncherMode.inAppWebView:
        return LaunchMode.inAppWebView;
      case UrlLauncherMode.inAppBrowserView:
        return LaunchMode.inAppBrowserView;
      case UrlLauncherMode.externalApplication:
        return LaunchMode.externalApplication;
      case UrlLauncherMode.externalNonBrowserApplication:
        return LaunchMode.externalNonBrowserApplication;
    }
  }
}
