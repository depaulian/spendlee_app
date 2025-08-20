import 'package:expense_tracker/src/features/core/controllers/transaction_list_controller.dart';
import 'package:expense_tracker/src/features/core/screens/home/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/models/transaction_display.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  TransactionsListScreenState createState() => TransactionsListScreenState();
}

class TransactionsListScreenState extends State<TransactionsListScreen> {
  late TransactionsListController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TransactionsListController());
  }

  @override
  void dispose() {
    Get.delete<TransactionsListController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _buildTransactionsList()),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'All Transactions',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: tPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Obx(() => IconButton(
          icon: Icon(
            controller.isListView.value ? Icons.grid_view : Icons.list,
            color: Colors.white,
          ),
          onPressed: controller.toggleView,
        )),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
          // Type and Category Filters
          Row(
            children: [
              Expanded(child: _buildTypeFilter()),
              const SizedBox(width: 12),
              Expanded(child: _buildCategoryFilter()),
            ],
          ),
          const SizedBox(height: 12),
          // Date Range and Amount Filters
          Row(
            children: [
              Expanded(child: _buildDateRangeFilter()),
              const SizedBox(width: 12),
              Expanded(child: _buildAmountFilter()),
            ],
          ),
          const SizedBox(height: 12),
          // Search and Clear
          Row(
            children: [
              Expanded(child: _buildSearchFilter()),
              const SizedBox(width: 12),
              _buildClearFiltersButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFilter() {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.selectedType.value,
      decoration: InputDecoration(
        labelText: 'Type',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'all', child: Text('All')),
        DropdownMenuItem(value: 'expense', child: Text('Expenses')),
        DropdownMenuItem(value: 'income', child: Text('Income')),
      ],
      onChanged: (value) => controller.setTypeFilter(value ?? 'all'),
    ));
  }

  Widget _buildCategoryFilter() {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.selectedCategory.value,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        const DropdownMenuItem(value: 'all', child: Text('All Categories')),
        ...controller.availableCategories.map(
              (category) => DropdownMenuItem(
            value: category,
            child: Text(category),
          ),
        ),
      ],
      onChanged: (value) => controller.setCategoryFilter(value ?? 'all'),
    ));
  }

  Widget _buildDateRangeFilter() {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.selectedDateRange.value,
      decoration: InputDecoration(
        labelText: 'Date Range',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'all', child: Text('All Time')),
        DropdownMenuItem(value: 'today', child: Text('Today')),
        DropdownMenuItem(value: 'week', child: Text('This Week')),
        DropdownMenuItem(value: 'month', child: Text('This Month')),
        DropdownMenuItem(value: 'year', child: Text('This Year')),
      ],
      onChanged: (value) => controller.setDateRangeFilter(value ?? 'all'),
    ));
  }

  Widget _buildAmountFilter() {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.selectedAmountRange.value,
      decoration: InputDecoration(
        labelText: 'Amount',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'all', child: Text('All Amounts')),
        DropdownMenuItem(value: 'low', child: Text('< \$50')),
        DropdownMenuItem(value: 'medium', child: Text('\$50 - \$200')),
        DropdownMenuItem(value: 'high', child: Text('> \$200')),
      ],
      onChanged: (value) => controller.setAmountRangeFilter(value ?? 'all'),
    ));
  }

  Widget _buildSearchFilter() {
    return TextField(
      controller: controller.searchController,
      decoration: InputDecoration(
        labelText: 'Search transactions...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        suffixIcon: const Icon(Icons.search),
      ),
      onChanged: controller.setSearchFilter,
    );
  }

  Widget _buildClearFiltersButton() {
    return ElevatedButton(
      onPressed: controller.clearAllFilters,
      style: ElevatedButton.styleFrom(
        backgroundColor: tPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: const Text('Clear'),
    );
  }

  Widget _buildTransactionsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(tPrimaryColor),
              ),
              SizedBox(height: 16),
              Text('Loading transactions...'),
            ],
          ),
        );
      }

      if (controller.hasError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.refreshTransactions,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.filteredTransactions.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: controller.refreshTransactions,
        child: controller.isListView.value
            ? _buildListView()
            : _buildGridView(),
      );
    });
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = controller.filteredTransactions[index];
        return _buildTransactionCard(transaction, index);
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: controller.filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = controller.filteredTransactions[index];
        return _buildTransactionGridCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(TransactionDisplay transaction, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (transaction.isIncome ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color: transaction.isIncome ? Colors.green : Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: tDarkColor
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.category,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.date} • ${transaction.time}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.isIncome ? '+' : '-'}\$${controller.formatNumber(transaction.amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: transaction.isIncome ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              PopupMenuButton<String>(
                onSelected: (value) => _handleTransactionAction(value, transaction),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                child: Icon(Icons.more_vert, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionGridCard(TransactionDisplay transaction) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                transaction.icon,
                color: transaction.isIncome ? Colors.green : Colors.red,
                size: 20,
              ),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) => _handleTransactionAction(value, transaction),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                child: Icon(Icons.more_vert, color: Colors.grey[600], size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            transaction.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            transaction.category,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const Spacer(),
          Text(
            '${transaction.isIncome ? '+' : '-'}\$${controller.formatNumber(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: transaction.isIncome ? Colors.green : Colors.red,
            ),
          ),
          Text(
            transaction.date,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filters or add some transactions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed('/add-transaction'),
            style: ElevatedButton.styleFrom(
              backgroundColor: tPrimaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Transaction'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Get.to(()=> AddTransactionScreen());
        if (result == true) {
          controller.refreshTransactions();
        }
      },
      backgroundColor: tPrimaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _handleTransactionAction(String action, TransactionDisplay transaction) {
    switch (action) {
      case 'edit':
      // TODO: Navigate to edit transaction screen
        Get.snackbar(
          'Edit Transaction',
          'Edit functionality coming soon',
          backgroundColor: tPrimaryColor,
          colorText: Colors.white,
        );
        break;
      case 'delete':
        _showDeleteConfirmation(transaction);
        break;
    }
  }

  void _showDeleteConfirmation(TransactionDisplay transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text('Are you sure you want to delete this transaction?\n\n${transaction.title} - \$${controller.formatNumber(transaction.amount)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (transaction.id != null) {
                controller.deleteTransaction(transaction.id!);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}