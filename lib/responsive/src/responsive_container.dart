// Импорт базовых виджетов Flutter.
import 'package:flutter/material.dart';
// Импорт адаптивных расширений, предоставляющих геттеры для работы с адаптивным дизайном.
import 'package:stun_kit/responsive/responsive.dart';

/// Виджет [ResponsiveContainer] обеспечивает адаптивное отображение содержимого.
/// Он центрирует вложенный виджет и устанавливает максимальную ширину контейнера,
/// которая может быть задана явно или определяться автоматически по типу устройства.
class ResponsiveContainer extends StatelessWidget {
  /// Виджет, который будет отображаться внутри контейнера.
  final Widget child;

  /// Отступы вокруг контейнера. Может быть null.
  final EdgeInsets? margin;

  /// Максимальная ширина контейнера.
  /// Если не указана, используется значение, заданное в адаптивной конфигурации
  /// (через [context.containerWidth]).
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.margin,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = this.maxWidth ?? context.containerWidth;
    return Center(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: maxWidth),
        margin: margin,
        child: child,
      ),
    );
  }
}
