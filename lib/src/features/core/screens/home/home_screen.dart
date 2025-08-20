import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/image_strings.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/utils/tab_handler.dart';
import 'package:expense_tracker/src/utils/theme/theme_controller.dart';
import 'package:expense_tracker/src/features/core/controllers/home_controller.dart';
import 'package:expense_tracker/src/features/core/models/transaction_display.dart';

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
  final authRepo = AuthenticationRepository.instance;
  final homeController = Get.put(HomeController());
  int currentPage = 0;

  void _showSetBudgetModal() {
    final TextEditingController budgetController = TextEditingController();
    final currentBudget = homeController.budgetPeriod.value == 'Weekly'
        ? homeController.weeklyBudget.value
        : homeController.monthlyBudget.value;

    budgetController.text = currentBudget > 0 ? currentBudget.toStringAsFixed(0) : '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Set ${homeController.budgetPeriod.value} Budget'),
          backgroundColor: tPrimaryColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your ${homeController.budgetPeriod.value.toLowerCase()} budget amount:',
                style: const TextStyle(
                  color: tWhiteColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixText: '${authRepo.currentCurrency.code} ',
                  prefixStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(width: 2, color: tTertiaryColor),
                  ),
                  hintText: 'Enter amount',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: tWhiteColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: tWhiteColor, width: 1),
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

            // Set Budget Button
            ElevatedButton(
              onPressed: () {
                final newBudget = double.tryParse(budgetController.text);
                if (newBudget != null && newBudget > 0) {
                  Navigator.of(context).pop();
                  homeController.setBudget(homeController.budgetPeriod.value, newBudget);
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
                backgroundColor: tTertiaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
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
        ));
      },
    );
  }

  void _deleteTransaction(TransactionDisplay transaction) {
    if (transaction.id != null) {
      homeController.deleteTransaction(transaction.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabHandler = TabHandler();
    final themeController = Get.put(ThemeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(
            image: AssetImage(tLogo),
            height: 50,
          ),
        ),
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
              icon: const Icon(Icons.notifications, color: tWhiteColor, size: 30),
              onPressed: () {
                // Add notification functionality here
              },
            ),
          ],
        ),
        backgroundColor: tPrimaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(tPrimaryColor),
            ),
          );
        }

        if (homeController.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  homeController.errorMessage.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => homeController.refreshData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor,
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => homeController.refreshData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Card with real data
                BalanceCard(
                  currentBalance: homeController.currentBalance.value,
                  totalIncome: homeController.totalIncome.value,
                  totalExpenses: homeController.totalExpenses.value,
                  formatNumber: homeController.formatNumber,
                  currencyCode: authRepo.currentCurrency.code,
                ),

                const SizedBox(height: 24),

                // Action Buttons
                const ActionButtons(),

                const SizedBox(height: 24),

                // Budget Section with real data
                BudgetSection(
                  weeklyBudget: homeController.weeklyBudget.value,
                  weeklySpent: homeController.weeklySpent.value,
                  monthlyBudget: homeController.monthlyBudget.value,
                  monthlySpent: homeController.monthlySpent.value,
                  budgetPeriod: homeController.budgetPeriod.value,
                  formatNumber: homeController.formatNumber,
                  currencyCode: authRepo.currentCurrency.code,
                  onBudgetPeriodChanged: (period) {
                    homeController.changeBudgetPeriod(period);
                  },
                  onSetBudget: _showSetBudgetModal,
                ),

                const SizedBox(height: 24),

                // Recent Transactions Section with real data
                homeController.recentTransactions.isNotEmpty
                    ? RecentTransactionsSection(
                  transactions: homeController.recentTransactions.toList(),
                  formatNumber: homeController.formatNumber,
                  onDeleteTransaction: _deleteTransaction,
                  currencyCode: authRepo.currentCurrency.code,
                )
                    : Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Transactions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to add transaction or transactions list
                            },
                            child: const Text(
                              'Add Transaction',
                              style: TextStyle(
                                color: tPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 120,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No Recent Transactions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Add your first transaction to get started',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
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