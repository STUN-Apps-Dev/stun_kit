import 'package:flutter/material.dart';
import 'package:stun_kit/ui/themes/extensions/theme_extensions.dart';

extension TextStyleExt on TextStyle {
  TextStyle fromTheme({
    required final BuildContext context,
    required final Color light,
    required final Color dark,
  }) {
    return copyWith(color: context.isDark ? dark : light);
  }
}
