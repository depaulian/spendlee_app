import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:expense_tracker/src/repository/receipt_repository/receipt_repository.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:path/path.dart' as path;

class ReceiptScanController extends GetxController {
  static ReceiptScanController get instance => Get.find();

  // Dependencies
  final ReceiptRepository _receiptRepo = Get.put(ReceiptRepository());
  final AuthenticationRepository _authRepo = AuthenticationRepository.instance;
  final ImagePicker _picker = ImagePicker();

  // Loading states
  final isUploading = false.obs;
  final isProcessing = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Scan limits and premium status
  final canScan = true.obs;
  final remainingScans = 10.obs;
  final isPremium = false.obs;
  final monthlyScansUsed = 0.obs;
  final monthlyLimit = 10.obs;

  // Receipt data
  final receiptId = Rxn<int>();
  final extractedAmount = Rxn<double>();
  final extractedDate = Rxn<DateTime>();
  final extractedMerchant = Rxn<String>();
  final extractedText = Rxn<String>();

  // Form controllers
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController merchantController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    checkScanLimits();
  }

  @override
  void onClose() {
    amountController.dispose();
    dateController.dispose();
    merchantController.dispose();
    super.onClose();
  }

  void _initializeControllers() {
    // Listen to extracted data changes and update controllers
    ever(extractedAmount, (amount) {
      if (amount != null) {
        amountController.text = amount.toStringAsFixed(2);
      }
    });

    ever(extractedDate, (date) {
      if (date != null) {
        dateController.text = _formatDate(date);
      }
    });

    ever(extractedMerchant, (merchant) {
      if (merchant != null) {
        merchantController.text = merchant;
      }
    });
  }

  // Check current scan limits and update reactive variables
  Future<Map<String, dynamic>> checkScanLimits() async {
    try {
      final result = await _receiptRepo.checkScanLimit();

      if (result['status'] == true && result['data'] != null) {
        final data = result['data'];

        canScan.value = data['can_scan'] ?? true;
        remainingScans.value = data['remaining_scans'] ?? 0;
        isPremium.value = data['is_premium'] ?? false;
        monthlyScansUsed.value = data['monthly_scans_used'] ?? 0;
        monthlyLimit.value = data['monthly_limit'] ?? 10;

        return result;
      } else {
        // Fallback values on error
        canScan.value = true;
        remainingScans.value = 3; // Conservative fallback
        isPremium.value = false;
        monthlyScansUsed.value = 0;

        return {
          'status': true,
          'message': 'Using fallback scan limits',
          'data': getScanStatus()
        };
      }
    } catch (e) {
      print('Error checking scan limits: $e');
      return {
        'status': false,
        'message': 'Failed to check scan limits',
        'data': null
      };
    }
  }

  // Enhanced capture receipt image with proper file handling
  Future<File?> captureReceiptImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        // Create a properly named file with correct extension
        final File originalFile = File(image.path);
        final File properFile = await _createProperlyNamedFile(originalFile);

        print('Original file path: ${originalFile.path}');
        print('Proper file path: ${properFile.path}');

        return properFile;
      }
      return null;
    } catch (e) {
      _handleError('Camera Error', 'Could not access ${source == ImageSource.camera ? 'camera' : 'gallery'}: ${e.toString()}');
      return null;
    }
  }

  // Create a properly named file with correct extension
  Future<File> _createProperlyNamedFile(File originalFile) async {
    try {
      // Generate a proper filename with timestamp and .jpg extension
      final String fileName = 'receipt_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Get the directory of the original file
      final String directory = path.dirname(originalFile.path);

      // Create new file path with proper name
      final String newPath = path.join(directory, fileName);

      // Copy the original file to the new location with proper name
      final File newFile = await originalFile.copy(newPath);

      print('Created properly named file: $newPath');
      print('File size: ${await newFile.length()} bytes');

      // Optionally delete the original file to avoid clutter
      try {
        await originalFile.delete();
      } catch (e) {
        print('Could not delete original file: $e');
      }

      return newFile;
    } catch (e) {
      print('Error creating properly named file: $e');
      // Return original file if copying fails
      return originalFile;
    }
  }

  // Alternative method using bytes approach with proper filename
  Future<File?> captureReceiptImageWithBytes(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        // Read the image as bytes
        final bytes = await image.readAsBytes();

        // Create a proper filename
        final String fileName = 'receipt_${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Get temporary directory
        final Directory tempDir = Directory.systemTemp;
        final String filePath = path.join(tempDir.path, fileName);

        // Write bytes to new file with proper name
        final File properFile = File(filePath);
        await properFile.writeAsBytes(bytes);

        print('Created file from bytes: $filePath');
        print('File size: ${bytes.length} bytes');

        return properFile;
      }
      return null;
    } catch (e) {
      _handleError('Camera Error', 'Could not process image: ${e.toString()}');
      return null;
    }
  }

  // Upload and process receipt
  Future<void> uploadAndProcessReceipt(File receiptFile) async {
    try {
      isUploading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('Uploading receipt file: ${receiptFile.path}');

      final uploadResult = await _receiptRepo.uploadReceipt(receiptFile);

      if (uploadResult['status'] == true && uploadResult['data'] != null) {
        final data = uploadResult['data'];
        receiptId.value = data['receipt_id'];

        _showSuccessSnackbar(
            'Receipt Uploaded',
            'Receipt uploaded successfully. Processing...'
        );

        // Start processing the receipt
        await _processReceipt(data['receipt_id']);

        // Update scan count after successful upload
        updateScanCount();
      } else {
        // Check if it's a paywall error
        if (uploadResult['data'] != null && uploadResult['data']['paywall_triggered'] == true) {
          throw PaywallException(uploadResult['message'] ?? 'Scan limit reached');
        }
        throw Exception(uploadResult['message'] ?? 'Failed to upload receipt');
      }
    } on PaywallException catch (e) {
      _handlePaywallError(e.message);
    } catch (e) {
      print('Error uploading receipt: $e');
      _handleError('Upload failed', e);
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> _processReceipt(int receiptId) async {
    try {
      isProcessing.value = true;

      // Poll for processing completion
      await _pollReceiptStatus(receiptId);
    } catch (e) {
      print('Error processing receipt: $e');
      _handleError('Processing failed', e);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _pollReceiptStatus(int receiptId) async {
    const maxAttempts = 30; // 30 seconds max
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        final result = await _receiptRepo.getReceipt(receiptId);

        if (result['status'] == true && result['data'] != null) {
          final receiptData = result['data'];
          final status = receiptData['status'];

          print('Receipt status: $status');

          switch (status) {
            case 'processed':
              _handleProcessedReceipt(receiptData);
              return;
            case 'failed':
              throw Exception(receiptData['processing_error'] ?? 'Processing failed');
            case 'processing':
            case 'uploaded':
            // Continue polling
              await Future.delayed(const Duration(seconds: 1));
              attempts++;
              break;
            default:
              throw Exception('Unknown receipt status: $status');
          }
        } else {
          throw Exception('Failed to get receipt status');
        }
      } catch (e) {
        if (attempts >= maxAttempts - 1) {
          throw Exception('Processing timeout: ${e.toString()}');
        }
        await Future.delayed(const Duration(seconds: 1));
        attempts++;
      }
    }

    throw Exception('Receipt processing timeout');
  }

  void _handleProcessedReceipt(Map<String, dynamic> receiptData) {
    // Extract data from API response
    if (receiptData['extracted_amount'] != null) {
      extractedAmount.value = (receiptData['extracted_amount'] as num).toDouble();
    }

    if (receiptData['extracted_date'] != null) {
      try {
        extractedDate.value = DateTime.parse(receiptData['extracted_date']);
      } catch (e) {
        print('Error parsing extracted date: $e');
      }
    }

    if (receiptData['extracted_merchant'] != null) {
      extractedMerchant.value = receiptData['extracted_merchant'];
    }

    if (receiptData['extracted_text'] != null) {
      extractedText.value = receiptData['extracted_text'];
    }

    _showSuccessSnackbar(
        'Receipt Processed',
        'Receipt data extracted successfully!'
    );

    print('Receipt processed successfully');
    print('Amount: ${extractedAmount.value}');
    print('Date: ${extractedDate.value}');
    print('Merchant: ${extractedMerchant.value}');
  }

  Future<void> reprocessReceipt() async {
    if (receiptId.value == null) {
      _showErrorSnackbar('Error', 'No receipt to reprocess');
      return;
    }

    try {
      isProcessing.value = true;
      hasError.value = false;

      final result = await _receiptRepo.reprocessReceipt(receiptId.value!);

      if (result['status'] == true) {
        _showSuccessSnackbar(
            'Reprocessing',
            'Receipt is being reprocessed...'
        );

        // Start polling again
        await _pollReceiptStatus(receiptId.value!);
      } else {
        throw Exception(result['message'] ?? 'Failed to reprocess receipt');
      }
    } catch (e) {
      print('Error reprocessing receipt: $e');
      _handleError('Reprocessing failed', e);
    } finally {
      isProcessing.value = false;
    }
  }

  // Update scan count after successful upload
  void updateScanCount() {
    if (!isPremium.value) {
      monthlyScansUsed.value++;
      remainingScans.value = (remainingScans.value - 1).clamp(0, monthlyLimit.value);

      if (remainingScans.value <= 0) {
        canScan.value = false;
      }
    }
  }

  // Reset scan limits after premium upgrade
  void onPremiumUpgrade() {
    isPremium.value = true;
    canScan.value = true;
    remainingScans.value = -1; // Unlimited
  }

  // Set mock data for demo purposes
  void setMockData({
    double? amount,
    DateTime? date,
    String? merchant,
  }) {
    if (amount != null) extractedAmount.value = amount;
    if (date != null) extractedDate.value = date;
    if (merchant != null) extractedMerchant.value = merchant;
  }

  // Get receipt data for transaction creation
  Map<String, dynamic> getReceiptData() {
    final amount = double.tryParse(amountController.text);
    final dateText = dateController.text;
    final merchant = merchantController.text;

    DateTime? parsedDate;
    try {
      if (dateText.isNotEmpty) {
        final parts = dateText.split('/');
        if (parts.length == 3) {
          parsedDate = DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    return {
      'amount': amount,
      'date': parsedDate,
      'merchant': merchant.isNotEmpty ? merchant : null,
      'receipt_id': receiptId.value,
    };
  }

  // Update date
  void updateDate(DateTime newDate) {
    extractedDate.value = newDate;
    dateController.text = _formatDate(newDate);
  }

  // Get scan status for UI display
  Map<String, dynamic> getScanStatus() {
    return {
      'can_scan': canScan.value,
      'remaining_scans': remainingScans.value,
      'is_premium': isPremium.value,
      'monthly_scans_used': monthlyScansUsed.value,
      'monthly_limit': isPremium.value ? -1 : monthlyLimit.value,
      'paywall_triggered': shouldShowPaywall(),
    };
  }

  // Get user-friendly status message
  String getStatusMessage() {
    if (isPremium.value) {
      return 'Premium: Unlimited scans';
    } else if (canScan.value) {
      return '${remainingScans.value} scans remaining this month';
    } else {
      return 'Monthly scan limit reached';
    }
  }

  // Check if paywall should be shown
  bool shouldShowPaywall() {
    return !isPremium.value && !canScan.value;
  }

  // Reset all data
  void resetData() {
    receiptId.value = null;
    extractedAmount.value = null;
    extractedDate.value = null;
    extractedMerchant.value = null;
    extractedText.value = null;
    amountController.clear();
    dateController.clear();
    merchantController.clear();
    hasError.value = false;
    errorMessage.value = '';
  }

  // Getters
  bool get hasExtractedData =>
      extractedAmount.value != null ||
          extractedDate.value != null ||
          extractedMerchant.value != null;

  bool get isLoading => isUploading.value || isProcessing.value;

  String get statusMessage {
    if (isUploading.value) return 'Uploading receipt...';
    if (isProcessing.value) return 'Processing receipt...';
    if (hasError.value) return errorMessage.value;
    if (hasExtractedData) return 'Receipt processed successfully!';
    return 'Ready to scan receipt';
  }

  // Private helper methods
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _handleError(String message, dynamic error) {
    hasError.value = true;
    errorMessage.value = message;

    String errorDetail = error.toString();
    if (errorDetail.contains('paywall')) {
      errorDetail = 'You have reached your free scan limit. Upgrade to premium for unlimited scans.';
    } else if (errorDetail.contains('network')) {
      errorDetail = 'Network error. Please check your connection.';
    } else if (errorDetail.contains('unauthorized')) {
      errorDetail = 'Session expired. Please log in again.';
    }

    _showErrorSnackbar(message, errorDetail);
  }

  void _handlePaywallError(String message) {
    hasError.value = true;
    errorMessage.value = message;
    // Don't show snackbar for paywall errors, let the UI handle it
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: tSuccessColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: tErrorColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }
}

// Custom exception for paywall scenarios
class PaywallException implements Exception {
  final String message;
  PaywallException(this.message);
}