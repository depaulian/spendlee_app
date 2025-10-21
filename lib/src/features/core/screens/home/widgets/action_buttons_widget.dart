import 'dart:io';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/screens/home/scan_receipt_screen.dart';
import 'package:expense_tracker/src/features/core/controllers/receipt_scan_controller.dart';
import 'package:expense_tracker/src/features/core/screens/paywall/paywall.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/core/screens/home/add_transaction_screen.dart';
import 'package:image_picker/image_picker.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            title: 'Add Transaction',
            icon: Icons.add,
            color: tSecondaryColor,
            onTap: () {
              Get.to(() => const AddTransactionScreen());
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            title: 'Scan Receipt',
            icon: Icons.camera_alt,
            color: Colors.white,
            textColor: tSecondaryColor,
            onTap: () async {
              await _handleScanReceipt();
            },
          ),
        ),
      ],
    );
  }

  static Future<void> _handleScanReceipt() async {
    final receiptController = Get.find<ReceiptScanController>();

    // Check scan limits first
    await receiptController.checkScanLimits();

    if (!receiptController.canScan.value) {
      // Show paywall screen
      Get.to(() => PaywallScreen(
        source: 'receipt_scan',
        scanData: receiptController.getScanStatus(),
      ));
      return;
    }

    // Show camera/gallery options
    _showImageSourceOptions();
  }

  static void _showImageSourceOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                children: [
                  // Icon with animated background
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          tSecondaryColor,
                          tSecondaryColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: tSecondaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.document_scanner_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    'Scan Receipt',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    'Choose how you\'d like to capture your receipt',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Enhanced scan status badge
                  GetBuilder<ReceiptScanController>(
                    builder: (controller) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: controller.isPremium.value
                              ? [
                            tTertiaryColor.withOpacity(0.1),
                            tTertiaryColor.withOpacity(0.05),
                          ]
                              : [
                            tSuccessColor.withOpacity(0.1),
                            tSuccessColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: controller.isPremium.value
                              ? tTertiaryColor.withOpacity(0.2)
                              : tSuccessColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            controller.isPremium.value
                                ? Icons.workspace_premium_rounded
                                : Icons.check_circle_rounded,
                            size: 16,
                            color: controller.isPremium.value ? tSecondaryColor : tSuccessColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            controller.getStatusMessage(),
                            style: TextStyle(
                              fontSize: 13,
                              color: controller.isPremium.value ? tSecondaryColor : tSuccessColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Options Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildEnhancedScanOption(
                          'Camera',
                          Icons.camera_alt_rounded,
                          'Take a photo',
                          tSecondaryColor,
                              () => _captureReceipt(ImageSource.camera),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildEnhancedScanOption(
                          'Gallery',
                          Icons.photo_library_rounded,
                          'Choose photo',
                          tTertiaryColor,
                              () => _captureReceipt(ImageSource.gallery),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
      exitBottomSheetDuration: const Duration(milliseconds: 200),
    );
  }

  static Widget _buildEnhancedScanOption(
      String title,
      IconData icon,
      String subtitle,
      Color accentColor,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: () {
        Get.back(); // Close bottom sheet
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon container with gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withOpacity(0.1),
                    accentColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 28,
                color: accentColor,
              ),
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _captureReceipt(ImageSource source) async {
    try {
      final receiptController = Get.find<ReceiptScanController>();
      final imageFile = await receiptController.captureReceiptImage(source);

      if (imageFile != null) {
        // Navigate to scan receipt screen
        final result = await Get.to(() => ScanReceiptScreen(
          receiptImage: imageFile,
        ));

        if (result != null && result is Map<String, dynamic>) {
          // Navigate to add transaction with pre-filled data
          final transactionResult = await Get.to(() => AddTransactionScreen(
            initialAmount: result['amount']?.toString(),
            initialDate: result['date']?.toString(),
            initialMerchant: result['merchant'],
            receiptData: result,
          ));

          // If transaction was added, refresh home data
          if (transactionResult == true) {
            // Trigger home refresh if home controller exists
            try {
              final homeController = Get.find<dynamic>(); // Assuming you have a home controller
              if (homeController.refreshData != null) {
                homeController.refreshData();
              }
            } catch (e) {
              // Home controller not found, that's okay
            }
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not access ${source == ImageSource.camera ? 'camera' : 'gallery'}: ${e.toString()}',
        backgroundColor: tErrorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: color == Colors.white
              ? Border.all(color: tSecondaryColor)
              : null,
          boxShadow: [
            BoxShadow(
              color: color == Colors.white
                  ? Colors.black.withOpacity(0.05)
                  : color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: textColor ?? Colors.white,
              size: 18,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}