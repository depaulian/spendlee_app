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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
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
          Text(
            '$currencyCode ${formatNumber(currentBalance)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
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