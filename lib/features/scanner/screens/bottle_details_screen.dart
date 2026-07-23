import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/design_system.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/primary_button.dart';

class BottleDetailsScreen extends StatelessWidget {
  final String shopId;
  final String barcode;

  const BottleDetailsScreen({
    super.key,
    required this.shopId,
    required this.barcode,
  });

  static const Map<String, Map<String, String>> _mockBottles = {
    'PET001': {
      'name': 'PET Bottle 500ml',
      'brand': 'AquaFresh',
      'reward': '10.00',
      'type': 'PET'
    },
    'GLASS001': {
      'name': 'Glass Bottle 750ml',
      'brand': 'GreenDrink',
      'reward': '15.00',
      'type': 'Glass'
    },
    'ALU001': {
      'name': 'Aluminium Can 330ml',
      'brand': 'CoolSip',
      'reward': '8.00',
      'type': 'Aluminium'
    },
  };

  Map<String, String> get _bottleData =>
      _mockBottles[barcode] ??
      {
        'name': 'Recyclable Bottle',
        'brand': 'Unknown Brand',
        'reward': '5.00',
        'type': 'Other',
      };

  Color _typeColor(String type) {
    switch (type) {
      case 'PET':
        return AppColors.success;
      case 'Glass':
        return AppColors.primary;
      case 'Aluminium':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottle = _bottleData;
    final rewardAmount = double.tryParse(bottle['reward'] ?? '5.00') ?? 5.00;
    final typeColor = _typeColor(bottle['type'] ?? 'Other');
    final timestamp = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
    final displayShopId =
        shopId.length > 12 ? '${shopId.substring(0, 12)}...' : shopId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bottle Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero icon
            PremiumCard(
              gradient: AppGradients.reward,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.recycling,
                        size: 48, color: AppColors.background),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Bottle Scanned!',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Please confirm the details below',
                    style: TextStyle(color: AppColors.surfaceElevated, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            // Bottle Information
            PremiumCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              isElevated: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bottle Information',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary)),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    bottle['name'] ?? 'Unknown Bottle',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Brand: ${bottle['brand']}',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.15),
                          borderRadius: AppRadius.xlRadius,
                          border: Border.all(
                              color: typeColor.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          bottle['type'] ?? 'Other',
                          style: TextStyle(
                              color: typeColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        barcode,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),

            // Your Reward
            PremiumCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              isElevated: true,
              child: Column(
                children: [
                  Text('You Will Earn',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 14)),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    '+₹ ${rewardAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary, // Gold for reward
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Credited to your wallet instantly',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),

            // Submission Details
            PremiumCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              isElevated: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Submission Details',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary)),
                  SizedBox(height: AppSpacing.md),
                  _detailRow(
                      Icons.location_on_outlined, 'Collection Point', displayShopId),
                  SizedBox(height: AppSpacing.sm),
                  _detailRow(Icons.schedule, 'Timestamp', timestamp),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            // Confirm button
            PrimaryButton(
              text: 'Confirm Submission',
              icon: Icons.check_circle_outline,
              onPressed: () {
                context.go('/reward-success', extra: {
                  'amount': rewardAmount,
                  'code': barcode,
                });
              },
            ),
            SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary),
              child: Text('Cancel'),
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }
}
