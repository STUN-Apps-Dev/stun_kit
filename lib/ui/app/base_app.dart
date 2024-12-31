import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:stun_kit/ui/navigation/navigation.dart';

class BaseApp extends StatelessWidget {
  final List<Locale> supportedLocales;

  const BaseApp({
    super.key,
    this.supportedLocales = const [Locale('ru', 'RU')],
  });

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp.router(
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
        builder: (context, child) {
          return _AppObserver(
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class _AppObserver extends StatelessWidget {
  final Widget child;

  const _AppObserver({required this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: child,
    );
  }
}
