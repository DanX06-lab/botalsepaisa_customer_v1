import 'package:flutter/material.dart';
import 'app_colors.dart';

/// BotalSePaisa Brand Gradients – use sparingly and only where appropriate.
class AppGradients {
  AppGradients._();

  /// Primary brand gradient: Gold → Light Gold (buttons, CTAs, wallet highlights)
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Reward / celebration gradient
  static const LinearGradient reward = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Wallet card gradient
  static const LinearGradient wallet = LinearGradient(
    colors: [Color(0xFF18253D), Color(0xFF0F1A2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Background gradient for splash / hero sections
  static const LinearGradient background = LinearGradient(
    colors: [Color(0xFF08111F), Color(0xFF111C30)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
