import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/design_system.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/premium_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _buildProfileHeader(context, user?.name ?? 'User', user?.phone ?? 'N/A'),
            SizedBox(height: AppSpacing.xxl),

            // Account Section
            PremiumCard(
              padding: EdgeInsets.zero,
              hasShadow: true,
              isElevated: true,
              child: Column(
                children: [

                  _buildActionItem(
                    icon: Icons.emoji_events,
                    iconColor: AppColors.accent,
                    title: 'Achievements',
                    subtitle: 'View your badges and milestones',
                    onTap: () => context.push('/achievements'),
                  ),
                  Divider(height: 1, indent: 64),
                  _buildActionItem(
                    icon: Icons.history,
                    iconColor: AppColors.primary,
                    title: 'Transaction History',
                    subtitle: 'View all your past scans and withdrawals',
                    onTap: () => context.go('/wallet'),
                  ),
                  Divider(height: 1, indent: 64),
                  _buildActionItem(
                    icon: Icons.notifications_outlined,
                    iconColor: AppColors.secondary,
                    title: 'Notifications',
                    subtitle: 'View your alerts and messages',
                    onTap: () => context.push('/notifications'),
                  ),
                  Divider(height: 1, indent: 64),
                  _buildActionItem(
                    icon: Icons.card_giftcard,
                    iconColor: AppColors.success,
                    title: 'Refer & Earn',
                    subtitle: 'Code: ${user?.referralCode ?? "BOTAL50"}',
                    onTap: () => context.push('/refer-and-earn'),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Preferences Section
            PremiumCard(
              padding: EdgeInsets.zero,
              hasShadow: true,
              isElevated: true,
              child: Column(
                children: [
                  _buildActionItem(
                    icon: Icons.notifications_active_outlined,
                    iconColor: AppColors.primary,
                    title: 'Notification Settings',
                    subtitle: 'Manage alert preferences',
                    onTap: () => context.push('/notification-settings'),
                  ),
/*
                  Divider(height: 1, indent: 64),
                  _buildActionItem(
                    icon: Icons.palette_outlined,
                    iconColor: Colors.purple,
                    title: 'Theme',
                    subtitle: 'Light, Dark, or System default',
                    onTap: () => context.push('/theme-settings'),
                  ),
                  Divider(height: 1, indent: 64),
                  _buildActionItem(
                    icon: Icons.language,
                    iconColor: AppColors.secondary,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () => context.push('/language-settings'),
                  ),
                  Divider(height: 1, indent: 64),
                  _buildActionItem(
                    icon: Icons.security,
                    iconColor: Colors.indigo,
                    title: 'Security',
                    subtitle: 'Biometrics & password',
                    onTap: () => context.push('/security'),
                  ),
                  */
                  Divider(height: 1, indent: 64),
                  _buildActionItem(
                    icon: Icons.app_settings_alt_outlined,
                    iconColor: Colors.teal,
                    title: 'Permissions',
                    subtitle: 'Camera, Gallery, Notifications',
                    onTap: () => context.push('/permissions'),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Support & Legal Section
            PremiumCard(
              padding: EdgeInsets.zero,
              hasShadow: true,
              isElevated: true,
              child: Column(
                children: [
                  _buildActionItem(
                    icon: Icons.help_outline,
                    iconColor: Colors.blue,
                    title: 'Help & Support',
                    subtitle: 'FAQs and contact us',
                    onTap: () => context.push('/help-support'),
                  ),
                  Divider(height: 1, indent: 64),
                  _buildActionItem(
                    icon: Icons.privacy_tip_outlined,
                    iconColor: Colors.grey,
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your data',
                    onTap: () => context.push('/privacy-policy'),
                  ),
                  Divider(height: 1, indent: 64),
                  _buildActionItem(
                    icon: Icons.description_outlined,
                    iconColor: Colors.grey,
                    title: 'Terms & Conditions',
                    subtitle: 'Usage policies',
                    onTap: () => context.push('/terms-conditions'),
                  ),
                  Divider(height: 1, indent: 64),
                  _buildActionItem(
                    icon: Icons.info_outline,
                    iconColor: AppColors.primary,
                    title: 'About BotalSePaisa',
                    subtitle: 'Version 1.0.0',
                    onTap: () => context.push('/about-app'),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Logout
            PremiumCard(
              padding: EdgeInsets.zero,
              hasShadow: true,
              isElevated: true,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.logout, color: AppColors.error),
                ),
                title: Text('Logout',
                    style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold)),
                trailing: Icon(Icons.chevron_right,
                    color: AppColors.textSecondary),
                onTap: () {
                  ref.read(authControllerProvider.notifier).logout();
                  context.go('/login');
                },
              ),
            ),

            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, String name, String phone) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppGradients.primary,
            boxShadow: AppShadows.primaryGlow,
          ),
          padding: const EdgeInsets.all(3),
          child: const CircleAvatar(
            backgroundColor: AppColors.surface,
            child: Icon(Icons.person, size: 50, color: AppColors.primary),
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(name,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(phone,
            style: TextStyle(
                fontSize: 14, color: AppColors.textSecondary)),
        SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: () => context.push('/edit-profile'),
          icon: Icon(Icons.edit, size: 16),
          label: Text('Edit Profile'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.border, width: 2),
            shape: RoundedRectangleBorder(
                borderRadius: AppRadius.xlRadius),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: TextStyle(
              fontSize: 12, color: AppColors.textSecondary)),
      trailing: Icon(Icons.chevron_right,
          color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
