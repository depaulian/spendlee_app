import 'dart:io';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart' show AuthenticationRepository;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/receipt_scan_controller.dart';

class ScanReceiptScreen extends StatefulWidget {
  final String? amount;
  final String? date;
  final String? merchant;
  final File? receiptImage;

  const ScanReceiptScreen({
    super.key,
    this.amount,
    this.date,
    this.merchant,
    this.receiptImage,
  });

  @override
  State<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends State<ScanReceiptScreen>
    with TickerProviderStateMixin {
  late ReceiptScanController controller;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  final authRepo = AuthenticationRepository.instance;
  File? _lastUploadedFile;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ReceiptScanController());

    // Initialize animations
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _initializeData();

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _initializeData() {
    if (widget.receiptImage != null) {
      _lastUploadedFile = widget.receiptImage!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.uploadAndProcessReceipt(widget.receiptImage!);
      });
    } else {
      controller.setMockData(
        amount: widget.amount != null ? double.tryParse(widget.amount!) : 7.25,
        date: _parseDate(widget.date) ?? DateTime.now(),
        merchant: widget.merchant ?? 'Gas Station',
      );
    }
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return null;
  }

  Future<void> _scanAgain() async {
    try {
      final imageFile = await controller.captureReceiptImage(ImageSource.camera);
      if (imageFile != null) {
        controller.resetData();
        _lastUploadedFile = imageFile;
        await controller.uploadAndProcessReceipt(imageFile);
      }
    } catch (e) {
      Get.snackbar(
        'Camera Error',
        'Could not access camera: ${e.toString()}',
        backgroundColor: tErrorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final imageFile = await controller.captureReceiptImage(ImageSource.gallery);
      if (imageFile != null) {
        controller.resetData();
        _lastUploadedFile = imageFile;
        await controller.uploadAndProcessReceipt(imageFile);
      }
    } catch (e) {
      Get.snackbar(
        'Gallery Error',
        'Could not access gallery: ${e.toString()}',
        backgroundColor: tErrorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _useThisData() {
    final data = controller.getReceiptData();

    if (data['amount'] == null || data['amount'] <= 0) {
      Get.snackbar(
        'Invalid Amount',
        'Please enter a valid amount',
        backgroundColor: tErrorColor,
        colorText: Colors.white,
      );
      return;
    }

    if (data['date'] == null) {
      Get.snackbar(
        'Invalid Date',
        'Please select a valid date',
        backgroundColor: tErrorColor,
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      'Receipt Data Used',
      'Transaction details filled from receipt',
      backgroundColor: tSuccessColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    Navigator.of(context).pop(data);
  }

  void _showImageSourceDialog() {
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
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [tSecondaryColor, tSecondaryColor.withOpacity(0.8)],
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
                      Icons.camera_alt_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Image Source',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSourceOption(
                          'Camera',
                          Icons.camera_alt_rounded,
                          'Take a photo',
                          tSecondaryColor,
                              () {
                            Navigator.pop(context);
                            _scanAgain();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSourceOption(
                          'Gallery',
                          Icons.photo_library_rounded,
                          'Choose photo',
                          tTertiaryColor,
                              () {
                            Navigator.pop(context);
                            _pickFromGallery();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSourceOption(
      String title,
      IconData icon,
      String subtitle,
      Color color,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: _buildContent(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tPrimaryColor.withOpacity(0.05),
            tSecondaryColor.withOpacity(0.02),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [tPrimaryColor, tPrimaryColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: tPrimaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.document_scanner_rounded,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receipt Scanner',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'AI-powered receipt processing',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.close_rounded, size: 24),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Obx(() {
      if (controller.isLoading) {
        return _buildLoadingView();
      } else if (controller.hasError.value) {
        return _buildErrorView();
      } else {
        return _buildScannedView();
      }
    });
  }

  Widget _buildLoadingView() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tPrimaryColor.withOpacity(0.05),
                tSecondaryColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [tPrimaryColor, tSecondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: tPrimaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => Text(
                controller.statusMessage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              )),
              const SizedBox(height: 8),
              Text(
                controller.isUploading.value
                    ? 'Uploading your receipt securely...'
                    : 'Extracting transaction details...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildErrorView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: controller.isDuplicateError.value
                ? Colors.orange.withOpacity(0.05)
                : tErrorColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: controller.isDuplicateError.value
                  ? Colors.orange.withOpacity(0.1)
                  : tErrorColor.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: controller.isDuplicateError.value
                      ? Colors.orange.withOpacity(0.1)
                      : tErrorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  controller.isDuplicateError.value
                      ? Icons.warning_rounded
                      : Icons.error_outline_rounded,
                  size: 48,
                  color: controller.isDuplicateError.value
                      ? Colors.orange.shade600
                      : tErrorColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                controller.isDuplicateError.value
                    ? 'Duplicate Receipt Detected'
                    : 'Processing Failed',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Text(
                controller.errorMessage.value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              )),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Show different buttons based on error type
        Obx(() {
          if (controller.isDuplicateError.value) {
            // Duplicate-specific buttons
            return Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: 'Cancel',
                    icon: Icons.cancel_outlined,
                    isSecondary: true,
                    onPressed: _showImageSourceDialog, // Let them pick a different file
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    label: 'Upload Anyway',
                    icon: Icons.upload_rounded,
                    isSecondary: false,
                    onPressed: () async {
                      // Trigger force upload - you'll need to store the file reference
                      if (_lastUploadedFile != null) {
                        await controller.uploadAndProcessReceipt(_lastUploadedFile!, forceUpload: true);
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            // Regular error buttons
            return Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: 'Try Again',
                    icon: Icons.refresh_rounded,
                    isSecondary: true,
                    onPressed: _showImageSourceDialog,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    label: 'Reprocess',
                    icon: Icons.auto_fix_high_rounded,
                    isSecondary: false,
                    onPressed: controller.receiptId.value != null
                        ? controller.reprocessReceipt
                        : null,
                  ),
                ),
              ],
            );
          }
        }),
      ],
    );
  }

  Widget _buildScannedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // Success indicator
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tSuccessColor.withOpacity(0.1),
                tSuccessColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tSuccessColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tSuccessColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: tSuccessColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() => Text(
                  controller.hasExtractedData
                      ? 'Receipt processed successfully!'
                      : 'Receipt data ready for review',
                  style: const TextStyle(
                    color: tSuccessColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                )),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Form fields
        _buildFormField(
          label: 'Amount',
          controller: controller.amountController,
          icon: Icons.money,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefixText: authRepo.currentCurrency.code,
          hintText: '0.00',
        ),

        const SizedBox(height: 24),

        _buildFormField(
          label: 'Date',
          controller: controller.dateController,
          icon: Icons.calendar_today_rounded,
          readOnly: true,
          hintText: 'Select date',
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: controller.extractedDate.value ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: tPrimaryColor,
                      onPrimary: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              controller.updateDate(picked);
            }
          },
        ),

        const SizedBox(height: 24),

        _buildFormField(
          label: 'Merchant',
          controller: controller.merchantController,
          icon: Icons.store_rounded,
          hintText: 'Enter merchant name',
        ),

        // Extracted text section
        Obx(() {
          if (controller.extractedText.value != null &&
              controller.extractedText.value!.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                ExpansionTile(
                  title: const Text(
                    'Raw Extracted Text',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  leading: Icon(
                    Icons.text_snippet_rounded,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        controller.extractedText.value!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontFamily: 'monospace',
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),

        const SizedBox(height: 32),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                label: 'Scan Again',
                icon: Icons.camera_alt_rounded,
                isSecondary: true,
                onPressed: _showImageSourceDialog,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                label: 'Use This Data',
                icon: Icons.check_rounded,
                isSecondary: false,
                onPressed: _useThisData,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Help text
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: Colors.amber[700],
                size: 20,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'You can edit the extracted information above before confirming',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? prefixText,
    String? hintText,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            style: TextStyle(color: tPrimaryColor),
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: tPrimaryColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Container(
                margin: const EdgeInsets.only(right: 12),
                child: Icon(icon, color: tPrimaryColor, size: 20),
              ),
              prefixText: prefixText,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isSecondary,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isSecondary
                ? Colors.black.withOpacity(0.05)
                : tPrimaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.white : tPrimaryColor,
          foregroundColor: isSecondary ? Colors.black87 : Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSecondary
                ? BorderSide(color: Colors.grey.shade300)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}