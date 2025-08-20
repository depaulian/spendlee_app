import 'dart:convert';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/external_endpoints.dart';
import 'package:expense_tracker/src/repository/preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class TransactionRepository extends GetxController {
  static TransactionRepository get instance => Get.find();

  final UserPreferences userPreferences = UserPreferences();

  // Create a new transaction (expense or income)
  Future<Map<String, dynamic>> createTransaction({
    required double amount,
    required String description,
    required String category,
    required String transactionType, // 'expense' or 'income'
    required DateTime expenseDate,
    String? notes,
  }) async {
    try {
      final accessToken = await userPreferences.getAccessToken();
      if (accessToken == null) {
        return {
          'status': false,
          'message': 'No access token found',
          'data': null
        };
      }

      final response = await http.post(
        Uri.parse(tTransactionsUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': amount,
          'description': description,
          'category': category,
          'transaction_type': transactionType,
          'expense_date': expenseDate.toIso8601String(),
          'notes': notes,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Transaction created successfully',
          'data': responseData
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': 'Failed to create transaction',
          'data': errorData['detail'] ?? 'Unknown error'
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Get all transactions with filters
  Future<Map<String, dynamic>> getTransactions({
    int skip = 0,
    int limit = 100,
    String? category,
    String? transactionType,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
  }) async {
    try {
      final accessToken = await userPreferences.getAccessToken();
      if (accessToken == null) {
        return {
          'status': false,
          'message': 'No access token found',
          'data': []
        };
      }

      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      if (category != null) queryParams['category'] = category;
      if (transactionType != null) queryParams['transaction_type'] = transactionType;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
      if (minAmount != null) queryParams['min_amount'] = minAmount.toString();
      if (maxAmount != null) queryParams['max_amount'] = maxAmount.toString();

      final response = await http.get(
        Uri.parse(tTransactionsUrl).replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        return {
          'status': true,
          'message': 'Transactions retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to retrieve transactions',
          'data': []
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Get expenses only
  Future<Map<String, dynamic>> getExpenses({
    int skip = 0,
    int limit = 100,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
  }) async {
    try {
      final accessToken = await userPreferences.getAccessToken();
      if (accessToken == null) {
        return {
          'status': false,
          'message': 'No access token found',
          'data': []
        };
      }

      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      if (category != null) queryParams['category'] = category;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
      if (minAmount != null) queryParams['min_amount'] = minAmount.toString();
      if (maxAmount != null) queryParams['max_amount'] = maxAmount.toString();

      final response = await http.get(
        Uri.parse(tExpensesUrl).replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        return {
          'status': true,
          'message': 'Expenses retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to retrieve expenses',
          'data': []
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Get income only
  Future<Map<String, dynamic>> getIncome({
    int skip = 0,
    int limit = 100,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
  }) async {
    try {
      final accessToken = await userPreferences.getAccessToken();
      if (accessToken == null) {
        return {
          'status': false,
          'message': 'No access token found',
          'data': []
        };
      }

      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      if (category != null) queryParams['category'] = category;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
      if (minAmount != null) queryParams['min_amount'] = minAmount.toString();
      if (maxAmount != null) queryParams['max_amount'] = maxAmount.toString();

      final response = await http.get(
        Uri.parse(tIncomeUrl).replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        return {
          'status': true,
          'message': 'Income retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to retrieve income',
          'data': []
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Get balance summary
  Future<Map<String, dynamic>> getBalance({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final accessToken = await userPreferences.getAccessToken();
      if (accessToken == null) {
        return {
          'status': false,
          'message': 'No access token found',
          'data': null
        };
      }

      final queryParams = <String, String>{};
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

      final response = await http.get(
        Uri.parse(tBalanceUrl).replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Balance retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to retrieve balance',
          'data': null
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Get specific transaction by ID
  Future<Map<String, dynamic>> getTransaction(int transactionId) async {
    try {
      final accessToken = await userPreferences.getAccessToken();
      if (accessToken == null) {
        return {
          'status': false,
          'message': 'No access token found',
          'data': null
        };
      }

      final response = await http.get(
        Uri.parse('$tTransactionsUrl$transactionId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Transaction retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to retrieve transaction',
          'data': null
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Update transaction
  Future<Map<String, dynamic>> updateTransaction({
    required int transactionId,
    double? amount,
    String? description,
    String? category,
    String? transactionType,
    DateTime? expenseDate,
    String? notes,
  }) async {
    try {
      final accessToken = await userPreferences.getAccessToken();
      if (accessToken == null) {
        return {
          'status': false,
          'message': 'No access token found',
          'data': null
        };
      }

      final Map<String, dynamic> updateData = {};
      if (amount != null) updateData['amount'] = amount;
      if (description != null) updateData['description'] = description;
      if (category != null) updateData['category'] = category;
      if (transactionType != null) updateData['transaction_type'] = transactionType;
      if (expenseDate != null) updateData['expense_date'] = expenseDate.toIso8601String();
      if (notes != null) updateData['notes'] = notes;

      final response = await http.put(
        Uri.parse('$tTransactionsUrl$transactionId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Transaction updated successfully',
          'data': responseData
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': 'Failed to update transaction',
          'data': errorData['detail'] ?? 'Unknown error'
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Delete transaction
  Future<Map<String, dynamic>> deleteTransaction(int transactionId) async {
    try {
      final accessToken = await userPreferences.getAccessToken();
      if (accessToken == null) {
        return {
          'status': false,
          'message': 'No access token found',
          'data': null
        };
      }

      final response = await http.delete(
        Uri.parse('$tTransactionsUrl$transactionId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        return {
          'status': true,
          'message': 'Transaction deleted successfully',
          'data': null
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to delete transaction',
          'data': null
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Get transactions by category
  Future<Map<String, dynamic>> getTransactionsByCategory({
    required String category,
    int skip = 0,
    int limit = 100,
    String? transactionType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final accessToken = await userPreferences.getAccessToken();
      if (accessToken == null) {
        return {
          'status': false,
          'message': 'No access token found',
          'data': []
        };
      }

      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      if (transactionType != null) queryParams['transaction_type'] = transactionType;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

      final response = await http.get(
        Uri.parse('${tTransactionsUrl}category/$category').replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        return {
          'status': true,
          'message': 'Transactions retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to retrieve transactions',
          'data': []
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Get available categories
  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(tCategoriesUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Categories retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to retrieve categories',
          'data': null
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }
}