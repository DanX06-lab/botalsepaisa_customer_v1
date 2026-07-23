import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/design_system.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/primary_button.dart';

class _Transaction {
  final String title;
  final String subtitle;
  final double amount;
  final bool isEarned;
  final DateTime date;

  _Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isEarned,
    required this.date,
  });
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _activeFilter = 0; // 0=All, 1=Earned, 2=Withdrawn

  final List<_Transaction> _allTransactions = [
    _Transaction(
        title: 'Bottle Recycled',
        subtitle: 'PET Bottle x5',
        amount: 50.0,
        isEarned: true,
        date: DateTime.now().subtract(const Duration(hours: 2))),
    _Transaction(
        title: 'Bottle Recycled',
        subtitle: 'Glass Bottle x2',
        amount: 30.0,
        isEarned: true,
        date: DateTime.now().subtract(const Duration(days: 1))),
    _Transaction(
        title: 'Wallet Withdrawal',
        subtitle: 'Bank Transfer',
        amount: 100.0,
        isEarned: false,
        date: DateTime.now().subtract(const Duration(days: 2))),
    _Transaction(
        title: 'Bottle Recycled',
        subtitle: 'PET Bottle x10',
        amount: 100.0,
        isEarned: true,
        date: DateTime.now().subtract(const Duration(days: 3))),
    _Transaction(
        title: 'Wallet Withdrawal',
        subtitle: 'UPI Transfer',
        amount: 200.0,
        isEarned: false,
        date: DateTime.now().subtract(const Duration(days: 5))),
    _Transaction(
        title: 'Bottle Recycled',
        subtitle: 'Mixed Bottles x3',
        amount: 25.0,
        isEarned: true,
        date: DateTime.now().subtract(const Duration(days: 6))),
    _Transaction(
        title: 'Bottle Recycled',
        subtitle: 'PET Bottle x8',
        amount: 80.0,
        isEarned: true,
        date: DateTime.now().subtract(const Duration(days: 7))),
    _Transaction(
        title: 'Wallet Withdrawal',
        subtitle: 'Bank Transfer',
        amount: 150.0,
        isEarned: false,
        date: DateTime.now().subtract(const Duration(days: 10))),
  ];

  final List<double> _weeklyData = [20.0, 50.0, 30.0, 80.0, 25.0, 100.0, 45.0];
  final List<String> _weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<_Transaction> get _filteredTransactions {
    switch (_activeFilter) {
      case 1:
        return _allTransactions.where((t) => t.isEarned).toList();
      case 2:
        return _allTransactions.where((t) => !t.isEarned).toList();
      default:
        return _allTransactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: IconButton(
              icon: Icon(Icons.help_outline, color: AppColors.textPrimary),
              onPressed: () {
                context.push('/help-support');
              },
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBalanceCard(context),
                  SizedBox(height: AppSpacing.xl),
                  _buildStatisticsGrid(),
                  SizedBox(height: AppSpacing.xl),
                  _buildWeeklyChart(),
                  SizedBox(height: AppSpacing.xxl),
                  Text('Transaction History',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: AppSpacing.md),
                  _buildHistoryFilters(),
                  SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          if (_filteredTransactions.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No transactions found',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            )
          else
            SliverList.separated(
              itemCount: _filteredTransactions.length,
              separatorBuilder: (context, index) => SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                return _buildTransactionCard(_filteredTransactions[index]);
              },
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return PremiumCard(
      gradient: AppGradients.wallet,
      hasShadow: true,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Text('Available Balance',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          SizedBox(height: AppSpacing.sm),
          Text(
            '₹ 450.00',
            style: TextStyle(
              color: AppColors.primary, // Gold text for balance
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            text: 'Withdraw Funds',
            icon: Icons.account_balance,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Withdrawals are not available in mock mode.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }, 
            width: double.infinity,
          ),
          SizedBox(height: AppSpacing.md),
          Text('Minimum withdrawal: ₹ 500.00',
              style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
              'Pending', '₹ 0.00', Icons.pending_actions, AppColors.textSecondary),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard(
              'Lifetime', '₹ 1250.00', Icons.account_balance, AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String amount, IconData icon, Color iconColor) {
    return PremiumCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      hasShadow: false,
      isElevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(height: AppSpacing.md),
          Text(title,
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          SizedBox(height: 2),
          Text(amount,
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final maxValue = _weeklyData.reduce((a, b) => a > b ? a : b);
    const maxBarHeight = 100.0;

    return PremiumCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weekly Earnings',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.xlRadius,
                ),
                child: Text('This Week',
                    style:
                        TextStyle(color: AppColors.primary, fontSize: 12)),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_weeklyData.length, (i) {
                final barH =
                    (_weeklyData[i] / maxValue) * maxBarHeight;
                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '₹${_weeklyData[i].toInt()}',
                          style: TextStyle(
                              fontSize: 9,
                              color: AppColors.textSecondary),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: barH,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primary,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6)),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          _weekLabels[i],
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryFilters() {
    const labels = ['All', 'Earned', 'Withdrawn'];
    return Row(
      children: List.generate(labels.length, (i) {
        final isActive = _activeFilter == i;
        return Padding(
          padding: EdgeInsets.only(right: i < 2 ? AppSpacing.sm : 0),
          child: GestureDetector(
            onTap: () => setState(() => _activeFilter = i),
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color:
                      isActive ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  color: isActive
                      ? AppColors.background
                      : AppColors.textPrimary,
                  fontWeight: isActive
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTransactionCard(_Transaction t) {
    final fmt = DateFormat('dd MMM, hh:mm a');
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: PremiumCard(
        padding: const EdgeInsets.all(AppSpacing.sm),
        hasShadow: false,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: t.isEarned
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: Icon(
              t.isEarned ? Icons.arrow_downward : Icons.arrow_upward,
              color: t.isEarned ? AppColors.success : AppColors.textPrimary,
            ),
          ),
          title: Text(t.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.subtitle,
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              Text(fmt.format(t.date),
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textDisabled)),
            ],
          ),
          trailing: Text(
            '${t.isEarned ? '+' : '-'}₹ ${t.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: t.isEarned ? AppColors.success : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
