import 'package:flutter/material.dart';

/// A centralized accessibility utility for Humble Time
/// Includes font scaling, motion sensitivity, and focus styling.
class AccessibilityToolkit {
  final BuildContext context;

  AccessibilityToolkit(this.context);

  /// 🧠 Font scaling based on system/user preferences
  double scaledFontSize(double baseSize) {
    final scaler = MediaQuery.textScalerOf(context);
    return scaler.scale(baseSize);
  }

  /// 🌀 Determines if animations should be disabled
  bool get animationsDisabled =>
      MediaQuery.of(context).disableAnimations;

  /// 🧭 Generates custom focus ring decoration
  InputDecoration getFocusRingDecoration({
    required String label,
    required bool hasFocus,
  }) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: hasFocus ? Colors.blueAccent : Colors.grey,
          width: 2.0,
        ),
      ),
    );
  }
}
