import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_checker/store_checker.dart';
import 'package:stun_kit/config/config.dart';
import 'package:stun_kit/data/services/app_service.dart';

/// Реализация сервиса приложения для получения информации о приложении.
///
/// Класс [AppServiceImpl] предоставляет методы для получения версии приложения,
/// URL страницы разработчика, URL приложения, URL политики конфиденциальности и email разработчика.
/// Реализация учитывает источник установки приложения (Play Store, App Store, RU Store) и платформу (iOS/Android/Web).
class AppServiceImpl implements AppService {
  /// Асинхронно получает версию приложения.
  ///
  /// Использует пакет [PackageInfo] для извлечения информации о версии и номере сборки приложения.
  /// Возвращает строку в формате `версия+номер сборки`.
  @override
  Future<String> fetchVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;
    return '$version+$buildNumber';
  }

  /// Асинхронно получает URL страницы разработчика приложения.
  ///
  /// Если приложение запущено в браузере (Web), возвращается пустая строка.
  /// Для мобильных платформ используется [StoreChecker] для определения источника установки
  /// и получения соответствующего URL разработчика из переменных окружения.
  @override
  Future<String> fetchDeveloperUrl() async {
    if (kIsWeb) return '';

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

  /// Асинхронно получает URL страницы приложения.
  ///
  /// Если приложение запущено в браузере (Web), возвращается пустая строка.
  /// Определяет источник установки приложения с помощью [StoreChecker]
  /// и возвращает соответствующий URL приложения из переменных окружения.
  @override
  Future<String> fetchAppUrl() async {
    if (kIsWeb) return '';

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

  /// Асинхронно получает URL политики конфиденциальности приложения.
  ///
  /// Если приложение запущено в браузере (Web), возвращается пустая строка.
  /// Для платформы iOS возвращается URL политики конфиденциальности для App Store,
  /// для остальных платформ — URL для Android.
  @override
  Future<String> fetchPrivacyPolicyUrl() async {
    if (kIsWeb) return '';

    if (Platform.isIOS) {
      return EnvConfig.getEnv(EnvConstants.privacyPolicyAppStoreUrl, '');
    } else {
      return EnvConfig.getEnv(EnvConstants.privacyPolicyAndroidUrl, '');
    }
  }

  /// Асинхронно получает email разработчика приложения.
  ///
  /// Возвращает значение из переменных окружения, соответствующее email разработчика.
  @override
  Future<String> fetchDeveloperEmail() async {
    return EnvConfig.getEnv(EnvConstants.developerEmail, '');
  }
}
