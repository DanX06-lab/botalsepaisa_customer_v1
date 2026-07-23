import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/design_system.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/premium_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppGradients.primary,
                boxShadow: AppShadows.primaryGlow,
              ),
              padding: const EdgeInsets.all(2),
              child: const CircleAvatar(
                backgroundColor: AppColors.surface,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${user?.name.split(' ').first ?? "User"} 👋',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Ready to recycle?',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: IconButton(
              icon: Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
              onPressed: () {
                context.push('/notifications');
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surfaceElevated,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildWalletCard(context),
            SizedBox(height: AppSpacing.xl),
            _buildQuickScanAction(context),
            SizedBox(height: AppSpacing.xl),
            _buildEnvironmentalImpact(),
            SizedBox(height: AppSpacing.xl),
            _buildRecentTransactions(context),
            SizedBox(height: 100), // padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return PremiumCard(
      gradient: AppGradients.wallet,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Total Wallet Balance',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: AppRadius.smRadius,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, color: AppColors.success, size: 14),
                    SizedBox(width: 4),
                    Flexible(child: Text('+12% this month', style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            '₹ 450.00',
            style: TextStyle(
              color: AppColors.primary, // Gold Balance
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildWalletStat('Today\'s Earnings', '+₹ 25.00', AppColors.success)),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildWalletStat('Pending Transfer', '₹ 0.00', AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletStat(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickScanAction(BuildContext context) {
    return PremiumCard(
      onTap: () => context.go('/scanner'),
      padding: EdgeInsets.zero,
      hasShadow: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.xlRadius,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          gradient: AppGradients.primary,
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
                boxShadow: AppShadows.soft,
              ),
              child: Icon(Icons.qr_code_scanner, color: AppColors.primary, size: 28),
            ),
            SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Recycling',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Scan bottle barcode for rewards',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.surface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentalImpact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Impact',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildImpactCard(
                icon: Icons.recycling,
                value: '124',
                label: 'Bottles',
                color: AppColors.primary,
                bgColor: AppColors.surfaceElevated,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildImpactCard(
                icon: Icons.energy_savings_leaf,
                value: '4.2',
                label: 'kg CO2 Saved',
                color: AppColors.success,
                bgColor: AppColors.surfaceElevated,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImpactCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return PremiumCard(
      padding: EdgeInsets.zero,
      hasShadow: false,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.xlRadius,
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: AppSpacing.md),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.go('/wallet'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: TextStyle(fontWeight: FontWeight.w600),
              ),
              child: Text('View All'),
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            return PremiumCard(
              padding: EdgeInsets.zero,
              hasShadow: false,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_downward, color: AppColors.success, size: 20),
                ),
                title: Text('Bottle Reward', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('Today, 10:30 AM', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                trailing: Text(
                  '+₹ 10.00',
                  style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
