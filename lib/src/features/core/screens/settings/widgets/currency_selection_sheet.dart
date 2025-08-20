
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:flutter/material.dart';

class CurrencySelectionSheet extends StatefulWidget {
  final dynamic authRepo;
  final dynamic currentCurrency;

  const CurrencySelectionSheet({
    super.key,
    required this.authRepo,
    required this.currentCurrency,
  });

  @override
  State<CurrencySelectionSheet> createState() => _CurrencySelectionSheetState();
}

class _CurrencySelectionSheetState extends State<CurrencySelectionSheet> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> get filteredCurrencies {
    if (searchQuery.isEmpty) {
      return widget.authRepo.availableCurrencies;
    }
    return widget.authRepo.availableCurrencies
        .where((currency) =>
    currency.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        currency.code.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Currency',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: tDarkColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: TextStyle(color: tDarkColor),
              decoration: InputDecoration(
                hintText: 'Search currencies...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                      _searchController.clear();
                    });
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: tPrimaryColor, width: 1),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Results count
          if (searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filteredCurrencies.length} currencies found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ),

          if (searchQuery.isNotEmpty) const SizedBox(height: 8),

          // Currency list
          Expanded(
            child: filteredCurrencies.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No currencies found',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try searching with a different term',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredCurrencies.length,
              itemBuilder: (context, index) {
                final currency = filteredCurrencies[index];
                final isSelected = widget.currentCurrency.code == currency.code;

                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? tPrimaryColor.withOpacity(0.05) : Colors.transparent,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? tPrimaryColor.withOpacity(0.15)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(26),
                        border: isSelected
                            ? Border.all(
                          color: tPrimaryColor.withOpacity(0.3),
                          width: 2,
                        )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          currency.symbol,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? tPrimaryColor
                                : tDarkColor,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      currency.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? tPrimaryColor
                            : tDarkColor,
                      ),
                    ),
                    subtitle: Text(
                      currency.code,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected
                        ? Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: tPrimaryColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    )
                        : Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                    ),
                    onTap: () {
                      widget.authRepo.setCurrency(currency.code);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}