import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/repository/authentication_repository/auth_repository.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:expense_tracker/src/repository/preferences/user_preferences.dart';
import 'package:expense_tracker/src/features/core/controllers/home_controller.dart';
import 'package:expense_tracker/src/features/core/controllers/transaction_list_controller.dart';
import 'package:expense_tracker/src/features/core/controllers/summary_controller.dart';

class CurrencyController extends GetxController {
  static CurrencyController get instance => Get.find();

  // Repositories
  final AuthRepository _authRepo = AuthRepository.instance;
  final AuthenticationRepository _authenticationRepo = AuthenticationRepository.instance;
  final UserPreferences _userPreferences = UserPreferences();

  // Loading state
  final isLoading = false.obs;
  final statusMessage = 'Ready'.obs;

  Future<bool> setCurrency(String currencyCode) async {
    try {
      isLoading.value = true;
      statusMessage.value = 'Updating currency...';

      // Get access token
      final accessToken = await _userPreferences.getAccessToken();
      if (accessToken == null) {
        _showErrorMessage('You need to be logged in to change currency');
        return false;
      }

      statusMessage.value = 'Saving to server...';
      // Call API to set default currency
      final result = await _authRepo.setDefaultCurrency(currencyCode, accessToken);

      if (result['status'] == true) {
        statusMessage.value = 'Updating local settings...';
        // Update local preferences
        await _userPreferences.setCurrency(currencyCode);
        
        // Update user object with new default currency and mark as manually set
        final currentUser = await _userPreferences.getUser();
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            defaultCurrency: currencyCode,
            isDefaultCurrencyManuallySet: true,
          );
          await _userPreferences.saveUser(updatedUser);
        }
        
        statusMessage.value = 'Updating interface...';
        // Immediately update the currency in AuthenticationRepository for UI reactivity
        await _authenticationRepo.setCurrency(currencyCode);
        
        // Refresh user data to get updated currency
        await _authenticationRepo.refreshUserData();
        
        statusMessage.value = 'Converting amounts...';
        // Add a small delay to ensure backend has processed the currency change
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Reload all home data since backend handles currency conversions
        await _refreshAllControllers();
        
        statusMessage.value = 'Complete!';
        return true;
      } else {
        _showErrorMessage(result['message'] ?? 'Failed to update currency');
        return false;
      }
    } catch (e) {
      print('Error updating currency: $e');
      _showErrorMessage('An error occurred while updating currency');
      return false;
    } finally {
      isLoading.value = false;
      statusMessage.value = 'Ready';
    }
  }

  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _refreshAllControllers() async {
    try {
      print('Starting controller refresh after currency change...');
      
      // Refresh home controller data (balances, recent transactions, budgets)
      if (Get.isRegistered<HomeController>()) {
        print('Refreshing HomeController...');
        await Get.find<HomeController>().refreshData();
        print('HomeController refreshed');
      }

      // Refresh transaction list controller 
      if (Get.isRegistered<TransactionsListController>()) {
        print('Refreshing TransactionsListController...');
        await Get.find<TransactionsListController>().refreshTransactions();
        print('TransactionsListController refreshed');
      }

      // Refresh summary controller with default monthly period
      if (Get.isRegistered<SummaryController>()) {
        print('Refreshing SummaryController...');
        await Get.find<SummaryController>().refreshData('monthly');
        print('SummaryController refreshed');
      }
      
      print('All controllers refreshed successfully');
    } catch (e) {
      print('Error refreshing controllers after currency change: $e');
      // Don't throw error as currency change was successful
    }
  }
}