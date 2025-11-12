import 'package:expense_tracker/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/core/controllers/currency_controller.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';

class DefaultCurrencyPromptModal extends StatefulWidget {
  final String detectedCountry;
  final String recommendedCurrencyCode;
  final String recommendedCurrencyName;
  final VoidCallback? onCompleted;

  const DefaultCurrencyPromptModal({
    super.key,
    required this.detectedCountry,
    required this.recommendedCurrencyCode,
    required this.recommendedCurrencyName,
    this.onCompleted,
  });

  @override
  State<DefaultCurrencyPromptModal> createState() => _DefaultCurrencyPromptModalState();
}

class _DefaultCurrencyPromptModalState extends State<DefaultCurrencyPromptModal> {
  final CurrencyController _currencyController = Get.find<CurrencyController>();
  bool _isLoading = false;

  Future<void> _setCurrency(String currencyCode) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _currencyController.setCurrency(currencyCode);
      
      if (success) {
        // Close the modal
        if (mounted) {
          Navigator.of(context).pop();
        }
        
        // Call completion callback
        if (widget.onCompleted != null) {
          widget.onCompleted!();
        }
        
        Get.snackbar(
          'Currency Updated',
          'Your default currency has been set to $currencyCode',
          backgroundColor: Colors.green[600],
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
          icon: const Icon(Icons.check_circle, color: Colors.white, size: 20),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update currency. Please try again.',
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.error_outline, color: Colors.white, size: 20),
        duration: const Duration(seconds: 3),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showCurrencySelection() async {
    if (!mounted) return;
    Navigator.of(context).pop(); // Close current modal
    
    // Import and show the currency selection sheet
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CurrencySearchBottomSheet(
        onCurrencySelected: (currencyCode) async {
          await _setCurrency(currencyCode);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button dismissal
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Location icon
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
                        color: tPrimaryColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'Set Your Currency',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Description
                Column(
                  children: [
                    Text(
                      'Which currency would you like to use to track your expenses and budgets?',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    if (widget.detectedCountry != 'your location') ...[
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: 'We noticed you\'re in '),
                            TextSpan(
                              text: widget.detectedCountry,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: ', so ${widget.recommendedCurrencyCode} might work best!',
                              style: const TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Text(
                        'We recommend starting with a popular currency option.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Currency options
                if (_isLoading) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text(
                    'Updating currency...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ] else ...[
                  // Recommended currency button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setCurrency(widget.recommendedCurrencyCode),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tPrimaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        '${widget.recommendedCurrencyCode} (${widget.recommendedCurrencyName})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // USD option (only show if recommended currency is not USD)
                  if (widget.recommendedCurrencyCode != 'USD') ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _setCurrency('USD'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'USD (US Dollar)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // Other currencies option
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _showCurrencySelection,
                      style: TextButton.styleFrom(
                        foregroundColor: tPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Other Currencies',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrencySearchBottomSheet extends StatefulWidget {
  final Function(String) onCurrencySelected;

  const _CurrencySearchBottomSheet({
    required this.onCurrencySelected,
  });

  @override
  State<_CurrencySearchBottomSheet> createState() => _CurrencySearchBottomSheetState();
}

class _CurrencySearchBottomSheetState extends State<_CurrencySearchBottomSheet> {
  final AuthenticationRepository _authRepo = AuthenticationRepository.instance;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> get _filteredCurrencies {
    if (_searchQuery.isEmpty) {
      return _authRepo.availableCurrencies;
    }
    return _authRepo.availableCurrencies
        .where((currency) =>
            currency.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            currency.code.toLowerCase().contains(_searchQuery.toLowerCase()))
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
                  _searchQuery = value;
                });
              },
              style: TextStyle(color: tDarkColor),
              decoration: InputDecoration(
                hintText: 'Search currencies...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
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
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_filteredCurrencies.length} currencies found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          
          if (_searchQuery.isNotEmpty) const SizedBox(height: 8),
          
          // Currency list
          Expanded(
            child: _filteredCurrencies.isEmpty
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
                    itemCount: _filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = _filteredCurrencies[index];
                      final isSelected = _authRepo.currentCurrency.code == currency.code;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected ? tPrimaryColor.withValues(alpha: 0.05) : Colors.transparent,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? tPrimaryColor.withValues(alpha: 0.15)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(26),
                              border: isSelected
                                  ? Border.all(
                                color: tPrimaryColor.withValues(alpha: 0.3),
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
                            Navigator.pop(context);
                            widget.onCurrencySelected(currency.code);
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