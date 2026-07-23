import 'package:flutter/material.dart';

/// BotalSePaisa Brand Color Palette – Dark Premium Theme
/// Single source of truth. No hardcoded colors anywhere else.
class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────────────────────────────────
  /// Midnight Navy – primary app background
  static const Color background = Color(0xFF08111F);

  /// Surface – cards, containers
  static const Color surface = Color(0xFF111C30);

  /// Elevated Surface – dialogs, highlighted cards, analytics
  static const Color surfaceElevated = Color(0xFF18253D);

  // ── Brand ────────────────────────────────────────────────────────────────
  /// Golden Yellow – primary brand color
  static const Color primary = Color(0xFFF5A300);

  /// Lighter Gold – gradient end
  static const Color primaryLight = Color(0xFFFFC94D);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8C4D6);
  static const Color textDisabled  = Color(0xFF6E7A8F);

  // ── Status ───────────────────────────────────────────────────────────────
  /// Use ONLY for rewards, success, verified, completed
  static const Color success = Color(0xFF3DDC84);
  static const Color error   = Color(0xFFFF5A5F);
  static const Color warning = Color(0xFFFFB547);

  // ── Borders & Dividers ───────────────────────────────────────────────────
  static const Color border  = Color(0xFF30415F);
  static const Color divider = Color(0xFF24334F);

  // ── Legacy aliases (keeps old code compiling) ─────────────────────────
  static const Color backgroundLight    = background;
  static const Color backgroundDark     = background;
  static const Color surfaceLight       = surface;
  static const Color surfaceDark        = surface;
  static const Color textPrimaryLight   = textPrimary;
  static const Color textPrimaryDark    = textPrimary;
  static const Color textSecondaryLight = textSecondary;
  static const Color textSecondaryDark  = textSecondary;
  static const Color borderLight        = border;
  static const Color borderDark         = border;
  static const Color primaryDark        = Color(0xFFD98C00); // darker gold for press states
  static const Color secondary          = primaryLight;
  static const Color accent             = primary;
  static const Color accentLight        = primaryLight;
}
