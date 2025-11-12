import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/image_strings.dart';
import 'package:expense_tracker/src/features/core/screens/home/add_transaction_screen.dart';
import 'package:expense_tracker/src/features/core/screens/home/widgets/home_shimmer_loading_widget.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:expense_tracker/src/features/core/controllers/receipt_scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/utils/tab_handler.dart';
import 'package:expense_tracker/src/utils/theme/theme_controller.dart';
import 'package:expense_tracker/src/features/core/controllers/home_controller.dart';
import 'package:expense_tracker/src/features/core/controllers/currency_controller.dart';

// Import the separate widget files
import 'widgets/balance_card_widget.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/budget_section_widget.dart';
import 'widgets/recent_transactions_widget.dart';
import 'widgets/default_currency_prompt_modal.dart';
import 'package:expense_tracker/src/services/location_service.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  HomeScreenPageState createState() => HomeScreenPageState();
}

class HomeScreenPageState extends State<HomeScreenPage> {
  final authRepo = AuthenticationRepository.instance;
  late HomeController homeController;
  int currentPage = 0;
  
  // Store detected location data
  Map<String, String>? _detectedLocationData;

  @override
  void initState() {
    super.initState();
    homeController = Get.put(HomeController());
    // Initialize receipt scan controller
    Get.put(ReceiptScanController());
    // Initialize currency controller
    Get.put(CurrencyController());
    
    // Check if we need to show default currency prompt (will detect location first)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDefaultCurrencyPrompt();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabHandler = TabHandler();
    final themeController = Get.put(ThemeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(tabHandler),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (homeController.isLoading.value) {
        return const HomePageShimmerLoading();
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
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
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

              // Action Buttons - your original widget
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

              // Recent Transactions Section
              _buildRecentTransactionsSection(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRecentTransactionsSection() {
    return Obx(() {
      if (homeController.recentTransactions.isNotEmpty) {
        return RecentTransactionsSection(
          transactions: homeController.recentTransactions.toList(),
          formatNumber: homeController.formatNumber,
          onDeleteTransaction: _deleteTransaction,
          currencyCode: authRepo.currentCurrency.code,
        );
      } else {
        return _buildEmptyTransactionsState();
      }
    });
  }

  Widget _buildEmptyTransactionsState() {
    return Container(
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
                onPressed: _navigateToAddTransaction,
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
          SizedBox(
            height: 120,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No Recent Transactions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
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
    );
  }

  Widget _buildBottomNavigation(TabHandler tabHandler) {
    return BottomNavigationBar(
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
    );
  }

  void _showSetBudgetModal() {
    final TextEditingController budgetController = TextEditingController();

    // Pre-fill with current budget if it exists
    final currentBudget = homeController.budgetPeriod.value == 'Weekly'
        ? homeController.weeklyBudget.value
        : homeController.monthlyBudget.value;

    if (currentBudget > 0) {
      budgetController.text = currentBudget.toStringAsFixed(0);
    }

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
              if (currentBudget > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current ${homeController.budgetPeriod.value} Budget:',
                        style: const TextStyle(
                          color: tWhiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${authRepo.currentCurrency.code} ${homeController.formatNumber(currentBudget)}',
                        style: const TextStyle(
                          color: tWhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
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
            ElevatedButton(
              onPressed: homeController.isBudgetLoading.value
                  ? null
                  : () => _handleSetBudget(budgetController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: tTertiaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: tTertiaryColor.withOpacity(0.6),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: homeController.isBudgetLoading.value
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
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

  void _handleSetBudget(String budgetText) async {
    final newBudget = double.tryParse(budgetText);
    if (newBudget != null && newBudget > 0) {
      // Close the dialog first
      Navigator.of(context).pop();

      // Call the controller method to set budget via API
      await homeController.setBudget(homeController.budgetPeriod.value, newBudget);
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
  }

  void _deleteTransaction(dynamic transaction) {
    if (transaction.id != null) {
      homeController.deleteTransaction(transaction.id!);
    }
  }

  void _navigateToAddTransaction() async {
    final result = await Get.to(() => const AddTransactionScreen());
    if (result == true) {
      // Refresh data if transaction was added
      homeController.refreshData();
    }
  }

  Future<void> _detectLocationInBackground() async {
    try {
      print('Home: Starting background location detection...');
      // Detect location silently in background
      _detectedLocationData = await LocationService.detectCountryAndCurrency();
      if (_detectedLocationData != null) {
        print('Home: Location detected successfully: ${_detectedLocationData!['country']} (${_detectedLocationData!['currencyCode']})');
      } else {
        print('Home: Location detection returned null');
      }
    } catch (e) {
      // Silently fail - will use fallback in currency prompt
      print('Home: Location detection failed with error: $e');
      _detectedLocationData = null;
    }
  }

  Future<void> _checkDefaultCurrencyPrompt() async {
    try {
      final user = authRepo.appUser;
      
      // Check if user exists and default currency is not manually set
      if (user != null && !user.isDefaultCurrencyManuallySet) {
        // First detect location with timeout, then show the modal
        try {
          await _detectLocationInBackground().timeout(
            const Duration(seconds: 25), // Give enough time for location detection
            onTimeout: () {
              print('Home: Location detection timed out, proceeding with fallback');
              _detectedLocationData = null;
            },
          );
        } catch (e) {
          print('Home: Location detection failed: $e, proceeding with fallback');
          _detectedLocationData = null;
        }
        
        // Show the default currency prompt modal with detected location (or fallback)
        await _showDefaultCurrencyPrompt();
      }
    } catch (e) {
      print('Error checking default currency prompt: $e');
    }
  }

  Future<void> _showDefaultCurrencyPrompt() async {
    if (!mounted) return;

    // Use pre-detected location data or fallback
    String detectedCountry;
    String recommendedCurrencyCode;
    String recommendedCurrencyName;

    if (_detectedLocationData != null) {
      detectedCountry = _detectedLocationData!['country']!;
      recommendedCurrencyCode = _detectedLocationData!['currencyCode']!;
      recommendedCurrencyName = _detectedLocationData!['currencyName']!;
    } else {
      // Fallback if location detection failed
      detectedCountry = 'your location';
      recommendedCurrencyCode = 'USD';
      recommendedCurrencyName = 'US Dollar';
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DefaultCurrencyPromptModal(
          detectedCountry: detectedCountry,
          recommendedCurrencyCode: recommendedCurrencyCode,
          recommendedCurrencyName: recommendedCurrencyName,
          onCompleted: () {
            // Refresh user data after currency is set
            authRepo.refreshUserData();
          },
        ),
      ),
    );
  }
}