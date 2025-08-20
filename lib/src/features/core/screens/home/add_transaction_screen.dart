import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  AddTransactionScreenState createState() => AddTransactionScreenState();
}

class AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isExpense = true;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();

  // Enhanced categories with consistent styling
  final List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Food', 'icon': Icons.restaurant, 'color': Color(0xFFFF6B6B)},
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': Color(0xFF4ECDC4)},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Color(0xFF45B7D1)},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': Color(0xFF96CEB4)},
    {'name': 'Bills', 'icon': Icons.receipt_long, 'color': Color(0xFFFECA57)},
    {'name': 'Health', 'icon': Icons.local_hospital, 'color': Color(0xFFFF9FF3)},
    {'name': 'Education', 'icon': Icons.school, 'color': Color(0xFF54A0FF)},
    {'name': 'Travel', 'icon': Icons.flight, 'color': Color(0xFF5F27CD)},
    {'name': 'Other', 'icon': Icons.category, 'color': Color(0xFF636E72)},
  ];

  final List<Map<String, dynamic>> incomeCategories = [
    {'name': 'Salary', 'icon': Icons.work, 'color': Color(0xFF00B894)},
    {'name': 'Freelance', 'icon': Icons.laptop_mac, 'color': Color(0xFF6C5CE7)},
    {'name': 'Investment', 'icon': Icons.trending_up, 'color': Color(0xFF00CEC9)},
    {'name': 'Gift', 'icon': Icons.card_giftcard, 'color': Color(0xFFE84393)},
    {'name': 'Business', 'icon': Icons.business, 'color': Color(0xFF0984E3)},
    {'name': 'Other', 'icon': Icons.attach_money, 'color': Color(0xFF00B894)},
  ];

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = isExpense ? expenseCategories : incomeCategories;
    final isFormValid = amountController.text.isNotEmpty &&
        amountController.text != '0.00' &&
        selectedCategory != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
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
            child: ElevatedButton(
              onPressed: isFormValid ? _addTransaction : null,
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
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
        backgroundColor: tPrimaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Transaction type segmented control
            _buildTypeSelector(),
            const SizedBox(height: 24),

            // Amount input field
            _buildAmountInput(),
            const SizedBox(height: 24),

            // Category selection
            _buildCategorySection(categories),
            const SizedBox(height: 24),

            // Date and note
            _buildDateAndNoteSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
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
              onTap: () {
                if (!isExpense) {
                  setState(() {
                    isExpense = true;
                    selectedCategory = null;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isExpense ? tErrorColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isExpense
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
                      color: isExpense ? Colors.white : Colors.grey[600],
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Expense',
                      style: TextStyle(
                        color: isExpense ? Colors.white : Colors.grey[600],
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
              onTap: () {
                if (isExpense) {
                  setState(() {
                    isExpense = false;
                    selectedCategory = null;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !isExpense ? tSuccessColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: !isExpense
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
                      color: !isExpense ? Colors.white : Colors.grey[600],
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Income',
                      style: TextStyle(
                        color: !isExpense ? Colors.white : Colors.grey[600],
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
    );
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
        TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isExpense ? tErrorColor : tSuccessColor,
          ),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isExpense ? tErrorColor : tSuccessColor,
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
              borderSide: BorderSide(color: tPrimaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildCategorySection(List<Map<String, dynamic>> categories) {
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
        Container(
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
              final isSelected = selectedCategory == category['name'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = isSelected ? null : category['name'];
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? category['color'] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? category['color']! : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category['icon'],
                        size: 18,
                        color: isSelected ? Colors.white : category['color'],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category['name'],
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
        ),
      ],
    );
  }

  Widget _buildDateAndNoteSection() {
    return Column(
      children: [
        // Date Section
        Column(
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: tPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: tPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: tDarkColor
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Note Section
        Column(
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
              controller: noteController,
              maxLines: 2,
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
                  borderSide: BorderSide(color: tPrimaryColor, width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: tPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _addTransaction() {
    if (amountController.text.isEmpty || amountController.text == '0.00') {
      Get.snackbar(
        'Invalid Amount',
        'Please enter a valid amount',
        backgroundColor: tErrorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (selectedCategory == null) {
      Get.snackbar(
        'Category Required',
        'Please select a category',
        backgroundColor: tErrorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // Success feedback
    Get.snackbar(
      'Success',
      'Transaction added successfully',
      backgroundColor: tSuccessColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );

    Navigator.of(context).pop({
      'amount': double.parse(amountController.text),
      'category': selectedCategory,
      'isIncome': !isExpense,
      'date': selectedDate,
      'note': noteController.text,
    });
  }
}