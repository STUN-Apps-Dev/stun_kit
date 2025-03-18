import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:stun_kit/ui/router/router.dart';

/// Основное приложение, настраивающее MaterialApp с поддержкой роутинга, локализаций и тем.
///
/// [BaseApp] использует [MaterialApp.router] для интеграции с системой навигации,
/// предоставляемой [AppRouter]. Также задаёт поддержку локализаций и тем, а также
/// определяет глобальные настройки для обработки горячих клавиш и отображения тостов.
class BaseApp extends StatelessWidget {
  /// Список поддерживаемых локалей для приложения.
  final List<Locale> supportedLocales;

  /// Заголовок приложения, отображаемый в системных окнах (например, в переключателе задач).
  final String title;

  /// Режим темы: light, dark или системный.
  final ThemeMode? themeMode;

  /// Данные темы для светлого режима.
  final ThemeData? theme;

  /// Данные темы для тёмного режима.
  final ThemeData? darkTheme;

  /// Конструктор [BaseApp].
  ///
  /// По умолчанию поддерживается только русский язык (ru_RU).
  const BaseApp({
    super.key,
    this.supportedLocales = const [Locale('ru', 'RU')],
    this.title = '',
    this.themeMode,
    this.theme,
    this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Настройка роутера с использованием экземпляра AppRouter
      routerConfig: AppRouter.instance.config(
        // Логирование навигационных событий через LoggerObserver
        navigatorObservers: () => [LoggerObserver()],
      ),
      // Делегаты локализации для Material, Widgets и Cupertino
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Список поддерживаемых локалей, переданный через конструктор
      supportedLocales: supportedLocales,
      // Отключение баннера отладки
      debugShowCheckedModeBanner: false,
      // Конфигурация темы приложения
      themeMode: themeMode,
      theme: theme,
      darkTheme: darkTheme,
      // Заголовок приложения
      title: title,
      // Определение горячих клавиш, например, пробел для активации (ActivateIntent)
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
      // Оборачиваем дочерние виджеты в _AppObserver для поддержки OKToast и настройки MediaQuery
      builder: (context, child) {
        return _AppObserver(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

/// Виджет-обёртка для приложения, добавляющий поддержку тостов и настройки MediaQuery.
///
/// [_AppObserver] оборачивает переданный [child] в [OKToast] для отображения уведомлений
/// и в [MediaQuery] с переопределённым масштабированием текста, что обеспечивает единообразное
/// отображение текста в приложении.
class _AppObserver extends StatelessWidget {
  /// Дочерний виджет, который необходимо отобразить.
  final Widget child;

  /// Конструктор [_AppObserver].
  const _AppObserver({required this.child});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      // Оборачиваем дочерний виджет в MediaQuery для установки фиксированного масштабирования текста
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          // Фиксируем масштабирование текста на 1.0 для обеспечения консистентности UI
          textScaler: const TextScaler.linear(1.0),
        ),
        child: child,
      ),
    );
  }
}
