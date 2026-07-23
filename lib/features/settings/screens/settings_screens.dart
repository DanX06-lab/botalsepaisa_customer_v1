// All lightweight settings screens bundled into one file for organisation.
// Each screen is its own StatelessWidget following the premium design system.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';
import '../../../shared/widgets/premium_card.dart';

// â”€â”€â”€ Shared helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€



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

// â”€â”€â”€ 1. Notification Settings â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});
  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushEnabled = true;
  bool _rewardAlerts = true;
  bool _promoAlerts = false;
  bool _withdrawalAlerts = true;
  bool _weeklyReport = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Notification Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  value: _pushEnabled,
                  onChanged: (v) => setState(() => _pushEnabled = v),
                  title: Text('Push Notifications',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Enable or disable all notifications'),
                  activeThumbColor: AppColors.primary,
                ),
                Divider(
                    height: 1,
                    color: AppColors.border,
                    indent: AppSpacing.lg),
                SwitchListTile(
                  value: _rewardAlerts,
                  onChanged: _pushEnabled
                      ? (v) => setState(() => _rewardAlerts = v)
                      : null,
                  title: Text('Reward Alerts'),
                  subtitle: Text('When you earn from recycling'),
                  activeThumbColor: AppColors.primary,
                ),
                Divider(
                    height: 1,
                    color: AppColors.border,
                    indent: AppSpacing.lg),
                SwitchListTile(
                  value: _withdrawalAlerts,
                  onChanged: _pushEnabled
                      ? (v) => setState(() => _withdrawalAlerts = v)
                      : null,
                  title: Text('Withdrawal Alerts'),
                  subtitle: Text('When funds are transferred'),
                  activeThumbColor: AppColors.primary,
                ),
                Divider(
                    height: 1,
                    color: AppColors.border,
                    indent: AppSpacing.lg),
                SwitchListTile(
                  value: _promoAlerts,
                  onChanged: _pushEnabled
                      ? (v) => setState(() => _promoAlerts = v)
                      : null,
                  title: Text('Promotions & Offers'),
                  subtitle: Text('Special events and bonus rewards'),
                  activeThumbColor: AppColors.primary,
                ),
                Divider(
                    height: 1,
                    color: AppColors.border,
                    indent: AppSpacing.lg),
                SwitchListTile(
                  value: _weeklyReport,
                  onChanged: _pushEnabled
                      ? (v) => setState(() => _weeklyReport = v)
                      : null,
                  title: Text('Weekly Summary'),
                  subtitle: Text('Your recycling report every Monday'),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€ 2. Theme Settings â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});
  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  int _selectedTheme = 0; // 0=System, 1=Light, 2=Dark

  @override
  Widget build(BuildContext context) {
    final themes = [
      {'label': 'System Default', 'icon': Icons.brightness_auto, 'desc': 'Follow device theme'},
      {'label': 'Light Mode', 'icon': Icons.light_mode, 'desc': 'Always use light theme'},
      {'label': 'Dark Mode', 'icon': Icons.dark_mode, 'desc': 'Always use dark theme'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Theme'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(themes.length, (i) {
                final t = themes[i];
                final isSelected = _selectedTheme == i;
                return ListTile(
                  leading: Icon(t['icon'] as IconData,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary),
                  title: Text(t['label'] as String,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                  subtitle: Text(t['desc'] as String,
                      style: TextStyle(fontSize: 12)),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () => setState(() => _selectedTheme = i),
                );
              }),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Dark mode support is coming in the next release.',
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€ 3. Language Settings â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});
  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLang = 'English';

  @override
  Widget build(BuildContext context) {
    final langs = [
      {'name': 'English', 'native': 'English'},
      {'name': 'Hindi', 'native': 'à¤¹à¤¿à¤¨à¥à¤¦à¥€'},
      {'name': 'Bengali', 'native': 'à¦¬à¦¾à¦‚à¦²à¦¾'},
      {'name': 'Tamil', 'native': 'à®¤à®®à®¿à®´à¯'},
      {'name': 'Telugu', 'native': 'à°¤à±†à°²à±à°—à±'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Language'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: langs.map((l) {
                final isSelected = _selectedLang == l['name'];
                return ListTile(
                  title: Text(l['name'] as String,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(l['native'] as String,
                      style: TextStyle(fontSize: 13)),
                  trailing: isSelected
                      ? Icon(Icons.check_circle,
                          color: AppColors.primary)
                      : null,
                  onTap: () => setState(() => _selectedLang = l['name']!),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'More languages will be available soon.',
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€ 4. Privacy Policy â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          PremiumCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last Updated: January 2024',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                SizedBox(height: AppSpacing.lg),
                _policySection('Data Collection',
                    'We collect personal information such as your name, phone number, email, and location to provide our recycling reward services. We do not sell your data to third parties.'),
                _policySection('Data Use',
                    'Your data is used solely to process recycling rewards, facilitate payments, and improve our services. Analytics data is anonymized.'),
                _policySection('Data Security',
                    'We implement industry-standard encryption and security practices to protect your personal and payment data.'),
                _policySection('Your Rights',
                    'You can request access to, correction of, or deletion of your personal data at any time through our support team.'),
                _policySection('Cookies',
                    'Our mobile application does not use browser cookies. We use secure, encrypted local storage for session management.'),
                _policySection('Contact Us',
                    'For any privacy concerns, contact our Data Protection Officer at privacy@botalsepaisa.in'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _policySection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold)),
          SizedBox(height: AppSpacing.xs),
          Text(body,
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.6)),
        ],
      ),
    );
  }
}

// â”€â”€â”€ 5. Terms & Conditions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Terms & Conditions'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          PremiumCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Effective Date: January 2024',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                SizedBox(height: AppSpacing.lg),
                _termSection('1. Acceptance',
                    'By using BotalSePaisa, you agree to these terms and our Privacy Policy. If you do not agree, please discontinue use.'),
                _termSection('2. Eligibility',
                    'You must be at least 18 years old and a resident of India to use our services.'),
                _termSection('3. Rewards',
                    'Rewards are issued based on verified bottle recycling. BotalSePaisa reserves the right to adjust reward rates without prior notice.'),
                _termSection('4. Withdrawals',
                    'Minimum withdrawal amount is â‚¹500. Funds are transferred within 3-5 business days to your verified payment method.'),
                _termSection('5. Prohibited Activities',
                    'Any attempt to defraud or manipulate the reward system will result in immediate account termination.'),
                _termSection('6. Amendments',
                    'These terms may be updated periodically. Continued use after changes constitutes acceptance.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _termSection(String heading, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold)),
          SizedBox(height: AppSpacing.xs),
          Text(body,
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.6)),
        ],
      ),
    );
  }
}

// â”€â”€â”€ 6. Help & Support â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help & Support'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          PremiumCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(Icons.support_agent,
                      size: 64, color: AppColors.primary),
                ),
                SizedBox(height: AppSpacing.md),
                const Center(
                  child: Text('How can we help you?',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: AppSpacing.xs),
                const Center(
                  child: Text('Our team is available 9AM - 6PM, Mon-Sat',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _settingsTile(
                  title: 'FAQs',
                  subtitle: 'Frequently asked questions',
                  icon: Icons.quiz_outlined,
                  onTap: () => context.push('/faq'),
                ),
                Divider(height: 1, color: AppColors.border),
                _settingsTile(
                  title: 'Contact Support',
                  subtitle: 'Reach our support team',
                  icon: Icons.chat_outlined,
                  onTap: () => context.push('/contact-support'),
                ),
                Divider(height: 1, color: AppColors.border),
                _settingsTile(
                  title: 'Report a Problem',
                  subtitle: 'Let us know about any issues',
                  icon: Icons.bug_report_outlined,
                  iconColor: AppColors.error,
                  onTap: () => context.push('/report-problem'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€ 7. FAQ â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'q': 'How do I earn rewards?',
      'a': 'Scan a collection point QR code, then scan your bottle barcode. The reward is credited to your wallet instantly after confirmation.',
    },
    {
      'q': 'What types of bottles are accepted?',
      'a': 'We accept PET plastic bottles, glass bottles, and aluminium cans. Each type has a different reward value.',
    },
    {
      'q': 'When can I withdraw my earnings?',
      'a': 'You can withdraw once your wallet balance reaches â‚¹500. Transfers take 3â€“5 business days.',
    },
    {
      'q': 'Is my payment information secure?',
      'a': 'Yes. All financial data is encrypted using industry-standard security protocols and is never shared with third parties.',
    },
    {
      'q': 'What do I do if a scan fails?',
      'a': 'Ensure good lighting and a clean barcode. You can also use the gallery option to upload an image of the barcode.',
    },
    {
      'q': 'How does the referral program work?',
      'a': 'Share your unique referral code with friends. When they sign up and complete their first recycling, you both earn a bonus.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FAQs'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: _faqs
            .map((faq) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: PremiumCard(
                    padding: EdgeInsets.zero,
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.xs),
                      childrenPadding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                      leading: Icon(Icons.help_outline,
                          color: AppColors.primary),
                      title: Text(faq['q']!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
                      children: [
                        Text(faq['a']!,
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                height: 1.6)),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}


// â”€â”€â”€ 9. Permissions Screen â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perms = [
      {
        'name': 'Camera',
        'desc': 'Required to scan QR codes and bottle barcodes',
        'icon': Icons.camera_alt_outlined,
        'color': AppColors.primary,
      },
      {
        'name': 'Gallery / Photos',
        'desc': 'To import barcode images from your gallery',
        'icon': Icons.photo_library_outlined,
        'color': AppColors.secondary,
      },
      {
        'name': 'Notifications',
        'desc': 'To send reward alerts and important updates',
        'icon': Icons.notifications_outlined,
        'color': AppColors.accent,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Permissions'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
            child: Text(
              'Manage the permissions BotalSePaisa uses. You can change them at any time in your device settings.',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 14, height: 1.5),
            ),
          ),
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(perms.length, (i) {
                final p = perms[i];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (p['color'] as Color).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(p['icon'] as IconData,
                            color: p['color'] as Color),
                      ),
                      title: Text(p['name'] as String,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(p['desc'] as String,
                          style: TextStyle(fontSize: 12)),
                      trailing: TextButton(
                        onPressed: () => openAppSettings(),
                        child: Text('Manage',
                            style: TextStyle(color: AppColors.primary)),
                      ),
                    ),
                    if (i < perms.length - 1)
                      Divider(height: 1, color: AppColors.border),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€ 10. Security Screen â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});
  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Security'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  value: _biometricEnabled,
                  onChanged: (v) => setState(() => _biometricEnabled = v),
                  title: Text('Biometric Login',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                      'Use fingerprint or face ID to unlock'),
                  activeThumbColor: AppColors.primary,
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.fingerprint,
                        color: AppColors.primary),
                  ),
                ),
                Divider(height: 1, color: AppColors.border),
                SwitchListTile(
                  value: _twoFactorEnabled,
                  onChanged: (v) => setState(() => _twoFactorEnabled = v),
                  title: Text('Two-Factor Authentication',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('OTP via SMS for login'),
                  activeThumbColor: AppColors.primary,
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.verified_user_outlined,
                        color: AppColors.secondary),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _settingsTile(
                  title: 'Change Password',
                  subtitle: 'Update your login password',
                  icon: Icons.lock_outline,
                  onTap: () => context.push('/change-password'),
                ),
                Divider(height: 1, color: AppColors.border),
                _settingsTile(
                  title: 'Active Sessions',
                  subtitle: 'View and manage signed-in devices',
                  icon: Icons.devices_outlined,
                  onTap: () => context.push('/active-sessions'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€ 11. About App â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About BotalSePaisa'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          PremiumCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  child: Icon(Icons.recycling,
                      size: 60, color: AppColors.primary),
                ),
                SizedBox(height: AppSpacing.lg),
                Text('BotalSePaisa',
                    style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Version 1.0.0 (Build 1)',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Turning your empty bottles into earnings. Every bottle recycled is a step towards a greener planet and a rewarding life.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.6),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _settingsTile(
                  title: 'Privacy Policy',
                  icon: Icons.privacy_tip_outlined,
                  onTap: () => context.push('/privacy-policy'),
                ),
                Divider(height: 1, color: AppColors.border),
                _settingsTile(
                  title: 'Terms & Conditions',
                  icon: Icons.description_outlined,
                  onTap: () => context.push('/terms-conditions'),
                ),
                Divider(height: 1, color: AppColors.border),
                _settingsTile(
                  title: 'Open Source Licences',
                  icon: Icons.code,
                  onTap: () => context.push('/open-source-licenses'),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Â© 2024 BotalSePaisa. Made with ðŸ’š in India.',
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}

// â”€â”€â”€ 12. Open Source Licenses â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class OpenSourceLicensesScreen extends StatelessWidget {
  const OpenSourceLicensesScreen({super.key});

  static const List<Map<String, String>> _packages = [
    {'name': 'flutter_riverpod', 'license': 'MIT', 'version': '^3.3.2'},
    {'name': 'go_router', 'license': 'BSD-3-Clause', 'version': '^17.3.0'},
    {'name': 'mobile_scanner', 'license': 'BSD-3-Clause', 'version': '^7.4.0'},
    {'name': 'google_fonts', 'license': 'Apache-2.0', 'version': '^8.2.0'},
    {'name': 'flutter_animate', 'license': 'MIT', 'version': '^4.5.2'},
    {'name': 'image_picker', 'license': 'Apache-2.0', 'version': '^1.2.3'},
    {'name': 'permission_handler', 'license': 'MIT', 'version': '^12.0.3'},
    {'name': 'confetti', 'license': 'MIT', 'version': '^0.8.0'},
    {'name': 'intl', 'license': 'BSD-3-Clause', 'version': '^0.20.3'},
    {'name': 'dio', 'license': 'MIT', 'version': '^5.10.0'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Open Source Licences'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
            child: Text(
              'BotalSePaisa is built using the following open-source packages.',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(_packages.length, (i) {
                final p = _packages[i];
                return Column(
                  children: [
                    ListTile(
                      title: Text(p['name']!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace')),
                      subtitle: Text('${p['version']} Â· ${p['license']}',
                          style: TextStyle(fontSize: 12)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.smRadius,
                        ),
                        child: Text(p['license']!,
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    if (i < _packages.length - 1)
                      Divider(height: 1, color: AppColors.border),
                  ],
                );
              }),
            ),
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}

// â”€â”€â”€ 13. Delete Account â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});
  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _confirmed = false;
  bool _isDeleting = false;

  Future<void> _deleteAccount() async {
    setState(() => _isDeleting = true);
    await Future.delayed(const Duration(seconds: 2)); // Mock
    if (mounted) {
      setState(() => _isDeleting = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text('Request Submitted'),
          content: Text(
              'Your account deletion request has been submitted. Your account will be permanently deleted within 30 days.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/login');
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Delete Account'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PremiumCard(
              padding: const EdgeInsets.all(AppSpacing.xl),
              hasShadow: false,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.delete_forever,
                        color: AppColors.error, size: 48),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text('Delete Your Account',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'This action is permanent and cannot be undone. All your recycling history, wallet balance, and personal data will be lost.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.6),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            PremiumCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What will be deleted:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: AppSpacing.md),
                  _BulletPoint('Your profile and personal information'),
                  _BulletPoint('All transaction and recycling history'),
                  _BulletPoint('Any remaining wallet balance'),
                  _BulletPoint('Your referral code and benefits'),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            CheckboxListTile(
              value: _confirmed,
              onChanged: (v) => setState(() => _confirmed = v ?? false),
              activeColor: AppColors.error,
              title: Text(
                  'I understand this action is permanent and I want to delete my account.',
                  style: TextStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: AppSpacing.xl),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _confirmed && !_isDeleting ? _deleteAccount : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  disabledBackgroundColor:
                      AppColors.error.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.xlRadius),
                ),
                child: _isDeleting
                    ? CircularProgressIndicator(color: AppColors.textPrimary)
                    : Text('Delete My Account',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary),
              child: Text('Cancel, Keep Account'),
            ),
            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.remove_circle, color: AppColors.error, size: 16),
          SizedBox(width: AppSpacing.sm),
          Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary))),
        ],
      ),
    );
  }
}
