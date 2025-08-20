import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/image_strings.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/utils/tab_handler.dart';
import 'package:expense_tracker/src/utils/theme/theme_controller.dart';

// Import the separate widget files
import 'widgets/balance_card_widget.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/budget_section_widget.dart';
import 'widgets/recent_transactions_widget.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  HomeScreenPageState createState() => HomeScreenPageState();
}

class HomeScreenPageState extends State<HomeScreenPage> {
  // Sample data - replace with your data model
  final authRepo = AuthenticationRepository.instance;
  final double currentBalance = 65000.00;
  final double totalIncome = 120000.00;
  final double totalExpenses = 55000.00;

  // Budget data
  double weeklyBudget = 15000.00;
  double weeklySpent = 8500.00;
  double monthlyBudget = 60000.00;
  double monthlySpent = 45000.00;
  String budgetPeriod = 'Weekly'; // 'Weekly' or 'Monthly'

  final List<Transaction> recentTransactions = [
    Transaction(
      title: 'Freelance',
      category: 'Income',
      amount: 120000.00,
      date: 'Jul 9',
      time: 'hhh',
      icon: Icons.laptop_mac,
      isIncome: true,
    ),
    Transaction(
      title: 'Entertainment',
      category: 'Entertainment',
      amount: 5000.00,
      date: 'Jul 9',
      time: 'ghhh',
      icon: Icons.movie,
      isIncome: false,
    ),
    Transaction(
      title: 'Food',
      category: 'Food',
      amount: 50000.00,
      date: 'Jul 9',
      time: 'gfhh',
      icon: Icons.restaurant,
      isIncome: false,
    ),
  ];

  String _formatNumber(double number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(2);
  }

  void _showSetBudgetModal() {
    final TextEditingController budgetController = TextEditingController();
    final currentBudget =
    budgetPeriod == 'Weekly' ? weeklyBudget : monthlyBudget;
    budgetController.text = currentBudget.toStringAsFixed(0);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Set $budgetPeriod Budget'),
          backgroundColor: tPrimaryColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your ${budgetPeriod.toLowerCase()} budget amount:',
                style: TextStyle(
                  color: tWhiteColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '${authRepo.currentCurrency.code} ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(width: 1, color: tWhiteColor),
                  ),
                  hintText: 'Enter amount',
                ),
              ),
            ],
          ),
          actions: [
            // Cancel Button - Secondary Action
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: tWhiteColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: tWhiteColor, width: 1),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Primary Action Button
            ElevatedButton(
              onPressed: () {
                final newBudget = double.tryParse(budgetController.text);
                if (newBudget != null && newBudget > 0) {
                  setState(() {
                    if (budgetPeriod == 'Weekly') {
                      weeklyBudget = newBudget;
                    } else {
                      monthlyBudget = newBudget;
                    }
                  });
                  Navigator.of(context).pop();
                  Get.snackbar(
                    'Budget Updated',
                    '$budgetPeriod budget set to \$${_formatNumber(newBudget)}',
                    backgroundColor: Colors.green[600],
                    colorText: Colors.white,
                    borderRadius: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                    duration: const Duration(seconds: 3),
                  );
                } else {
                  Get.snackbar(
                    'Invalid Amount',
                    'Please enter a valid budget amount',
                    backgroundColor: Colors.red[600],
                    colorText: Colors.white,
                    borderRadius: 12,
                    margin: const EdgeInsets.all(16),
                    icon: const Icon(Icons.error_outline, color: Colors.white, size: 20),
                    duration: const Duration(seconds: 3),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tErrorColor, // Modern blue
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                side: BorderSide(color: tBgLightBtnColor),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Set Budget',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteTransaction(Transaction transaction) {
    setState(() {
      recentTransactions.remove(transaction);
    });
    Get.snackbar(
      'Delete Transaction',
      'Transaction "${transaction.title}" deleted',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    int page = 0;
    final tabHandler = TabHandler();
    final themeController = Get.put(ThemeController());
    final isDark = themeController.isDarkMode(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Image(image: AssetImage(tLogo), height: 50,),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Track Expense',
              style: TextStyle(
                color: tWhiteColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: tWhiteColor, size: 30,),
              onPressed: () {
                // Add notification functionality here
              },
            ),
          ],
        ),
        backgroundColor: tPrimaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            BalanceCard(
              currentBalance: currentBalance,
              totalIncome: totalIncome,
              totalExpenses: totalExpenses,
              formatNumber: _formatNumber,
              currencyCode: authRepo.currentCurrency.code
            ),

            const SizedBox(height: 24),

            // Action Buttons
            const ActionButtons(),

            const SizedBox(height: 24),

            // Budget Section
            BudgetSection(
              weeklyBudget: weeklyBudget,
              weeklySpent: weeklySpent,
              monthlyBudget: monthlyBudget,
              monthlySpent: monthlySpent,
              budgetPeriod: budgetPeriod,
              formatNumber: _formatNumber,
              currencyCode: authRepo.currentCurrency.code,
              onBudgetPeriodChanged: (period) {
                setState(() {
                  budgetPeriod = period;
                });
              },
              onSetBudget: _showSetBudgetModal,
            ),

            const SizedBox(height: 24),

            // Recent Transactions Section
            RecentTransactionsSection(
              transactions: recentTransactions,
              formatNumber: _formatNumber,
              onDeleteTransaction: _deleteTransaction,
              currencyCode: authRepo.currentCurrency.code,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        onTap: (index) {
          setState(() {
            page = index;
          });
          tabHandler.handleTabChange(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: tTertiaryColor,
        unselectedItemColor: tWhiteColor,
        backgroundColor: tPrimaryColor,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Summary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}