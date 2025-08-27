import 'package:expense_tracker/src/constants/colors.dart';
import 'package:flutter/material.dart';

class BudgetSection extends StatelessWidget {
  final double weeklyBudget;
  final double weeklySpent;
  final double monthlyBudget;
  final double monthlySpent;
  final String budgetPeriod;
  final String Function(double) formatNumber;
  final Function(String) onBudgetPeriodChanged;
  final VoidCallback onSetBudget;
  final String currencyCode;

  const BudgetSection({
    super.key,
    required this.weeklyBudget,
    required this.weeklySpent,
    required this.monthlyBudget,
    required this.monthlySpent,
    required this.budgetPeriod,
    required this.formatNumber,
    required this.onBudgetPeriodChanged,
    required this.onSetBudget,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final budget = budgetPeriod == 'Weekly' ? weeklyBudget : monthlyBudget;
    final spent = budgetPeriod == 'Weekly' ? weeklySpent : monthlySpent;
    final remaining = budget - spent;
    final progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final isOverBudget = spent > budget;
    final hasBudgetSet = budget > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$budgetPeriod Budget',
                style: const TextStyle(
                  fontSize: 17 ,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBudgetToggle('Weekly', budgetPeriod == 'Weekly'),
                  const SizedBox(width: 8),
                  _buildBudgetToggle('Monthly', budgetPeriod == 'Monthly'),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onSetBudget,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: tSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: tSecondaryColor,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Show different content based on whether budget is set
          if (!hasBudgetSet) ...[
            // No budget set state
            _buildNoBudgetState(),
          ] else ...[
            // Budget is set - show normal progress and stats
            // Progress Bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: isOverBudget ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBudgetStat(
                  'Spent',
                  spent,
                  isOverBudget ? Colors.red : Colors.orange,
                ),
                _buildBudgetStat(
                  'Remaining',
                  remaining,
                  isOverBudget ? Colors.red : Colors.green,
                ),
                _buildBudgetStat(
                  'Budget',
                  budget,
                  Colors.blue,
                ),
              ],
            ),

            if (isOverBudget) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You\'ve exceeded your ${budgetPeriod.toLowerCase()} budget by $currencyCode ${formatNumber(spent - budget)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildNoBudgetState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No ${budgetPeriod.toLowerCase()} budget set',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set a ${budgetPeriod.toLowerCase()} budget to track your spending and stay on target',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSetBudget,
              icon: const Icon(Icons.add, size: 18),
              label: Text('Set ${budgetPeriod} Budget'),
              style: ElevatedButton.styleFrom(
                backgroundColor: tSecondaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetToggle(String period, bool isSelected) {
    return GestureDetector(
      onTap: () {
        onBudgetPeriodChanged(period);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? tSecondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? tSecondaryColor : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          period,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetStat(String label, double amount, Color color) {
    final isNegative = amount < 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${isNegative ? '-' : ''} $currencyCode ${formatNumber(amount.abs())}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}