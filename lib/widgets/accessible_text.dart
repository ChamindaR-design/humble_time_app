import 'package:flutter/material.dart';
import 'package:humble_time_app/core/utils/accessibility_toolkit.dart';

class AccessibleText extends StatelessWidget {
  final String text;
  final double baseFontSize;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AccessibleText({
    super.key, // 👈 updated!
    required this.text,
    this.baseFontSize = 16,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final toolkit = AccessibilityToolkit(context);
    final scaledSize = toolkit.scaledFontSize(baseFontSize);

    return Text(
      text,
      style: style?.copyWith(fontSize: scaledSize) ??
          TextStyle(fontSize: scaledSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
