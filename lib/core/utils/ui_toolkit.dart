import 'package:flutter/material.dart';

class UIToolkit {
  /// 📏 Scales font size using nonlinear text scaling (Flutter 3.13+)
  double scaledFontSize(BuildContext context, double baseSize) {
    return MediaQuery.of(context).textScaler.scale(baseSize);
  }

  /// 🧘 Standard vertical spacing based on system text scaling
  SizedBox verticalSpace(BuildContext context, double units) {
    final double spacing = scaledFontSize(context, units);
    return SizedBox(height: spacing);
  }

  /// ⬅️ Padding wrapper for consistent horizontal layout
  EdgeInsets horizontalPadding(BuildContext context, double units) {
    final double padding = scaledFontSize(context, units);
    return EdgeInsets.symmetric(horizontal: padding);
  }

  /// 🌗 Example color palette override if needed
  Color softBackground(BuildContext context) {
  final theme = Theme.of(context);
  return theme.brightness == Brightness.dark
      ? theme.colorScheme.surfaceContainerHighest
      : theme.colorScheme.surface.withAlpha(242);
}
}
