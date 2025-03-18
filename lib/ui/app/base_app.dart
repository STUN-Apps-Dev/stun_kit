import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:stun_kit/ui/router/router.dart';

class BaseApp extends StatelessWidget {
  final List<Locale> supportedLocales;
  final String title;
  final ThemeMode? themeMode;
  final ThemeData? theme;
  final ThemeData? darkTheme;

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
      routerConfig: AppRouter.instance.config(
        navigatorObservers: () => [LoggerObserver()],
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: theme,
      darkTheme: darkTheme,
      title: title,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
      builder: (context, child) {
        return _AppObserver(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class _AppObserver extends StatelessWidget {
  final Widget child;

  const _AppObserver({required this.child});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: child,
      ),
    );
  }
}
