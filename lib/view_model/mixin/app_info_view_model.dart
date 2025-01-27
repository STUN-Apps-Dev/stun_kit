import 'dart:io';

import 'package:store_checker/store_checker.dart';
import 'package:stun_kit/library/url_launcher/url_launcher.dart';
import 'package:stun_kit/view_model/models/app_info.dart';

abstract mixin class AppInfoViewModel {
  AppInfo get appInfo;

  Future<bool> launchUrl(String url) {
    return UrlLauncher.launchUrl(
      url: url,
      mode: UrlLaunchMode.externalApplication,
    );
  }

  Future<bool> launchPrivacyPolicy() {
    if (Platform.isIOS) {
      return launchUrl(appInfo.privacyPolicyAppStoreUrl);
    } else {
      return launchUrl(appInfo.privacyPolicyAndroidUrl);
    }
  }

  Future<bool> rateApp() async {
    final source = await StoreChecker.getSource;
    switch (source) {
      case Source.IS_INSTALLED_FROM_PLAY_STORE:
        return launchUrl(appInfo.playStoreAppUrl);
      case Source.IS_INSTALLED_FROM_APP_STORE:
        return launchUrl(appInfo.appStoreAppUrl);
      case Source.IS_INSTALLED_FROM_RU_STORE:
        return launchUrl(appInfo.ruStoreAppUrl);
      default:
        return false;
    }
  }

  Future<bool> seeOtherApps() async {
    final source = await StoreChecker.getSource;
    switch (source) {
      case Source.IS_INSTALLED_FROM_PLAY_STORE:
        return launchUrl(appInfo.playStoreDeveloperUrl);
      case Source.IS_INSTALLED_FROM_APP_STORE:
        return launchUrl(appInfo.appStoreDeveloperUrl);
      case Source.IS_INSTALLED_FROM_RU_STORE:
        return launchUrl(appInfo.ruStoreDeveloperUrl);
      default:
        return false;
    }
  }

  Future<bool> launcEmail() {
    return UrlLauncher.launchEmail(appInfo.developerEmail);
  }
}
