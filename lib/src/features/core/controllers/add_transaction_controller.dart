import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/repository/transaction_repository/transaction_repository.dart';
import 'package:expense_tracker/src/constants/colors.dart';

class AddTransactionController extends GetxController {
  static AddTransactionController get instance => Get.find();

  // Repository
  final TransactionRepository _transactionRepo = Get.find<TransactionRepository>();

  // Form state
  final isExpense = true.obs;
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final selectedCategory = Rxn<String>();
  final selectedDate = DateTime.now().obs;

  // UI state
  final isLoading = false.obs;
  final isFormValid = false.obs;

  // Categories loaded from API
  final RxList<Map<String, dynamic>> expenseCategories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> incomeCategories = <Map<String, dynamic>>[].obs;
  final isLoadingCategories = true.obs;

  // Default categories as fallback
  final List<Map<String, dynamic>> _defaultExpenseCategories = [
    {'name': 'food', 'display_name': 'Food', 'icon': 'restaurant', 'color': '#FF6B6B'},
    {'name': 'transportation', 'display_name': 'Transport', 'icon': 'directions_car', 'color': '#4ECDC4'},
    {'name': 'shopping', 'display_name': 'Shopping', 'icon': 'shopping_bag', 'color': '#45B7D1'},
    {'name': 'entertainment', 'display_name': 'Entertainment', 'icon': 'movie', 'color': '#96CEB4'},
    {'name': 'bills', 'display_name': 'Bills', 'icon': 'receipt_long', 'color': '#FECA57'},
    {'name': 'health', 'display_name': 'Health', 'icon': 'local_hospital', 'color': '#FF9FF3'},
    {'name': 'education', 'display_name': 'Education', 'icon': 'school', 'color': '#54A0FF'},
    {'name': 'travel', 'display_name': 'Travel', 'icon': 'flight', 'color': '#5F27CD'},
    {'name': 'other', 'display_name': 'Other', 'icon': 'category', 'color': '#636E72'},
  ];

  final List<Map<String, dynamic>> _defaultIncomeCategories = [
    {'name': 'salary', 'display_name': 'Salary', 'icon': 'work', 'color': '#00B894'},
    {'name': 'freelance', 'display_name': 'Freelance', 'icon': 'laptop_mac', 'color': '#6C5CE7'},
    {'name': 'investments', 'display_name': 'Investment', 'icon': 'trending_up', 'color': '#00CEC9'},
    {'name': 'gifts', 'display_name': 'Gift', 'icon': 'card_giftcard', 'color': '#E84393'},
    {'name': 'business', 'display_name': 'Business', 'icon': 'business', 'color': '#0984E3'},
    {'name': 'other', 'display_name': 'Other', 'icon': 'attach_money', 'color': '#00B894'},
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }

  void _initializeController() {
    // Load categories from API
    _loadCategories();

    // Listen to form changes
    amountController.addListener(_validateForm);

    // Listen to category selection
    ever(selectedCategory, (_) => _validateForm());
  }

  Future<void> _loadCategories() async {
    try {
      isLoadingCategories.value = true;

      final result = await _transactionRepo.getCategories();

      if (result['status'] == true && result['data'] != null) {
        final data = result['data'];

        // Process expense categories
        if (data['expense_categories'] != null) {
          expenseCategories.value = (data['expense_categories'] as List)
              .map((cat) => _processCategory(cat))
              .toList();
        } else {
          expenseCategories.value = _defaultExpenseCategories;
        }

        // Process income categories
        if (data['income_categories'] != null) {
          incomeCategories.value = (data['income_categories'] as List)
              .map((cat) => _processCategory(cat))
              .toList();
        } else {
          incomeCategories.value = _defaultIncomeCategories;
        }

        print('Loaded ${expenseCategories.length} expense categories and ${incomeCategories.length} income categories');
      } else {
        // Use default categories as fallback
        print('Failed to load categories from API, using defaults');
        expenseCategories.value = _defaultExpenseCategories;
        incomeCategories.value = _defaultIncomeCategories;
      }
    } catch (e) {
      print('Error loading categories: $e');
      // Use default categories as fallback
      expenseCategories.value = _defaultExpenseCategories;
      incomeCategories.value = _defaultIncomeCategories;
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Map<String, dynamic> _processCategory(Map<String, dynamic> apiCategory) {
    return {
      'name': apiCategory['name'] ?? '',
      'display_name': apiCategory['display_name'] ?? apiCategory['name'] ?? '',
      'icon': apiCategory['icon'] ?? 'category',
      'color': apiCategory['color'] ?? '#636E72',
      'flutter_icon': _getFlutterIcon(apiCategory['icon']),
      'flutter_color': _parseColor(apiCategory['color'] ?? '#636E72'),
    };
  }

  IconData _getFlutterIcon(String? iconName) {
    final iconMap = {
      'restaurant': Icons.restaurant,
      'directions_car': Icons.directions_car,
      'shopping_bag': Icons.shopping_bag,
      'shopping_cart': Icons.shopping_cart,
      'movie': Icons.movie,
      'receipt_long': Icons.receipt_long,
      'local_hospital': Icons.local_hospital,
      'school': Icons.school,
      'flight': Icons.flight,
      'work': Icons.work,
      'laptop_mac': Icons.laptop_mac,
      'trending_up': Icons.trending_up,
      'card_giftcard': Icons.card_giftcard,
      'business': Icons.business,
      'attach_money': Icons.attach_money,
      'category': Icons.category,
      'local_grocery_store': Icons.local_grocery_store,
      'electrical_services': Icons.electrical_services,
      'home': Icons.home,
      'security': Icons.security,
      'account_balance_wallet': Icons.account_balance_wallet,
      'percent': Icons.percent,
      'monetization_on': Icons.monetization_on,
    };

    return iconMap[iconName] ?? Icons.category;
  }

  Color _parseColor(String colorString) {
    try {
      String hexColor = colorString.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor'; // Add alpha if missing
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return const Color(0xFF636E72); // Default gray color
    }
  }

  void _validateForm() {
    final amount = amountController.text.trim();
    final hasValidAmount = amount.isNotEmpty &&
        amount != '0.00' &&
        double.tryParse(amount) != null &&
        double.parse(amount) > 0;

    isFormValid.value = hasValidAmount && selectedCategory.value != null;
  }

  void changeTransactionType(bool expense) {
    if (isExpense.value != expense) {
      isExpense.value = expense;
      selectedCategory.value = null; // Reset category when type changes
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = selectedCategory.value == category ? null : category;
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<bool> addTransaction() async {
    if (!isFormValid.value) {
      _showValidationError();
      return false;
    }

    try {
      isLoading.value = true;

      final amount = double.parse(amountController.text.trim());
      final transactionType = isExpense.value ? 'expense' : 'income';

      final result = await _transactionRepo.createTransaction(
        amount: amount,
        description: _generateDescription(),
        category: selectedCategory.value!,
        transactionType: transactionType,
        expenseDate: selectedDate.value,
        notes: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
      );

      if (result['status'] == true) {
        _showSuccessMessage();
        return true;
      } else {
        _showErrorMessage(result['message'] ?? 'Failed to add transaction');
        return false;
      }
    } catch (e) {
      print('Error adding transaction: $e');
      _showErrorMessage('An error occurred while adding the transaction');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _generateDescription() {
    // If user provided a note, use the first part as description
    final note = noteController.text.trim();
    if (note.isNotEmpty) {
      // Use the first line or first 50 characters as description
      final lines = note.split('\n');
      String description = lines.first;
      if (description.length > 50) {
        description = '${description.substring(0, 47)}...';
      }
      return description;
    }

    // Generate description based on category
    final categoryName = _getCategoryDisplayName();
    final transactionType = isExpense.value ? 'Expense' : 'Income';
    return '$categoryName $transactionType';
  }

  String _getCategoryDisplayName() {
    if (selectedCategory.value == null) return 'Transaction';

    final categories = isExpense.value ? expenseCategories : incomeCategories;
    final category = categories.firstWhereOrNull(
          (cat) => cat['name'] == selectedCategory.value,
    );

    return category?['display_name'] ?? selectedCategory.value!;
  }

  void _showValidationError() {
    String message = 'Please check the following:';
    if (amountController.text.trim().isEmpty || double.tryParse(amountController.text.trim()) == null) {
      message = 'Please enter a valid amount';
    } else if (selectedCategory.value == null) {
      message = 'Please select a category';
    }

    Get.snackbar(
      'Validation Error',
      message,
      backgroundColor: tErrorColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccessMessage() {
    final transactionType = isExpense.value ? 'Expense' : 'Income';
    Get.snackbar(
      'Success',
      '$transactionType added successfully',
      backgroundColor: tSuccessColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: tErrorColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    );
  }

  void resetForm() {
    amountController.clear();
    noteController.clear();
    selectedCategory.value = null;
    selectedDate.value = DateTime.now();
    isExpense.value = true;
  }

  // Getters for current categories
  List<Map<String, dynamic>> get currentCategories =>
      isExpense.value ? expenseCategories : incomeCategories;

  bool get hasCategories => currentCategories.isNotEmpty;
}