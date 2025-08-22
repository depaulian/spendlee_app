import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/external_endpoints.dart';
import 'package:expense_tracker/src/repository/preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class ReceiptRepository extends GetxController {
  static ReceiptRepository get instance => Get.find();

  final UserPreferences userPreferences = UserPreferences();

  // Single robust upload method using raw HTTP client
  Future<Map<String, dynamic>> uploadReceipt(File receiptFile) async {
    try {
      final accessToken = await userPreferences.getAccessToken();
      if (accessToken == null) {
        return {
          'status': false,
          'message': 'No access token found',
          'data': null
        };
      }

      // Validate file exists
      if (!await receiptFile.exists()) {
        return {
          'status': false,
          'message': 'Selected file does not exist',
          'data': {'error_type': 'file_not_found'}
        };
      }

      // Read file and get basic info
      final fileBytes = await receiptFile.readAsBytes();
      final fileName = receiptFile.path.split('/').last;
      final extension = fileName.toLowerCase().split('.').last;

      // Check file size
      const maxFileSize = 10 * 1024 * 1024; // 10MB
      if (fileBytes.length > maxFileSize) {
        return {
          'status': false,
          'message': 'File too large. Maximum size is 10MB.',
          'data': {'error_type': 'file_size'}
        };
      }

      // Determine content type from extension
      String contentType;
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          contentType = 'image/jpeg';
          break;
        case 'png':
          contentType = 'image/png';
          break;
        case 'gif':
          contentType = 'image/gif';
          break;
        case 'pdf':
          contentType = 'application/pdf';
          break;
        default:
          contentType = 'image/jpeg';
          break;
      }

      print('Uploading receipt: ${receiptFile.path}');
      print('File size: ${fileBytes.length} bytes');
      print('Content type: $contentType');

      // Use raw HTTP client for maximum control
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 60);

      try {
        // Create request
        final request = await client.postUrl(Uri.parse(tReceiptUploadUrl));

        // Generate boundary
        final boundary = '----formdata-flutter-${DateTime.now().millisecondsSinceEpoch}';

        // Build multipart body
        final List<int> body = [];

        // Opening boundary
        body.addAll(utf8.encode('--$boundary\r\n'));

        // Content-Disposition header
        body.addAll(utf8.encode('Content-Disposition: form-data; name="file"; filename="$fileName"\r\n'));

        // Content-Type header
        body.addAll(utf8.encode('Content-Type: $contentType\r\n\r\n'));

        // File content
        body.addAll(fileBytes);

        // Closing boundary
        body.addAll(utf8.encode('\r\n--$boundary--\r\n'));

        // Set headers
        request.headers.set('Authorization', 'Bearer $accessToken');
        request.headers.set('Content-Type', 'multipart/form-data; boundary=$boundary');
        request.headers.set('Content-Length', body.length.toString());

        // Add body
        request.add(body);

        // Send request
        final response = await request.close();

        // Read response
        final responseBody = await response.transform(utf8.decoder).join();

        print('Upload response status: ${response.statusCode}');
        print('Upload response body: $responseBody');

        return _handleUploadResponse(response.statusCode, responseBody);

      } finally {
        client.close();
      }

    } catch (error) {
      print('Error uploading receipt: $error');
      return _handleUploadError(error);
    }
  }

  // Handle upload response
  Map<String, dynamic> _handleUploadResponse(int statusCode, String responseBody) {
    if (statusCode == 200) {
      final responseData = jsonDecode(responseBody);

      // Check if paywall was triggered in successful response
      if (responseData['paywall_triggered'] == true) {
        return {
          'status': false,
          'message': 'Monthly scan limit reached',
          'data': {
            'paywall_triggered': true,
            'remaining_free_scans': responseData['remaining_free_scans'] ?? 0,
            'is_premium_required': true,
          }
        };
      }

      return {
        'status': true,
        'message': 'Receipt uploaded successfully',
        'data': responseData
      };
    } else if (statusCode == 400) {
      final errorData = jsonDecode(responseBody);
      String errorMessage = errorData['detail'] ?? 'Invalid file format';

      if (errorMessage.contains('File type')) {
        errorMessage = 'Unsupported file type. Please upload a valid image (JPG, PNG) or PDF.';
      }

      return {
        'status': false,
        'message': errorMessage,
        'data': {
          'error_type': 'validation',
          'details': errorData,
        }
      };
    } else if (statusCode == 402) {
      final errorData = jsonDecode(responseBody);
      return {
        'status': false,
        'message': 'Monthly scan limit reached. Upgrade to Premium for unlimited scans.',
        'data': {
          'paywall_triggered': true,
          'remaining_free_scans': 0,
          'is_premium_required': true,
          'detail': errorData['detail'] ?? 'Payment required'
        }
      };
    } else if (statusCode == 413) {
      return {
        'status': false,
        'message': 'File too large. Please choose a smaller image (max 10MB).',
        'data': {'error_type': 'file_size'}
      };
    } else if (statusCode == 415) {
      return {
        'status': false,
        'message': 'Unsupported file type. Please upload a valid image (JPG, PNG) or PDF.',
        'data': {'error_type': 'file_type'}
      };
    } else if (statusCode == 429) {
      return {
        'status': false,
        'message': 'Too many requests. Please try again later.',
        'data': {'retry_after': '60'}
      };
    } else {
      final errorData = jsonDecode(responseBody);
      return {
        'status': false,
        'message': errorData['detail'] ?? 'Failed to upload receipt',
        'data': errorData
      };
    }
  }

  // Handle upload errors
  Map<String, dynamic> _handleUploadError(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return {
        'status': false,
        'message': 'Network connection error. Please check your internet connection.',
        'data': {'error_type': 'network'}
      };
    }

    if (error.toString().contains('TimeoutException') ||
        error.toString().contains('timeout')) {
      return {
        'status': false,
        'message': 'Upload timeout. Please try again.',
        'data': {'error_type': 'timeout'}
      };
    }

    return {
      'status': false,
      'message': 'Upload failed. Please try again.',
      'data': {'error_type': 'unknown', 'details': error.toString()}
    };
  }

  // Get receipt information by ID
  Future<Map<String, dynamic>> getReceipt(int receiptId) async {
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
        Uri.parse('$tReceiptsUrl$receiptId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Receipt retrieved successfully',
          'data': responseData
        };
      } else if (response.statusCode == 404) {
        return {
          'status': false,
          'message': 'Receipt not found',
          'data': null
        };
      } else if (response.statusCode == 403) {
        return {
          'status': false,
          'message': 'Access denied to this receipt',
          'data': null
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to retrieve receipt',
          'data': null
        };
      }
    } catch (error) {
      print('Error getting receipt: $error');
      return {
        'status': false,
        'message': 'Network error occurred while retrieving receipt',
        'data': error.toString()
      };
    }
  }

  // Get all user receipts with pagination
  Future<Map<String, dynamic>> getUserReceipts({
    int skip = 0,
    int limit = 100,
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

      final queryParams = {
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      final response = await http.get(
        Uri.parse(tReceiptsUrl).replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        return {
          'status': true,
          'message': 'Receipts retrieved successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to retrieve receipts',
          'data': []
        };
      }
    } catch (error) {
      print('Error getting receipts: $error');
      return {
        'status': false,
        'message': 'Network error occurred while retrieving receipts',
        'data': error.toString()
      };
    }
  }

  // Reprocess a failed receipt
  Future<Map<String, dynamic>> reprocessReceipt(int receiptId) async {
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
        Uri.parse('$tReceiptsUrl$receiptId/reprocess'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Receipt reprocessing started',
          'data': responseData
        };
      } else if (response.statusCode == 402) {
        return {
          'status': false,
          'message': 'Premium subscription required for reprocessing',
          'data': {
            'paywall_triggered': true,
            'is_premium_required': true,
          }
        };
      } else if (response.statusCode == 404) {
        return {
          'status': false,
          'message': 'Receipt not found',
          'data': null
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': 'Failed to reprocess receipt',
          'data': errorData['detail'] ?? 'Reprocessing failed'
        };
      }
    } catch (error) {
      print('Error reprocessing receipt: $error');
      return {
        'status': false,
        'message': 'Network error occurred during reprocessing',
        'data': error.toString()
      };
    }
  }

  // Delete a receipt
  Future<Map<String, dynamic>> deleteReceipt(int receiptId) async {
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
        Uri.parse('$tReceiptsUrl$receiptId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 204) {
        return {
          'status': true,
          'message': 'Receipt deleted successfully',
          'data': null
        };
      } else if (response.statusCode == 404) {
        return {
          'status': false,
          'message': 'Receipt not found',
          'data': null
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to delete receipt',
          'data': null
        };
      }
    } catch (error) {
      print('Error deleting receipt: $error');
      return {
        'status': false,
        'message': 'Network error occurred while deleting receipt',
        'data': error.toString()
      };
    }
  }

  // Check scan limits
  Future<Map<String, dynamic>> checkScanLimit() async {
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
        Uri.parse('$tBaseUrl/users/premium-status'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final isPremium = responseData['is_premium'] ?? false;
        final monthlyScansUsed = responseData['monthly_scans_used'] ?? 0;
        const monthlyFreeLimit = 10;

        final remainingScans = isPremium ? -1 : (monthlyFreeLimit - monthlyScansUsed);
        final canScan = isPremium || remainingScans > 0;

        return {
          'status': true,
          'message': 'Scan limit checked successfully',
          'data': {
            'can_scan': canScan,
            'remaining_scans': isPremium ? -1 : remainingScans.clamp(0, monthlyFreeLimit),
            'is_premium': isPremium,
            'monthly_scans_used': monthlyScansUsed,
            'monthly_limit': isPremium ? -1 : monthlyFreeLimit,
            'trial_end_date': responseData['trial_end_date'],
            'scan_reset_date': _getNextMonthResetDate(),
          }
        };
      } else {
        return {
          'status': true,
          'message': 'Scan limit checked (fallback)',
          'data': {
            'can_scan': true,
            'remaining_scans': 5,
            'is_premium': false,
            'monthly_scans_used': 0,
            'monthly_limit': 10,
            'scan_reset_date': _getNextMonthResetDate(),
          }
        };
      }
    } catch (error) {
      print('Error checking scan limit: $error');
      return {
        'status': true,
        'message': 'Scan limit check failed, assuming limited access',
        'data': {
          'can_scan': true,
          'remaining_scans': 3,
          'is_premium': false,
          'monthly_scans_used': 0,
          'monthly_limit': 10,
          'scan_reset_date': _getNextMonthResetDate(),
        }
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
        Uri.parse('$tBaseUrl/users/premium-status'),
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

  // Upgrade user to premium
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

  String _getNextMonthResetDate() {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, 1);
    return nextMonth.toIso8601String().split('T')[0];
  }

  // Helper methods
  bool isPaywallTriggered(Map<String, dynamic> response) {
    if (response['status'] == false && response['data'] != null) {
      final data = response['data'];
      return data['paywall_triggered'] == true || data['is_premium_required'] == true;
    }
    return false;
  }

  int getRemainingScans(Map<String, dynamic> response) {
    if (response['data'] != null) {
      return response['data']['remaining_scans'] ?? 0;
    }
    return 0;
  }

  bool isPremiumUser(Map<String, dynamic> response) {
    if (response['data'] != null) {
      return response['data']['is_premium'] == true;
    }
    return false;
  }

  String getErrorType(Map<String, dynamic> response) {
    if (response['data'] != null && response['data']['error_type'] != null) {
      return response['data']['error_type'];
    }
    return 'unknown';
  }
}