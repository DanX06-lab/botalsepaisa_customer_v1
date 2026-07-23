import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/design_system.dart';
import '../../../shared/widgets/primary_button.dart';

class RewardSuccessScreen extends StatefulWidget {
  final double amount;
  final String code;

  const RewardSuccessScreen({super.key, required this.amount, required this.code});

  @override
  State<RewardSuccessScreen> createState() => _RewardSuccessScreenState();
}

class _RewardSuccessScreenState extends State<RewardSuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppGradients.reward,
                      boxShadow: AppShadows.primaryGlow,
                    ),
                    child: Icon(Icons.emoji_events, color: Colors.white, size: 64),
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  Text(
                    'Bottle Recycled!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Barcode: ${widget.code}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: AppRadius.xlRadius,
                      border: Border.all(color: AppColors.border, width: 0.5),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'You Earned',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          '+₹ ${widget.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary, // Gold for reward text
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: 'View Wallet',
                    icon: Icons.account_balance_wallet,
                    onPressed: () {
                      context.go('/wallet');
                    },
                  ),
                  SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: () {
                      context.go('/home');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // fall straight down
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.2,
              colors: [
                AppColors.primary,
                AppColors.secondary,
                AppColors.accent,
                AppColors.success,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
