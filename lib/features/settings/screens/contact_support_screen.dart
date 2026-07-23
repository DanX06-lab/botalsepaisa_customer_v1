import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';
import '../../../shared/widgets/premium_card.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  Future<void> _launchUrl(BuildContext context, String urlString, String fallbackMessage) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(fallbackMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _settingsHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: AppRadius.smRadius,
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        SizedBox(width: AppSpacing.sm),
        Text(title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _settingsTile({
    required String title,
    String? subtitle,
    required IconData icon,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final color = iconColor ?? AppColors.primary;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: TextStyle(
                  fontSize: 12, color: AppColors.textSecondary))
          : null,
      trailing: trailing ??
          Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Support'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _settingsTile(
                  title: 'Email Us',
                  subtitle: 'support@botalsepaisa.com',
                  icon: Icons.email_outlined,
                  iconColor: AppColors.secondary,
                  trailing: Icon(Icons.open_in_new, size: 18,
                      color: AppColors.textSecondary),
                  onTap: () => _launchUrl(
                    context, 
                    'mailto:support@botalsepaisa.com',
                    'No email client found',
                  ),
                ),
                Divider(height: 1, color: AppColors.border),
                _settingsTile(
                  title: 'Call Us',
                  subtitle: '+91 98765 43210',
                  icon: Icons.phone_outlined,
                  iconColor: AppColors.success,
                  trailing: Icon(Icons.open_in_new, size: 18,
                      color: AppColors.textSecondary),
                  onTap: () => _launchUrl(
                    context,
                    'tel:+919876543210',
                    'No dialer application found',
                  ),
                ),
                Divider(height: 1, color: AppColors.border),
                _settingsTile(
                  title: 'WhatsApp',
                  subtitle: '+91 98765 43210',
                  icon: Icons.chat_bubble_outline,
                  iconColor: const Color(0xFF25D366),
                  trailing: Icon(Icons.open_in_new, size: 18,
                      color: AppColors.textSecondary),
                  onTap: () => _launchUrl(
                    context,
                    'https://wa.me/919876543210',
                    'WhatsApp is not installed',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          PremiumCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _settingsHeader('Office Hours', Icons.schedule),
                SizedBox(height: AppSpacing.md),
                Text('Monday â€“ Saturday: 9:00 AM â€“ 6:00 PM',
                    style: TextStyle(fontSize: 14)),
                Text('Sunday & Holidays: Closed',
                    style: TextStyle(
                        fontSize: 14, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
