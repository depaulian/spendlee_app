import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/external_endpoints.dart';
import 'package:expense_tracker/src/repository/preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SummaryController extends GetxController {
  static SummaryController get instance => Get.find();

  // Observable variables
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Summary data
  final totalIncome = 0.0.obs;
  final totalExpenses = 0.0.obs;
  final netBalance = 0.0.obs;

  // Chart data for daily activity
  final RxList<Map<String, dynamic>> chartData = <Map<String, dynamic>>[].obs;

  // Category breakdown data
  final RxList<Map<String, dynamic>> categoryExpenses = <Map<String, dynamic>>[].obs;

  // Predefined colors for categories
  final List<Color> categoryColors = [
    const Color(0xFF4F7DF3), // Blue
    const Color(0xFFFF6B6B), // Red
    const Color(0xFF4ECDC4), // Teal
    const Color(0xFFFFD93D), // Yellow
    const Color(0xFF6BCF7F), // Green
    const Color(0xFFFF8A65), // Orange
    const Color(0xFF9C27B0), // Purple
    const Color(0xFF795548), // Brown
    const Color(0xFF607D8B), // Blue Grey
    const Color(0xFFE91E63), // Pink
  ];

  // Icon mapping for categories
  final Map<String, IconData> categoryIcons = {
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
    'investments': Icons.trending_up,
    'gifts': Icons.card_giftcard,
    'other': Icons.category,
    'salary': Icons.account_balance_wallet,
    'freelance': Icons.work,
    'business': Icons.business,
    'interest': Icons.percent,
    'dividends': Icons.monetization_on,
  };

  @override
  void onInit() {
    super.onInit();
    // Load initial data with default period
    loadSummaryData('30 Days');
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }

  Future<void> loadSummaryData(String period) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Calculate date range based on period
      final dateRange = _calculateDateRange(period);
      final startDate = dateRange['start']!;
      final endDate = dateRange['end']!;

      // Fetch data in parallel
      final results = await Future.wait([
        _fetchTransactionSummary(startDate, endDate),
        _fetchCategoryBreakdownFallback(startDate, endDate),
        _fetchDailyChartData(startDate, endDate),
      ]);

      final summary = results[0] as Map<String, dynamic>?;
      final categories = results[1] as List<Map<String, dynamic>>?;
      final dailyData = results[2] as List<Map<String, dynamic>>?;

      // Update summary totals
      if (summary != null) {
        totalIncome.value = (summary['total_income'] ?? 0.0).toDouble();
        totalExpenses.value = (summary['total_expenses'] ?? 0.0).toDouble();
        netBalance.value = totalIncome.value - totalExpenses.value;
      }

      // Update category data
      if (categories != null) {
        _updateCategoryData(categories);
      }

      // Update chart data
      if (dailyData != null) {
        chartData.value = dailyData;
      }

    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load summary data: ${e.toString()}';
      print('Error loading summary data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, DateTime> _calculateDateRange(String period) {
    final now = DateTime.now();
    DateTime startDate;

    switch (period) {
      case '7 Days':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case '30 Days':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case '1 Year':
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startDate = now.subtract(const Duration(days: 30));
    }

    return {
      'start': startDate,
      'end': now,
    };
  }

  Future<Map<String, dynamic>?> _fetchTransactionSummary(DateTime startDate, DateTime endDate) async {
    try {
      final accessToken = await UserPreferences().getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final response = await http.get(
        Uri.parse(tBalanceUrl).replace(queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        }),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      print('Balance API response status: ${response.statusCode}');
      print('Balance API response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        // If balance endpoint fails, calculate manually from transactions
        print('Balance API failed, calculating manually');
        return await _calculateBalanceFromTransactions(startDate, endDate);
      }
    } catch (e) {
      print('Error fetching transaction summary: $e');
      // Fallback to manual calculation
      return await _calculateBalanceFromTransactions(startDate, endDate);
    }
  }

  // Fallback method to calculate balance from individual transactions
  Future<Map<String, dynamic>?> _calculateBalanceFromTransactions(DateTime startDate, DateTime endDate) async {
    try {
      final accessToken = await UserPreferences().getAccessToken();
      if (accessToken == null) return null;

      // Fetch both income and expenses
      final incomeResponse = await http.get(
        Uri.parse(tIncomeUrl).replace(queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'limit': '1000',
        }),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      final expenseResponse = await http.get(
        Uri.parse(tExpensesUrl).replace(queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'limit': '1000',
        }),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (incomeResponse.statusCode == 200 && expenseResponse.statusCode == 200) {
        final incomeData = List<Map<String, dynamic>>.from(jsonDecode(incomeResponse.body));
        final expenseData = List<Map<String, dynamic>>.from(jsonDecode(expenseResponse.body));

        double totalIncome = 0;
        double totalExpenses = 0;

        for (final income in incomeData) {
          totalIncome += (income['amount'] ?? 0.0).toDouble();
        }

        for (final expense in expenseData) {
          totalExpenses += (expense['amount'] ?? 0.0).toDouble();
        }

        return {
          'total_income': totalIncome,
          'total_expenses': totalExpenses,
          'net_balance': totalIncome - totalExpenses,
        };
      }
      return null;
    } catch (e) {
      print('Error calculating balance from transactions: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> _fetchCategoryBreakdown(DateTime startDate, DateTime endDate) async {
    try {
      final accessToken = await UserPreferences().getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final response = await http.get(
        Uri.parse(tCategoryBreakdownUrl).replace(queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        }),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Category breakdown response: $data'); // Debug log

        // Handle different possible response structures
        if (data is Map) {
          if (data.containsKey('categories') && data['categories'] is List) {
            return List<Map<String, dynamic>>.from(data['categories']);
          } else if (data.containsKey('breakdown') && data['breakdown'] is List) {
            return List<Map<String, dynamic>>.from(data['breakdown']);
          } else {
            // If it's a map with category keys, convert to list
            final List<Map<String, dynamic>> categoryList = [];
            data.forEach((key, value) {
              if (value is Map<String, dynamic> && value.containsKey('total_amount')) {
                categoryList.add({
                  'category': key,
                  'total_amount': value['total_amount'],
                  'transaction_count': value['transaction_count'] ?? 0,
                });
              }
            });
            return categoryList;
          }
        } else if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
        return [];
      } else {
        throw Exception('Failed to fetch category breakdown: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching category breakdown: $e');
      return [];
    }
  }

  // Fallback method that tries category breakdown API and falls back to processing transactions
  Future<List<Map<String, dynamic>>?> _fetchCategoryBreakdownFallback(DateTime startDate, DateTime endDate) async {
    try {
      // Try the category breakdown endpoint first
      final categories = await _fetchCategoryBreakdown(startDate, endDate);
      if (categories != null && categories.isNotEmpty) {
        return categories;
      }

      // Fallback: fetch expenses and group by category manually
      print('Category breakdown API failed, using fallback method');
      return await _fetchCategoryBreakdownFromTransactions(startDate, endDate);
    } catch (e) {
      print('Error in category breakdown fallback: $e');
      return [];
    }
  }

  // Fallback method to create category breakdown from transaction data
  Future<List<Map<String, dynamic>>> _fetchCategoryBreakdownFromTransactions(DateTime startDate, DateTime endDate) async {
    try {
      final accessToken = await UserPreferences().getAccessToken();
      if (accessToken == null) return [];

      final response = await http.get(
        Uri.parse(tExpensesUrl).replace(queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'limit': '1000',
        }),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final expenses = List<Map<String, dynamic>>.from(jsonDecode(response.body));

        // Group expenses by category
        final Map<String, double> categoryTotals = {};
        for (final expense in expenses) {
          final category = expense['category'] ?? 'other';
          final amount = (expense['amount'] ?? 0.0).toDouble();
          categoryTotals[category] = (categoryTotals[category] ?? 0.0) + amount;
        }

        // Convert to list format
        return categoryTotals.entries.map((entry) => {
          'category': entry.key,
          'total_amount': entry.value,
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error creating category breakdown from transactions: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>?> _fetchDailyChartData(DateTime startDate, DateTime endDate) async {
    try {
      final accessToken = await UserPreferences().getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }

      // Fetch both income and expenses
      final incomeResponse = await http.get(
        Uri.parse(tIncomeUrl).replace(queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'limit': '1000',
        }),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      final expenseResponse = await http.get(
        Uri.parse(tExpensesUrl).replace(queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'limit': '1000',
        }),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (incomeResponse.statusCode == 200 && expenseResponse.statusCode == 200) {
        final incomeData = List<Map<String, dynamic>>.from(jsonDecode(incomeResponse.body));
        final expenseData = List<Map<String, dynamic>>.from(jsonDecode(expenseResponse.body));

        return _processChartData(incomeData, expenseData, startDate, endDate);
      } else {
        throw Exception('Failed to fetch transactions for chart');
      }
    } catch (e) {
      print('Error fetching daily chart data: $e');
      return [];
    }
  }

  List<Map<String, dynamic>> _processChartData(
      List<Map<String, dynamic>> incomeData,
      List<Map<String, dynamic>> expenseData,
      DateTime startDate,
      DateTime endDate,
      ) {
    // Create a map to store daily totals
    final Map<String, Map<String, double>> dailyTotals = {};

    // Initialize all days in the range with zero values
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      final dateKey = DateFormat('yyyy-MM-dd').format(currentDate);
      dailyTotals[dateKey] = {'income': 0.0, 'expense': 0.0};
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Process income data
    for (final transaction in incomeData) {
      try {
        final expenseDate = DateTime.parse(transaction['expense_date']);
        final dateKey = DateFormat('yyyy-MM-dd').format(expenseDate);
        final amount = (transaction['amount'] ?? 0.0).toDouble();

        if (dailyTotals.containsKey(dateKey)) {
          dailyTotals[dateKey]!['income'] = dailyTotals[dateKey]!['income']! + amount;
        }
      } catch (e) {
        print('Error processing income transaction: $e');
      }
    }

    // Process expense data
    for (final transaction in expenseData) {
      try {
        final expenseDate = DateTime.parse(transaction['expense_date']);
        final dateKey = DateFormat('yyyy-MM-dd').format(expenseDate);
        final amount = (transaction['amount'] ?? 0.0).toDouble();

        if (dailyTotals.containsKey(dateKey)) {
          dailyTotals[dateKey]!['expense'] = dailyTotals[dateKey]!['expense']! + amount;
        }
      } catch (e) {
        print('Error processing expense transaction: $e');
      }
    }

    // Convert to list format for chart
    final List<Map<String, dynamic>> chartDataList = [];
    final sortedDates = dailyTotals.keys.toList()..sort();

    for (final dateKey in sortedDates) {
      chartDataList.add({
        'date': dateKey,
        'income': dailyTotals[dateKey]!['income']!,
        'expense': dailyTotals[dateKey]!['expense']!,
      });
    }

    return chartDataList;
  }

  void _updateCategoryData(List<Map<String, dynamic>> categories) {
    if (categories.isEmpty) {
      categoryExpenses.clear();
      return;
    }

    // Calculate total expenses for percentage calculation
    double totalCategoryExpenses = 0;
    for (final category in categories) {
      final amount = (category['total_amount'] ?? category['amount'] ?? 0.0).toDouble();
      totalCategoryExpenses += amount;
    }

    // If no expenses, clear the data
    if (totalCategoryExpenses == 0) {
      categoryExpenses.clear();
      return;
    }

    // Process category data
    final List<Map<String, dynamic>> processedCategories = [];
    for (int i = 0; i < categories.length && i < categoryColors.length; i++) {
      final category = categories[i];
      final categoryName = category['category'] ?? category['name'] ?? 'other';
      final amount = (category['total_amount'] ?? category['amount'] ?? 0.0).toDouble();
      final percentage = totalCategoryExpenses > 0 ? (amount / totalCategoryExpenses) * 100 : 0.0;

      // Only add categories with non-zero amounts
      if (amount > 0) {
        processedCategories.add({
          'category': categoryName,
          'amount': amount,
          'percentage': percentage,
          'color': categoryColors[i % categoryColors.length],
          'icon': categoryIcons[categoryName.toLowerCase()] ?? Icons.category,
        });
      }
    }

    categoryExpenses.value = processedCategories;
  }

  Future<void> exportData() async {
    try {
      isLoading.value = true;

      final accessToken = await UserPreferences().getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final response = await http.get(
        Uri.parse(tExportReportUrl).replace(queryParameters: {
          'format': 'csv',
          'include_receipts': 'true',
        }),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Handle the CSV download response
        Get.snackbar(
          'Export Successful',
          'Data exported successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception('Export failed: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        'Export Failed',
        'Could not export data: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to refresh data
  Future<void> refreshData(String period) async {
    await loadSummaryData(period);
  }

  // Helper method to get spending trends
  Future<Map<String, dynamic>?> getSpendingTrends({
    String period = 'monthly',
    int periodsCount = 12,
  }) async {
    try {
      final accessToken = await UserPreferences().getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final response = await http.get(
        Uri.parse(tSpendingTrendsUrl).replace(queryParameters: {
          'period': period,
          'periods_count': periodsCount.toString(),
        }),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch spending trends: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching spending trends: $e');
      return null;
    }
  }

  // Helper method to get top merchants
  Future<List<Map<String, dynamic>>?> getTopMerchants({
    int limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final accessToken = await UserPreferences().getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final queryParams = <String, String>{
        'limit': limit.toString(),
      };

      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await http.get(
        Uri.parse(tTopMerchantsUrl).replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey('merchants')) {
          return List<Map<String, dynamic>>.from(data['merchants']);
        }
        return [];
      } else {
        throw Exception('Failed to fetch top merchants: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching top merchants: $e');
      return null;
    }
  }

  // Helper method to get expense patterns
  Future<Map<String, dynamic>?> getExpensePatterns() async {
    try {
      final accessToken = await UserPreferences().getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final response = await http.get(
        Uri.parse(tExpensePatternsUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch expense patterns: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching expense patterns: $e');
      return null;
    }
  }
}