import 'package:expense_tracker/src/features/core/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/add_transaction_controller.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  AddTransactionScreenState createState() => AddTransactionScreenState();
}

class AddTransactionScreenState extends State<AddTransactionScreen> {
  late AddTransactionController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AddTransactionController());
  }

  @override
  void dispose() {
    Get.delete<AddTransactionController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Add Transaction',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: Obx(() => ElevatedButton(
            onPressed: controller.isFormValid.value && !controller.isLoading.value
                ? _handleSave
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: tPrimaryColor,
              disabledBackgroundColor: Colors.white38,
              disabledForegroundColor: Colors.white60,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(tPrimaryColor),
              ),
            )
                : const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          )),
        ),
      ],
      backgroundColor: tPrimaryColor,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoadingCategories.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(tPrimaryColor),
              ),
              SizedBox(height: 16),
              Text(
                'Loading categories...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTypeSelector(),
            const SizedBox(height: 24),
            _buildAmountInput(),
            const SizedBox(height: 24),
            _buildCategorySection(),
            const SizedBox(height: 24),
            _buildDateSection(),
            const SizedBox(height: 20),
            _buildNoteSection(),
          ],
        ),
      );
    });
  }

  Widget _buildTypeSelector() {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.changeTransactionType(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: controller.isExpense.value ? tErrorColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: controller.isExpense.value
                      ? [
                    BoxShadow(
                      color: tErrorColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove,
                      color: controller.isExpense.value ? Colors.white : Colors.grey[600],
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Expense',
                      style: TextStyle(
                        color: controller.isExpense.value ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.changeTransactionType(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !controller.isExpense.value ? tSuccessColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: !controller.isExpense.value
                      ? [
                    BoxShadow(
                      color: tSuccessColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: !controller.isExpense.value ? Colors.white : Colors.grey[600],
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Income',
                      style: TextStyle(
                        color: !controller.isExpense.value ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => TextField(
          controller: controller.amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: controller.isExpense.value ? tErrorColor : tSuccessColor,
          ),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: controller.isExpense.value ? tErrorColor : tSuccessColor,
            ),
            hintText: '0.00',
            hintStyle: TextStyle(
              color: Colors.grey[300],
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: tPrimaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        )),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final categories = controller.currentCategories;

          if (categories.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Center(
                child: Text(
                  'No categories available',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                final isSelected = controller.selectedCategory.value == category['name'];
                final flutterIcon = category['flutter_icon'] ?? Icons.category;
                final flutterColor = category['flutter_color'] ?? const Color(0xFF636E72);

                return GestureDetector(
                  onTap: () => controller.selectCategory(category['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? flutterColor : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? flutterColor : Colors.grey[300]!,
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          flutterIcon,
                          size: 18,
                          color: isSelected ? Colors.white : flutterColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category['display_name'] ?? category['name'] ?? 'Unknown',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Obx(() => Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: tPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: tPrimaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: tDarkColor,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note (optional)',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.noteController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add a note about this transaction...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: tPrimaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: tPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.updateDate(picked);
    }
  }

  void _handleSave() async {
    final success = await controller.addTransaction();
    if (success) {
      // Refresh data in home controller if it exists
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().refreshData();
      }

      // Close the screen and return success
      Navigator.of(context).pop(true);
    }
  }
}