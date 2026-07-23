import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/design_system.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/primary_button.dart';

class ReferAndEarnScreen extends StatelessWidget {
  const ReferAndEarnScreen({super.key});

  final String _referralCode = 'BOTAL50';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Refer & Earn'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroSection(context),
            SizedBox(height: AppSpacing.xl),
            _buildReferralCodeSection(context),
            SizedBox(height: AppSpacing.xl),
            _buildStatisticsGrid(),
            SizedBox(height: AppSpacing.xl),
            _buildReferralHistorySection(),
            SizedBox(height: AppSpacing.xl),
            _buildHowItWorksSection(),
            SizedBox(height: AppSpacing.xl),
            _buildFaqSection(),
            SizedBox(height: AppSpacing.xl),
            _buildTermsSection(),
            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent.withValues(alpha: 0.1),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.card_giftcard, size: 60, color: AppColors.accent),
          ),
        ),
        SizedBox(height: AppSpacing.xl),
        Text(
          'Invite Friends, Earn Rewards!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Get ₹50 for every friend who signs up and recycles their first bottle using your code.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReferralCodeSection(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      gradient: AppGradients.wallet,
      child: Column(
        children: [
          Text(
            'Your Referral Code',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.8),
              borderRadius: AppRadius.lgRadius,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    _referralCode,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: _referralCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Referral code copied!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.copy, color: AppColors.primary, size: 20),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            text: 'Share with Friends',
            icon: Icons.share,
            onPressed: () {
              Share.share('Join BotalSePaisa and get rewards for recycling! Use my referral code: $_referralCode');
            },
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PremiumCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.people, color: AppColors.success, size: 24),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text('12', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Total Referrals', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: PremiumCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.stars, color: AppColors.accent, size: 24),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text('₹600', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Total Earnings', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        PremiumCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.hourglass_bottom, color: Colors.orange, size: 20),
              ),
              SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('3', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Pending Referrals', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReferralHistorySection() {
    final mockHistory = [
      {'name': 'Amit Singh', 'status': 'Completed', 'date': 'Today', 'amount': '₹50'},
      {'name': 'Priya Sharma', 'status': 'Pending', 'date': 'Yesterday', 'amount': '-'},
      {'name': 'Rohit Verma', 'status': 'Completed', 'date': '12 Oct', 'amount': '₹50'},
      {'name': 'Sneha Patil', 'status': 'Pending', 'date': '10 Oct', 'amount': '-'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Referral History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSpacing.md),
        PremiumCard(
          padding: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockHistory.length,
            separatorBuilder: (context, index) => Divider(height: 1, indent: 60),
            itemBuilder: (context, index) {
              final item = mockHistory[index];
              final isCompleted = item['status'] == 'Completed';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.surface,
                  child: Text(
                    item['name']![0],
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(item['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item['date']!, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item['amount']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? AppColors.success : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      item['status']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: isCompleted ? AppColors.success : Colors.orange,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How it Works',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSpacing.md),
        PremiumCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              _buildStepRow(
                icon: Icons.send,
                step: '1',
                title: 'Share your code',
                description: 'Send your referral code to friends and family.',
              ),
              _buildStepDivider(),
              _buildStepRow(
                icon: Icons.app_registration,
                step: '2',
                title: 'Friend signs up',
                description: 'Your friend creates an account using your code.',
              ),
              _buildStepDivider(),
              _buildStepRow(
                icon: Icons.recycling,
                step: '3',
                title: 'First recycle',
                description: 'Your friend recycles their first bottle at a smart bin.',
              ),
              _buildStepDivider(),
              _buildStepRow(
                icon: Icons.account_balance_wallet,
                step: '4',
                title: 'Earn ₹50',
                description: 'Both you and your friend receive ₹50 in your wallets!',
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepRow({
    required IconData icon,
    required String step,
    required String title,
    required String description,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isLast ? AppColors.accent.withValues(alpha: 0.2) : AppColors.surfaceElevated,
                shape: BoxShape.circle,
                border: Border.all(color: isLast ? AppColors.accent : AppColors.border),
              ),
              child: Center(
                child: Text(
                  step,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isLast ? AppColors.accent : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 19, top: 4, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 2,
          height: 30,
          color: AppColors.border,
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FAQ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSpacing.md),
        PremiumCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              const ExpansionTile(
                title: Text('When do I get my bonus?', style: TextStyle(fontSize: 14)),
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text('You will receive your bonus in your wallet immediately after your referred friend recycles their first bottle.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  )
                ],
              ),
              const ExpansionTile(
                title: Text('Is there a limit to referrals?', style: TextStyle(fontSize: 14)),
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text('No! You can invite as many friends as you want and earn unlimited rewards.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  )
                ],
              ),
              const ExpansionTile(
                title: Text('Why is my referral pending?', style: TextStyle(fontSize: 14)),
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text('A referral remains pending if your friend has signed up but hasn\'t yet completed their first bottle recycling at our smart bins.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text('Terms & Conditions Apply', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ),
    );
  }
}
