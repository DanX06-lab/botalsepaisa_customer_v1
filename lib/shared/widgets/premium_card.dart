import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/design_system.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final bool hasShadow;
  final bool isElevated; // true uses surfaceElevated

  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.gradient,
    this.onTap,
    this.hasShadow = true,
    this.isElevated = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: gradient == null 
              ? (isElevated ? AppColors.surfaceElevated : AppColors.surface) 
              : null,
          gradient: gradient,
          borderRadius: AppRadius.xlRadius,
          border: gradient == null
              ? Border.all(color: AppColors.border, width: 0.5)
              : null,
          boxShadow: hasShadow ? AppShadows.soft : null,
        ),
        child: child,
      ),
    );
  }
}
