import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/design_system.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Give minimum 2 seconds for splash animation
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = ref.read(authControllerProvider).value;
    if (user != null) {
      context.go('/home');
    } else {
      context.go('/onboarding'); // Or /login if onboarding already seen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.primary,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.soft,
                ),
                child: Icon(
                  Icons.recycling,
                  size: 64,
                  color: AppColors.primary,
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
              SizedBox(height: AppSpacing.xl),
              Text(
                'BotalSePaisa',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ).animate().slideY(begin: 0.5, end: 0, duration: 600.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}
