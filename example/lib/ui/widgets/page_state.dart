import 'package:flutter/material.dart';

class PageStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final void Function()? onRefresh;
  final Widget? child;
  final Widget? button;

  const PageStateWidget({
    super.key,
    this.child,
    this.title = '',
    this.description = '',
    this.onRefresh,
    this.button,
  });

  const PageStateWidget.loading({
    super.key,
    this.title = 'Загрузка данных...',
    this.description = '',
    this.onRefresh,
    this.child = const CircularProgressIndicator(strokeWidth: 3),
    this.button,
  });

  const PageStateWidget.noInternet({
    super.key,
    this.title = 'Отсутствует соединение\nс интернетом',
    this.description = '',
    this.onRefresh,
    this.child = const Text('📡', style: TextStyle(fontSize: 48)),
    this.button,
  });

  const PageStateWidget.server({
    super.key,
    this.title = 'Сервер не отвечает',
    this.description =
        'Возможно у вас включен VPN. Отключите его при использовании приложения. Если ошибка повторяется, обратитесь в службу поддержки.',
    this.onRefresh,
    this.child = const Text('🔌', style: TextStyle(fontSize: 48)),
    this.button,
  });

  const PageStateWidget.badRequest({
    super.key,
    this.title = 'Страница не найдена\n(Ошибка 404)',
    this.description = '',
    this.onRefresh,
    this.child = const Text('🚧', style: TextStyle(fontSize: 48)),
    this.button,
  });

  const PageStateWidget.empty({
    super.key,
    this.title = 'Ничего не найдено',
    this.description = '',
    this.onRefresh,
    this.child = const Text('🔦', style: TextStyle(fontSize: 48)),
    this.button,
  });

  const PageStateWidget.download({
    super.key,
    this.title = 'Ожидайте...\nСейчас скачается',
    this.description = '',
    this.onRefresh,
    this.child = const Text('📥', style: TextStyle(fontSize: 48)),
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    final child = this.child;
    final button = this.button;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            if (child != null) ...[
              child,
              const SizedBox(height: 16),
            ],
            if (title.isNotEmpty) ...[
              // Text(
              //   title,
              //   style: context.theme.h3,
              //   textAlign: TextAlign.center,
              // ),
            ],
            if (description.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                description,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRefresh != null) ...[
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: onRefresh,
                child: const Text('Обновить'),
              ),
            ],
            if (button != null) ...[
              const SizedBox(height: 24),
              button,
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
