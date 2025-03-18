import 'dart:io';

import 'package:store_checker/store_checker.dart';
import 'package:stun_kit/config/config.dart';
import 'package:stun_kit/library/url_launcher/url_launcher.dart';

abstract mixin class AppInfoViewModel {
  Future<bool> launchUrl(String url) {
    return UrlLauncher.launchUrl(
      url: url,
      mode: UrlLaunchMode.externalApplication,
    );
  }

  Future<bool> launchPrivacyPolicy() {
    if (Platform.isIOS) {
      final url = EnvConfig.getEnv(EnvConstants.privacyPolicyAppStoreUrl, '');
      return launchUrl(url);
    } else {
      final url = EnvConfig.getEnv(EnvConstants.privacyPolicyAndroidUrl, '');
      return launchUrl(url);
    }
  }

  Future<bool> rateApp() async {
    final url = await getAppUrl();
    if (url.isEmpty) return false;
    return launchUrl(url);
  }

  Future<bool> seeOtherApps() async {
    final url = await getDeveloperUrl();
    if (url.isEmpty) return false;
    return launchUrl(url);
  }

  Future<String> getDeveloperUrl() async {
    final source = await StoreChecker.getSource;
    switch (source) {
      case Source.IS_INSTALLED_FROM_PLAY_STORE:
        return EnvConfig.getEnv(EnvConstants.playStoreDeveloperUrl, '');
      case Source.IS_INSTALLED_FROM_APP_STORE:
        return EnvConfig.getEnv(EnvConstants.appStoreDeveloperUrl, '');
      case Source.IS_INSTALLED_FROM_RU_STORE:
        return EnvConfig.getEnv<String>(EnvConstants.ruStoreDeveloperUrl, '');
      default:
        return '';
    }
  }

  Future<String> getAppUrl() async {
    final source = await StoreChecker.getSource;
    switch (source) {
      case Source.IS_INSTALLED_FROM_PLAY_STORE:
        return EnvConfig.getEnv(EnvConstants.playStoreAppUrl, '');
      case Source.IS_INSTALLED_FROM_APP_STORE:
        return EnvConfig.getEnv(EnvConstants.appStoreAppUrl, '');
      case Source.IS_INSTALLED_FROM_RU_STORE:
        return EnvConfig.getEnv(EnvConstants.ruStoreAppUrl, '');
      default:
        return '';
    }
  }

  Future<bool> launcEmail() {
    final email = EnvConfig.getEnv(EnvConstants.developerEmail, '');
    return UrlLauncher.launchEmail(email);
  }
}
