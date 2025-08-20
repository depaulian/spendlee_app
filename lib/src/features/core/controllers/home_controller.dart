import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/repository/transaction_repository/transaction_repository.dart';
import 'package:expense_tracker/src/features/core/models/transaction_display.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  // Repository
  final TransactionRepository _transactionRepo = Get.find<TransactionRepository>();

  // Loading states
  final isLoading = true.obs;
  final isRefreshing = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Balance data
  final currentBalance = 0.0.obs;
  final totalIncome = 0.0.obs;
  final totalExpenses = 0.0.obs;

  // Budget data
  final weeklyBudget = 0.0.obs;
  final weeklySpent = 0.0.obs;
  final monthlyBudget = 0.0.obs;
  final monthlySpent = 0.0.obs;
  final budgetPeriod = 'Weekly'.obs;

  // Recent transactions
  final RxList<TransactionDisplay> recentTransactions = <TransactionDisplay>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> _initializeData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      await _loadAllData();
    } catch (e) {
      _handleError('Failed to initialize home data', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadAllData() async {
    // Load all data concurrently for better performance
    await Future.wait([
      _loadBalanceData(),
      _loadBudgetData(),
      _loadRecentTransactions(),
    ], eagerError: false); // Continue even if one fails
  }

  Future<void> _loadBalanceData() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      print('Loading balance data from $startOfMonth to $endOfMonth');

      final result = await _transactionRepo.getBalance(
        startDate: startOfMonth,
        endDate: endOfMonth,
      );

      if (result['status'] == true && result['data'] != null) {
        final data = result['data'];

        totalIncome.value = _parseDouble(data['total_income']);
        totalExpenses.value = _parseDouble(data['total_expenses']);
        currentBalance.value = totalIncome.value - totalExpenses.value;

        print('Balance loaded: Income: ${totalIncome.value}, Expenses: ${totalExpenses.value}');
      } else {
        print('Balance API failed, calculating manually');
        await _calculateBalanceManually();
      }
    } catch (e) {
      print('Error loading balance: $e');
      await _calculateBalanceManually();
    }
  }

  Future<void> _calculateBalanceManually() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      // Get income and expenses separately
      final incomeResult = await _transactionRepo.getIncome(
        startDate: startOfMonth,
        endDate: now,
        limit: 1000,
      );

      final expenseResult = await _transactionRepo.getExpenses(
        startDate: startOfMonth,
        endDate: now,
        limit: 1000,
      );

      double incomeTotal = 0.0;
      double expenseTotal = 0.0;

      if (incomeResult['status'] == true && incomeResult['data'] != null) {
        final incomeList = incomeResult['data'] as List;
        incomeTotal = incomeList.fold(0.0, (sum, item) => sum + _parseDouble(item['amount']));
      }

      if (expenseResult['status'] == true && expenseResult['data'] != null) {
        final expenseList = expenseResult['data'] as List;
        expenseTotal = expenseList.fold(0.0, (sum, item) => sum + _parseDouble(item['amount']));
      }

      totalIncome.value = incomeTotal;
      totalExpenses.value = expenseTotal;
      currentBalance.value = incomeTotal - expenseTotal;

      print('Manual calculation: Income: $incomeTotal, Expenses: $expenseTotal');
    } catch (e) {
      print('Error in manual calculation: $e');
    }
  }

  Future<void> _loadBudgetData() async {
    try {
      print('Loading budget data...');

      final result = await _transactionRepo.getBudgetSummary();

      if (result['status'] == true && result['data'] != null) {
        final data = result['data'];

        // Handle weekly budget
        if (data['weekly_budget'] != null) {
          final weeklyData = data['weekly_budget'];
          weeklyBudget.value = _parseDouble(weeklyData['amount']);
          weeklySpent.value = _parseDouble(weeklyData['spent']);
        }

        // Handle monthly budget
        if (data['monthly_budget'] != null) {
          final monthlyData = data['monthly_budget'];
          monthlyBudget.value = _parseDouble(monthlyData['amount']);
          monthlySpent.value = _parseDouble(monthlyData['spent']);
        }

        print('Budget loaded: Weekly: ${weeklyBudget.value}/${weeklySpent.value}, Monthly: ${monthlyBudget.value}/${monthlySpent.value}');
      } else {
        print('Budget API failed, calculating spent amounts');
        await _calculateSpentAmounts();
      }
    } catch (e) {
      print('Error loading budget: $e');
      await _calculateSpentAmounts();
    }
  }

  Future<void> _calculateSpentAmounts() async {
    try {
      final now = DateTime.now();

      // Calculate weekly spent (last 7 days)
      final weekStart = now.subtract(const Duration(days: 7));
      final weeklyResult = await _transactionRepo.getExpenses(
        startDate: weekStart,
        endDate: now,
        limit: 1000,
      );

      if (weeklyResult['status'] == true && weeklyResult['data'] != null) {
        final expenses = weeklyResult['data'] as List;
        weeklySpent.value = expenses.fold(0.0, (sum, item) => sum + _parseDouble(item['amount']));
      }

      // Calculate monthly spent (current month)
      final monthStart = DateTime(now.year, now.month, 1);
      final monthlyResult = await _transactionRepo.getExpenses(
        startDate: monthStart,
        endDate: now,
        limit: 1000,
      );

      if (monthlyResult['status'] == true && monthlyResult['data'] != null) {
        final expenses = monthlyResult['data'] as List;
        monthlySpent.value = expenses.fold(0.0, (sum, item) => sum + _parseDouble(item['amount']));
      }

      print('Calculated spent amounts: Weekly: ${weeklySpent.value}, Monthly: ${monthlySpent.value}');
    } catch (e) {
      print('Error calculating spent amounts: $e');
    }
  }

  Future<void> _loadRecentTransactions() async {
    try {
      print('Loading recent transactions...');

      final result = await _transactionRepo.getTransactions(limit: 10);

      if (result['status'] == true && result['data'] != null) {
        final transactions = result['data'] as List;

        final displayTransactions = transactions
            .map((transaction) => TransactionDisplay.fromApiData(transaction as Map<String, dynamic>))
            .toList();

        recentTransactions.value = displayTransactions;
        print('Loaded ${displayTransactions.length} recent transactions');
      } else {
        print('Failed to load transactions: ${result['message']}');
        recentTransactions.clear();
      }
    } catch (e) {
      print('Error loading recent transactions: $e');
      recentTransactions.clear();
    }
  }

  Future<void> setBudget(String period, double amount) async {
    if (amount <= 0) {
      _showErrorSnackbar('Invalid Amount', 'Budget amount must be greater than zero');
      return;
    }

    try {
      final now = DateTime.now();
      final isWeekly = period.toLowerCase() == 'weekly';

      DateTime startDate, endDate;

      if (isWeekly) {
        // Calculate week start (Monday) and end (Sunday)
        final weekday = now.weekday;
        startDate = now.subtract(Duration(days: weekday - 1));
        endDate = startDate.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
      } else {
        // Monthly budget
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      }

      print('Setting $period budget: $amount from $startDate to $endDate');

      Map<String, dynamic> result;

      if (isWeekly) {
        result = await _transactionRepo.createWeeklyBudget(
          amount: amount,
          startDate: startDate,
          endDate: endDate,
        );
      } else {
        result = await _transactionRepo.createMonthlyBudget(
          amount: amount,
          startDate: startDate,
          endDate: endDate,
        );
      }

      if (result['status'] == true) {
        // Update local values
        if (isWeekly) {
          weeklyBudget.value = amount;
        } else {
          monthlyBudget.value = amount;
        }

        _showSuccessSnackbar('Budget Updated', '$period budget set successfully');
      } else {
        throw Exception(result['message'] ?? 'Failed to set budget');
      }
    } catch (e) {
      print('Error setting budget: $e');
      _showErrorSnackbar('Error', 'Failed to set budget: ${e.toString()}');
    }
  }

  Future<void> deleteTransaction(int transactionId) async {
    try {
      print('Deleting transaction: $transactionId');

      final result = await _transactionRepo.deleteTransaction(transactionId);

      if (result['status'] == true) {
        // Remove from local list
        recentTransactions.removeWhere((transaction) => transaction.id == transactionId);

        // Refresh data to update balances
        await _loadBalanceData();
        await _calculateSpentAmounts();

        _showSuccessSnackbar('Success', 'Transaction deleted successfully');
      } else {
        throw Exception(result['message'] ?? 'Failed to delete transaction');
      }
    } catch (e) {
      print('Error deleting transaction: $e');
      _showErrorSnackbar('Error', 'Failed to delete transaction: ${e.toString()}');
    }
  }

  Future<void> refreshData() async {
    try {
      isRefreshing.value = true;
      hasError.value = false;
      errorMessage.value = '';

      await _loadAllData();
    } catch (e) {
      _handleError('Failed to refresh data', e);
    } finally {
      isRefreshing.value = false;
    }
  }

  void changeBudgetPeriod(String period) {
    if (period == 'Weekly' || period == 'Monthly') {
      budgetPeriod.value = period;
    }
  }

  // Utility methods
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  void _handleError(String message, dynamic error) {
    hasError.value = true;
    errorMessage.value = message;
    print('$message: $error');
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  // Getters for computed values
  String formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(2);
  }

  double get budgetProgress {
    final budget = budgetPeriod.value == 'Weekly' ? weeklyBudget.value : monthlyBudget.value;
    final spent = budgetPeriod.value == 'Weekly' ? weeklySpent.value : monthlySpent.value;

    if (budget <= 0) return 0.0;
    return (spent / budget).clamp(0.0, 1.0);
  }

  double get remainingBudget {
    final budget = budgetPeriod.value == 'Weekly' ? weeklyBudget.value : monthlyBudget.value;
    final spent = budgetPeriod.value == 'Weekly' ? weeklySpent.value : monthlySpent.value;

    return (budget - spent).clamp(0.0, budget);
  }

  bool get isBudgetExceeded {
    final budget = budgetPeriod.value == 'Weekly' ? weeklyBudget.value : monthlyBudget.value;
    final spent = budgetPeriod.value == 'Weekly' ? weeklySpent.value : monthlySpent.value;

    return spent > budget && budget > 0;
  }

  bool get hasWeeklyBudget => weeklyBudget.value > 0;
  bool get hasMonthlyBudget => monthlyBudget.value > 0;
  bool get hasBudget => budgetPeriod.value == 'Weekly' ? hasWeeklyBudget : hasMonthlyBudget;
}