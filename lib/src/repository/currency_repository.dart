import 'package:expense_tracker/src/features/core/models/currency_model.dart';

class CurrencyRepository {
  final List<Currency> _currencies = [
    Currency(code: 'USD', name: 'US Dollar', symbol: '\$'),
    Currency(code: 'EUR', name: 'Euro', symbol: '€'),
    // Add all other currencies from the previous list
  ];

  List<Currency> getAllCurrencies() => _currencies;

  Currency? getByCode(String code) =>
      _currencies.firstWhere((c) => c.code == code);
}