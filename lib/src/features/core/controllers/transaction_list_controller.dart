import 'package:expense_tracker/src/features/core/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/repository/transaction_repository/transaction_repository.dart';
import 'package:expense_tracker/src/features/core/models/transaction_display.dart';

class TransactionsListController extends GetxController {
  static TransactionsListController get instance => Get.find();

  // Repository
  final TransactionRepository _transactionRepo = Get.find<TransactionRepository>();

  // Loading states
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // View mode
  final isListView = true.obs;

  // All transactions
  final RxList<TransactionDisplay> allTransactions = <TransactionDisplay>[].obs;
  final RxList<TransactionDisplay> filteredTransactions = <TransactionDisplay>[].obs;

  // Filters
  final selectedType = 'all'.obs;
  final selectedCategory = 'all'.obs;
  final selectedDateRange = 'all'.obs;
  final selectedAmountRange = 'all'.obs;
  final searchQuery = ''.obs;

  // Available categories
  final RxList<String> availableCategories = <String>[].obs;

  // Search controller
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _initializeController() {
    // Load transactions
    loadTransactions();

    // Listen to filter changes
    ever(selectedType, (_) => _applyFilters());
    ever(selectedCategory, (_) => _applyFilters());
    ever(selectedDateRange, (_) => _applyFilters());
    ever(selectedAmountRange, (_) => _applyFilters());
    ever(searchQuery, (_) => _applyFilters());
  }

  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final result = await _transactionRepo.getTransactions(limit: 1000);

      if (result['status'] == true && result['data'] != null) {
        final transactions = result['data'] as List;

        allTransactions.value = transactions
            .map((transaction) => TransactionDisplay.fromApiData(transaction as Map<String, dynamic>))
            .toList();

        // Sort by date (newest first)
        allTransactions.sort((a, b) => b.date.compareTo(a.date));

        // Extract available categories
        _extractCategories();

        // Apply initial filters
        _applyFilters();

        print('Loaded ${allTransactions.length} transactions');
      } else {
        throw Exception(result['message'] ?? 'Failed to load transactions');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load transactions: ${e.toString()}';
      print('Error loading transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _extractCategories() {
    final categories = allTransactions
        .map((transaction) => transaction.category)
        .toSet()
        .toList();
    categories.sort();
    availableCategories.value = categories;
  }

  void _applyFilters() {
    var filtered = allTransactions.toList();

    // Apply type filter
    if (selectedType.value != 'all') {
      filtered = filtered.where((transaction) {
        if (selectedType.value == 'expense') return !transaction.isIncome;
        if (selectedType.value == 'income') return transaction.isIncome;
        return true;
      }).toList();
    }

    // Apply category filter
    if (selectedCategory.value != 'all') {
      filtered = filtered.where((transaction) =>
      transaction.category.toLowerCase() == selectedCategory.value.toLowerCase()).toList();
    }

    // Apply date range filter
    if (selectedDateRange.value != 'all') {
      final now = DateTime.now();
      DateTime? startDate;

      switch (selectedDateRange.value) {
        case 'today':
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case 'week':
          startDate = now.subtract(Duration(days: now.weekday - 1));
          break;
        case 'month':
          startDate = DateTime(now.year, now.month, 1);
          break;
        case 'year':
          startDate = DateTime(now.year, 1, 1);
          break;
      }

      if (startDate != null) {
        filtered = filtered.where((transaction) {
          // Parse transaction date (assuming format like "Aug 20" or "Today")
          if (transaction.date == 'Today') return selectedDateRange.value == 'today';
          if (transaction.date == 'Yesterday') return selectedDateRange.value == 'today' || selectedDateRange.value == 'week';

          // For other dates, we need to compare with the actual date
          // This is a simplified comparison - in a real app, you'd want proper date parsing
          return true; // For now, include all non-today/yesterday dates
        }).toList();
      }
    }

    // Apply amount range filter
    if (selectedAmountRange.value != 'all') {
      filtered = filtered.where((transaction) {
        final amount = transaction.amount;
        switch (selectedAmountRange.value) {
          case 'low':
            return amount < 50;
          case 'medium':
            return amount >= 50 && amount <= 200;
          case 'high':
            return amount > 200;
          default:
            return true;
        }
      }).toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((transaction) =>
      transaction.title.toLowerCase().contains(query) ||
          transaction.category.toLowerCase().contains(query)).toList();
    }

    filteredTransactions.value = filtered;
  }

  // Filter methods
  void setTypeFilter(String type) {
    selectedType.value = type;
  }

  void setCategoryFilter(String category) {
    selectedCategory.value = category;
  }

  void setDateRangeFilter(String dateRange) {
    selectedDateRange.value = dateRange;
  }

  void setAmountRangeFilter(String amountRange) {
    selectedAmountRange.value = amountRange;
  }

  void setSearchFilter(String query) {
    searchQuery.value = query;
  }

  void clearAllFilters() {
    selectedType.value = 'all';
    selectedCategory.value = 'all';
    selectedDateRange.value = 'all';
    selectedAmountRange.value = 'all';
    searchQuery.value = '';
    searchController.clear();
  }

  // View mode
  void toggleView() {
    isListView.value = !isListView.value;
  }

  // Transaction operations
  Future<void> deleteTransaction(int transactionId) async {
    try {
      final result = await _transactionRepo.deleteTransaction(transactionId);

      if (result['status'] == true) {
        // Remove from local lists
        allTransactions.removeWhere((transaction) => transaction.id == transactionId);
        _applyFilters(); // Refresh filtered list

        // Update home controller if it exists
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().refreshData();
        }

        Get.snackbar(
          'Success',
          'Transaction deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception(result['message'] ?? 'Failed to delete transaction');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete transaction: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> refreshTransactions() async {
    await loadTransactions();
  }

  // Utility methods
  String formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(2);
  }

  // Getters
  int get totalTransactions => allTransactions.length;
  int get filteredCount => filteredTransactions.length;

  double get totalIncome => allTransactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpenses => allTransactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  bool get hasFiltersApplied =>
      selectedType.value != 'all' ||
          selectedCategory.value != 'all' ||
          selectedDateRange.value != 'all' ||
          selectedAmountRange.value != 'all' ||
          searchQuery.value.isNotEmpty;
}