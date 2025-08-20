import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double currentBalance;
  final double totalIncome;
  final double totalExpenses;
  final String Function(double) formatNumber;
  final String currencyCode;

  const BalanceCard({
    super.key,
    required this.currentBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.formatNumber,
    required this.currencyCode,
  });

  // Determine if balance is positive (income >= expenses)
  bool get isPositiveBalance => currentBalance >= 0;

  // Get gradient colors based on balance
  List<Color> get gradientColors {
    if (isPositiveBalance) {
      // Green gradient for positive balance
      return [const Color(0xFF66BB6A), const Color(0xFF4CAF50)];
    } else {
      // Red gradient for negative balance
      return [const Color(0xFFEF5350), const Color(0xFFE53935)];
    }
  }

  // Get shadow color based on balance
  Color get shadowColor {
    if (isPositiveBalance) {
      return Colors.green.withOpacity(0.3);
    } else {
      return Colors.red.withOpacity(0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Current Balance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show indicator icon based on balance
              Icon(
                isPositiveBalance ? Icons.trending_up : Icons.trending_down,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '$currencyCode ${formatNumber(currentBalance.abs())}', // Use abs() to always show positive number
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Show balance status text
          const SizedBox(height: 4),
          Text(
            isPositiveBalance
                ? (currentBalance == 0 ? 'Balanced' : 'Surplus')
                : 'Deficit',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildIncomeExpenseItem(
                  icon: Icons.trending_up,
                  title: 'Income',
                  amount: totalIncome,
                  isIncome: true,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildIncomeExpenseItem(
                  icon: Icons.trending_down,
                  title: 'Expenses',
                  amount: totalExpenses,
                  isIncome: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseItem({
    required IconData icon,
    required String title,
    required double amount,
    required bool isIncome,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$currencyCode ${formatNumber(amount)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}