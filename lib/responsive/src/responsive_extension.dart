import 'package:flutter/material.dart';
import 'package:stun_kit/responsive/src/device_type.dart';
import 'package:stun_kit/responsive/src/responsive_config.dart';

/// Расширение для [BuildContext], предоставляющее удобные геттеры для работы
/// с адаптивным дизайном и получения информации о размерах экрана.
extension ResponsiveExtension on BuildContext {
  /// Определяет тип устройства (мобильное, планшет, десктоп)
  /// на основе текущей ширины экрана.
  DeviceType get deviceType {
    final width = MediaQuery.of(this).size.width;

    if (width <= ResponsiveConfig.mobileMaxWidth) {
      return DeviceType.mobile;
    } else if (width <= ResponsiveConfig.tabletMaxWidth) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Возвращает `true`, если устройство является мобильным.
  bool get isMobile => deviceType == DeviceType.mobile;

  /// Возвращает `true`, если устройство является планшетом.
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Возвращает `true`, если устройство является десктопом.
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Получает ширину экрана устройства.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Получает высоту экрана устройства.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Определяет ширину контейнера для контента в зависимости от типа устройства.
  /// Для мобильных устройств контейнер занимает всю ширину экрана.
  /// Для планшетов и десктопов используются фиксированные значения из [ResponsiveConfig].
  double get containerWidth {
    final deviceType = this.deviceType;

    if (deviceType == DeviceType.mobile) {
      return screenWidth;
    } else if (deviceType == DeviceType.tablet) {
      return ResponsiveConfig.tabletContainerWidth;
    } else {
      return ResponsiveConfig.desktopContainerWidth;
    }
  }
}
