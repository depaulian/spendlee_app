import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/external_endpoints.dart';
import 'package:expense_tracker/src/repository/preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class PaywallRepository extends GetxController {
  static PaywallRepository get instance => Get.find();

  final UserPreferences userPreferences = UserPreferences();

  // Get subscription pricing plans
  Future<Map<String, dynamic>> getPricingPlans() async {
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
        Uri.parse(tPricingUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));


      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Pricing plans retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to get pricing plans',
          'data': null
        };
      }
    } catch (error) {
      print('Error getting pricing plans: $error');
      return {
        'status': false,
        'message': 'Network error occurred while getting pricing',
        'data': error.toString()
      };
    }
  }

  // Get user's premium status and subscription details
  Future<Map<String, dynamic>> getPremiumStatus() async {
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
        Uri.parse(tPremiumStatusUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Premium status retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to get premium status',
          'data': null
        };
      }
    } catch (error) {
      print('Error getting premium status: $error');
      return {
        'status': false,
        'message': 'Network error occurred while checking premium status',
        'data': error.toString()
      };
    }
  }

  // Get paywall information
  Future<Map<String, dynamic>> getPaywallInfo() async {
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
        Uri.parse('$tBaseUrl/users/subscription/paywall'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Paywall info retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to get paywall info',
          'data': null
        };
      }
    } catch (error) {
      print('Error getting paywall info: $error');
      return {
        'status': false,
        'message': 'Network error occurred while getting paywall info',
        'data': error.toString()
      };
    }
  }

  // Get purchase URL for a specific product (for web purchases)
  Future<Map<String, dynamic>> getPurchaseUrl(String productId) async {
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
        Uri.parse('$tBaseUrl/users/subscription/purchase-url/$productId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Purchase URL retrieved successfully',
          'data': responseData
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': errorData['detail'] ?? 'Failed to get purchase URL',
          'data': errorData
        };
      }
    } catch (error) {
      print('Error getting purchase URL: $error');
      return {
        'status': false,
        'message': 'Network error occurred while getting purchase URL',
        'data': error.toString()
      };
    }
  }

  // Sync subscription status with RevenueCat
  Future<Map<String, dynamic>> syncSubscriptionStatus() async {
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
        Uri.parse('$tBaseUrl/users/subscription/sync'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Subscription status synced successfully',
          'data': responseData
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': errorData['detail'] ?? 'Failed to sync subscription status',
          'data': errorData
        };
      }
    } catch (error) {
      print('Error syncing subscription status: $error');
      return {
        'status': false,
        'message': 'Network error occurred during sync',
        'data': error.toString()
      };
    }
  }

  // Get subscription management URL
  Future<Map<String, dynamic>> getManagementUrl() async {
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
        Uri.parse('$tBaseUrl/users/subscription/management-url'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Management URL retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to get management URL',
          'data': null
        };
      }
    } catch (error) {
      print('Error getting management URL: $error');
      return {
        'status': false,
        'message': 'Network error occurred while getting management URL',
        'data': error.toString()
      };
    }
  }

  // Check feature access
  Future<Map<String, dynamic>> checkFeatureAccess(String feature) async {
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
        Uri.parse('$tBaseUrl/users/subscription/features/$feature'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Feature access checked successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to check feature access',
          'data': null
        };
      }
    } catch (error) {
      print('Error checking feature access: $error');
      return {
        'status': false,
        'message': 'Network error occurred while checking feature access',
        'data': error.toString()
      };
    }
  }

  // Demo upgrade method (for testing - will be replaced with RevenueCat)
  Future<Map<String, dynamic>> upgradeToPremium() async {
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
        Uri.parse('$tBaseUrl/users/upgrade-premium'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Successfully upgraded to premium',
          'data': responseData
        };
      } else if (response.statusCode == 409) {
        return {
          'status': false,
          'message': 'User is already premium',
          'data': null
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': errorData['detail'] ?? 'Failed to upgrade to premium',
          'data': errorData
        };
      }
    } catch (error) {
      print('Error upgrading to premium: $error');
      return {
        'status': false,
        'message': 'Network error occurred during premium upgrade',
        'data': error.toString()
      };
    }
  }

  // Helper methods
  bool isPaywallTriggered(Map<String, dynamic> response) {
    if (response['status'] == false && response['data'] != null) {
      final data = response['data'];
      return data['paywall_triggered'] == true || data['is_premium_required'] == true;
    }
    return false;
  }

  bool isPremiumUser(Map<String, dynamic> response) {
    if (response['data'] != null) {
      return response['data']['is_premium'] == true;
    }
    return false;
  }

  int getRemainingScans(Map<String, dynamic> response) {
    if (response['data'] != null) {
      return response['data']['remaining_scans'] ?? 0;
    }
    return 0;
  }
}