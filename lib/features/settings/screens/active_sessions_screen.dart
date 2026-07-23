import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/primary_button.dart';

class ActiveSessionsScreen extends StatelessWidget {
  const ActiveSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sessions = [
      {
        'device': 'iPhone 13 Pro',
        'location': 'New Delhi, India',
        'status': 'Active Now',
        'icon': Icons.phone_iphone,
        'isActive': true,
      },
      {
        'device': 'Chrome on Windows',
        'location': 'Mumbai, India',
        'status': 'Last active: Yesterday',
        'icon': Icons.computer,
        'isActive': false,
      },
    ];

    void logoutAll(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Logout All Devices'),
          content: Text('Are you sure you want to log out of all other devices?'),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out of all other devices'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: Text('Logout', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Active Sessions'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: PremiumCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(session['icon'] as IconData, color: AppColors.primary),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(session['device'] as String,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 4),
                              Text(session['location'] as String,
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        Text(session['status'] as String,
                            style: TextStyle(
                                color: (session['isActive'] as bool) ? AppColors.success : AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: PrimaryButton(
              text: 'Logout All Other Devices',
              onPressed: () => logoutAll(context),
            ),
          ),
        ],
      ),
    );
  }
}
