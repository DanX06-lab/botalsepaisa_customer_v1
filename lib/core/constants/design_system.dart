import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppSpacing {
  AppSpacing._();
  
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppRadius {
  AppRadius._();
  
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 18.0; // Increased for premium feel
  static const double xl = 20.0; // Standard for cards
  static const double xxl = 24.0;
  
  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);
}

class AppShadows {
  AppShadows._();
  
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15), // Darker shadow for dark theme
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];
      
  static List<BoxShadow> get medium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25), // Darker shadow for dark theme
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ];
      
  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.25), // Subtle gold glow
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
}

class AppAnimations {
  AppAnimations._();
  
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  
  static const Curve defaultCurve = Curves.easeInOut;
}
