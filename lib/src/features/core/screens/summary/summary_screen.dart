import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/src/utils/tab_handler.dart';
import 'package:expense_tracker/src/utils/theme/theme_controller.dart';

class SummaryScreenPage extends StatefulWidget {
  const SummaryScreenPage({super.key});

  @override
  SummaryScreenPageState createState() => SummaryScreenPageState();
}

class SummaryScreenPageState extends State<SummaryScreenPage> {
  final authRepo = AuthenticationRepository.instance;
  String selectedPeriod = '30 Days';
  int currentPage = 1; // Summary tab index

  // Sample data based on the selected period
  Map<String, Map<String, double>> periodData = {
    '7 Days': {
      'income': 1000.00,
      'expenses': 250.00,
    },
    '30 Days': {
      'income': 4000.00,
      'expenses': 55000.00, // Matches the UI shown
    },
    '1 Year': {
      'income': 120000.00,
      'expenses': 65000.00,
    },
  };

  // Income data for the last 7 days
  List<Map<String, dynamic>> incomeData = [
    {'date': '2025-07-25', 'value': 500.0},
    {'date': '2025-07-26', 'value': 800.0},
    {'date': '2025-07-27', 'value': 300.0},
    {'date': '2025-07-28', 'value': 450.0},
    {'date': '2025-07-29', 'value': 1200.0},
    {'date': '2025-07-30', 'value': 600.0},
    {'date': '2025-07-31', 'value': 900.0},
  ];

  // Expense data for the last 7 days
  List<Map<String, dynamic>> expenseData = [
    {'date': '2025-07-25', 'value': 120.0},
    {'date': '2025-07-26', 'value': 250.0},
    {'date': '2025-07-27', 'value': 180.0},
    {'date': '2025-07-28', 'value': 90.0},
    {'date': '2025-07-29', 'value': 320.0},
    {'date': '2025-07-30', 'value': 200.0},
    {'date': '2025-07-31', 'value': 150.0},
  ];

  // Category expenses data
  List<Map<String, dynamic>> categoryExpenses = [
    {
      'category': 'food',
      'amount': 50000.00,
      'color': const Color(0xFF4F7DF3),
      'icon': Icons.restaurant,
      'percentage': 91.0,
    },
    {
      'category': 'entertainment',
      'amount': 5000.00,
      'color': const Color(0xFFFF6B6B),
      'icon': Icons.movie,
      'percentage': 9.0,
    },
  ];

  String _formatNumber(double number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(2);
  }

  String _formatCurrency(double number) {
    return '${authRepo.currentCurrency.code} ${number.toStringAsFixed(2)}';
  }

  void _exportData() {
    // Implement CSV export functionality
    Get.snackbar(
      'Export Data',
      'Data exported successfully to CSV',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Get the maximum value for chart scaling
  double _getMaxChartValue() {
    double maxIncome = incomeData.map((e) => e['value'] as double).reduce((a, b) => a > b ? a : b);
    double maxExpenses = expenseData.map((e) => e['value'] as double).reduce((a, b) => a > b ? a : b);
    return (maxIncome > maxExpenses ? maxIncome : maxExpenses) * 1.2; // Add 20% padding
  }

  @override
  Widget build(BuildContext context) {
    final tabHandler = TabHandler();
    final themeController = Get.put(ThemeController());
    final currentData = periodData[selectedPeriod]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Summary',
          style: TextStyle(
            color: tWhiteColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: tPrimaryColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Period Selector
            Row(
              children: [
                _buildPeriodButton('7 Days'),
                const SizedBox(width: 8),
                _buildPeriodButton('30 Days'),
                const SizedBox(width: 8),
                _buildPeriodButton('1 Year'),
              ],
            ),

            const SizedBox(height: 24),

            // Income and Expenses Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Income',
                    currentData['income']!,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Expenses',
                    currentData['expenses']!,
                    Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Daily Activity Chart
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Activity (Last 7 Days)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Income',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Expenses',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: true,
                          horizontalInterval: _getMaxChartValue() / 4,
                          getDrawingHorizontalLine: (value) {
                            return const FlLine(
                              color: Color(0xFFE0E0E0),
                              strokeWidth: 1,
                              dashArray: [3, 3],
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return const FlLine(
                              color: Color(0xFFE0E0E0),
                              strokeWidth: 1,
                              dashArray: [3, 3],
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() < incomeData.length) {
                                  String date = incomeData[value.toInt()]['date'];
                                  // Extract day and month from date (e.g., "2025-07-25" -> "25/07")
                                  List<String> dateParts = date.split('-');
                                  return Text(
                                    '${dateParts[2]}/${dateParts[1]}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: _getMaxChartValue() / 4,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  _formatNumber(value),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 6,
                        minY: 0,
                        maxY: _getMaxChartValue(),
                        lineBarsData: [
                          // Income line
                          LineChartBarData(
                            spots: incomeData
                                .asMap()
                                .entries
                                .map((entry) => FlSpot(
                              entry.key.toDouble(),
                              entry.value['value'],
                            ))
                                .toList(),
                            isCurved: true,
                            color: Colors.green,
                            barWidth: 3,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.green,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.green.withOpacity(0.1),
                            ),
                          ),
                          // Expenses line
                          LineChartBarData(
                            spots: expenseData
                                .asMap()
                                .entries
                                .map((entry) => FlSpot(
                              entry.key.toDouble(),
                              entry.value['value'],
                            ))
                                .toList(),
                            isCurved: true,
                            color: Colors.red,
                            barWidth: 3,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.red,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.red.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Expenses by Category
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expenses by Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: categoryExpenses.map((category) {
                          return PieChartSectionData(
                            color: category['color'],
                            value: category['percentage'],
                            title: '${category['percentage'].toInt()}%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Category Legend
                  ...categoryExpenses.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: category['color'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            category['icon'],
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category['category'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatCurrency(category['amount']),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Export Data Button
            Container(
              width: double.infinity,
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
              child: InkWell(
                onTap: _exportData,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Export Data (CSV)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildPeriodButton(String period) {
    final isSelected = selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C3E50) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xFF2C3E50) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          period,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}