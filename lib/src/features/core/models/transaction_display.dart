// Simple Transaction Display model for Home Screen widgets
// This is a lightweight model that works with your existing widget structure
import 'package:flutter/material.dart';

class TransactionDisplay {
  final String title;
  final String category;
  final double amount;
  final String date;
  final String time;
  final IconData icon;
  final bool isIncome;
  final int? id; // Optional ID for API operations

  TransactionDisplay({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.time,
    required this.icon,
    required this.isIncome,
    this.id,
  });

  // Factory constructor to create TransactionDisplay from API response
  factory TransactionDisplay.fromApiData(Map<String, dynamic> apiData) {
    final transactionDate = DateTime.parse(apiData['expense_date']);
    return TransactionDisplay(
      id: apiData['id'],
      title: apiData['description'] ?? 'Unknown',
      category: apiData['category'] ?? 'Other',
      amount: (apiData['amount'] ?? 0.0).toDouble(),
      date: _formatDate(transactionDate),
      time: _formatTime(transactionDate),
      icon: _getCategoryIcon(apiData['category']),
      isIncome: apiData['transaction_type'] == 'income',
    );
  }

  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  static String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static IconData _getCategoryIcon(String? category) {
    final categoryMap = {
      'food': Icons.restaurant,
      'entertainment': Icons.movie,
      'transportation': Icons.directions_car,
      'shopping': Icons.shopping_cart,
      'bills': Icons.receipt_long,
      'health': Icons.local_hospital,
      'education': Icons.school,
      'travel': Icons.flight,
      'groceries': Icons.local_grocery_store,
      'utilities': Icons.electrical_services,
      'rent': Icons.home,
      'insurance': Icons.security,
      'salary': Icons.account_balance_wallet,
      'freelance': Icons.laptop_mac,
      'business': Icons.business,
      'other': Icons.category,
    };

    return categoryMap[category?.toLowerCase()] ?? Icons.category;
  }
}