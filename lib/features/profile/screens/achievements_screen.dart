import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';
import '../../../shared/widgets/premium_card.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock achievements data
    final List<Map<String, dynamic>> achievements = [
      {
        'title': 'First Scan',
        'description': 'Recycle your first bottle.',
        'icon': Icons.qr_code_scanner,
        'unlocked': true,
        'date': '12 Jan 2024',
      },
      {
        'title': 'Eco Beginner',
        'description': 'Recycle 10 bottles.',
        'icon': Icons.eco,
        'unlocked': true,
        'date': '15 Jan 2024',
      },
      {
        'title': 'Tree Hugger',
        'description': 'Recycle 50 bottles.',
        'icon': Icons.park,
        'unlocked': false,
        'progress': 0.8, // 40/50
      },
      {
        'title': 'Referral Master',
        'description': 'Refer 5 friends.',
        'icon': Icons.people,
        'unlocked': false,
        'progress': 0.4, // 2/5
      },
      {
        'title': 'Wallet Whiz',
        'description': 'Withdraw your first reward.',
        'icon': Icons.account_balance_wallet,
        'unlocked': true,
        'date': '20 Jan 2024',
      },
      {
        'title': 'Recycling Hero',
        'description': 'Reach Level 10.',
        'icon': Icons.military_tech,
        'unlocked': false,
        'progress': 0.3, // Level 3/10
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.85,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          final bool isUnlocked = achievement['unlocked'];

          return PremiumCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isUnlocked ? AppColors.primary : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    achievement['icon'],
                    size: 32,
                    color: isUnlocked ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  achievement['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Expanded(
                  child: Text(
                    achievement['description'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isUnlocked)
                  Text(
                    'Unlocked ${achievement['date']}',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  LinearProgressIndicator(
                    value: achievement['progress'],
                    backgroundColor: AppColors.surface,
                    color: AppColors.primary,
                    minHeight: 4,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
